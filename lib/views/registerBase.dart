import '../classes/defaultResponse.dart';
import '../classes/registerSteps.dart';
import 'package:flutter/material.dart';

class BaseRegister extends StatefulWidget{
  BaseRegister({@required this.title, this.bloc, this.steps});
  final String title;
  final bloc;
  final List<RegisterSteps> steps;

  _BaseRegisterState createState() => _BaseRegisterState();
}

class _BaseRegisterState extends State<BaseRegister> with SingleTickerProviderStateMixin{
  final formKey = GlobalKey<FormState>();
  TabController controller;
  final padding = EdgeInsets.fromLTRB(10, 10, 10, 0);
  List<GlobalKey<FormState>> stepKeys = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: widget.steps.length);
    widget.bloc.tabController = controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  GlobalKey<FormState> newKey(){
    stepKeys.add(GlobalKey<FormState>());
    return stepKeys.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(        
        title: Text(widget.title),
        centerTitle: true        
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: widget.bloc.outError,
            builder: (context, snapshot){
              if (!snapshot.hasData)
                return Container();

              return ContainerError(snapshot.data);
            },
          ),
          buildScreen()
        ],
      )
    );
  }

  Widget buildScreen(){
    return Container(
      child: Column(
        children: <Widget>[
          buildRegisterPageControl(),
          buildNavigatorButtons()
        ],
      )
    );
  }

  Widget buildRegisterPageControl(){
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: widget.steps.map((Widget value) => value).toList(),
      )
    );
  }

  Widget buildNavigatorButtons(){
    return StreamBuilder(
      initialData: 0,
      stream: widget.bloc.outTabControllIndex,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildBackButton(snapshot.data),
              buildNextButton(snapshot.data)
            ],
          ),
        );
      }
    );
  }

  Widget buildBackButton(tabControllerIndex){
    if (tabControllerIndex<=0) {
      return Container();
    } 
    else{
      return RaisedButton(
        child: Text("Voltar"),
        onPressed: (){
          FocusScope.of(context).requestFocus(FocusNode());
          widget.bloc.inTabControllIndex.add(controller.index-1);
        },
      );
    }
  }

  Widget buildNextButton(tabControllerIndex){
    return StreamBuilder(
      stream: widget.bloc.outNextButtonVisibility,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container();
          
        return Visibility(
          visible: snapshot.data,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: (tabControllerIndex>=controller.length-1) ? Text("Finalizar") : Text("Próximo"),
            onPressed: (){
              // widget.bloc.inError.add(DefaultResponse(code: "ERROR", value:"TESTE"));
              // return;
              FocusScope.of(context).requestFocus(FocusNode());
              var form = widget.steps[controller.index].formKey.currentState;
              if (form.validate()) {
                form.save();

                if ((tabControllerIndex+1>=controller.length))
                  finalize();
                else{
                  widget.bloc.inError.add(null);
                  widget.bloc.inTabControllIndex.add(controller.index+1);
                }
              }
            },
          ),
        );
      }
    );
  }

  void finalize() async{
    await widget.bloc.save();
    if (widget.bloc.registerState.code=="OK")
      Navigator.pop(context, true);
    else{
      widget.bloc.inTabControllIndex.add(0);
    }
  }
}

class ContainerError extends StatefulWidget {
  ContainerError(this.error);
  final DefaultResponse error;

  @override
  _ContainerErrorState createState() => _ContainerErrorState();
}

class _ContainerErrorState extends State<ContainerError> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<Offset> offset;
  
  @override
  initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset(0,-10), end: Offset(0.0, 0.5)).animate(_controller);
    super.initState();
    _controller.forward();
    closeErrorHint();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void closeErrorHint() {
    Future.delayed(Duration(seconds: 10)).then((_){
      _controller.reverse().then((_){
        dispose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: Card(
        margin: EdgeInsets.only(left: 20, right: 20),
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(Icons.info_outline),
              Container(width: 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: widget.error.value,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Container(height: 5),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey
                        ),
                        text: widget.error.addtionalInfo,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}