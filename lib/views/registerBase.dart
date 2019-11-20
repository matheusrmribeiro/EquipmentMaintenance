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
      body: buildScreen()
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
          controller.animateTo(controller.index-1);
          widget.bloc.inTabControllIndex.add(controller.index);
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
              FocusScope.of(context).requestFocus(FocusNode());
              var form = widget.steps[controller.index].formKey.currentState;
              if (form.validate()) {
                form.save();

                if ((tabControllerIndex+1>=controller.length))
                  finalize();
                else{
                  controller.animateTo(controller.index+1);
                  widget.bloc.inTabControllIndex.add(controller.index);
                }
              }
            },
          ),
        );
      }
    );
  }

  void finalize(){
    if (widget.bloc.save())
      Navigator.pop(context, true);
  }

}