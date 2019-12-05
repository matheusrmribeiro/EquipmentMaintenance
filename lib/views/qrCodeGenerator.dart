import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcode/bloc/blocQRCodeGenerator.dart';
import 'package:qrcode/methods/qrCode.dart';
import 'package:qrcode/views/qrCodeDraw.dart';
import 'package:qrcode/widgets/customDropdownButtonFormField.dart';
import 'package:qrcode/widgets/customTextFormField.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QRCodeGeneratorState();
}

class QRCodeGeneratorState extends State<QRCodeGenerator> with TickerProviderStateMixin {
  final bloc = BlocProvider.getBloc<BlocQRCodeGenerator>();

  TabController _controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    bloc.inIsRegister.add(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSave(BuildContext context) async {
    var form = _formKey.currentState;
    if(form.validate()){
      form.save();

      DocumentReference docResult = await Firestore.instance.collection("equipment")
                                          .add(bloc.dataObject.toJson(removeId: true, useTimestamp: true));

      DocumentSnapshot doc = await docResult.get();

      bloc.dataObject.snapToClass(doc);
      
      FocusScope.of(context).requestFocus(FocusNode());
      bloc.inEquipmentController.add(bloc.dataObject);
      bloc.inIsRegister.add(false);
      _controller.index = 1;
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(20)
                )
              ),
              height: 80, 
              child: Center(
                child: StreamBuilder(
                  stream: bloc.outIsRegister,
                  builder: (context, snapshot){
                    if (!snapshot.hasData)
                      return Container();
                      
                    return Text((snapshot.data) ? "Equipamento" : bloc.getName(),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                      )
                    );
                  }    
                )
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: <Widget>[
                  Center(
                    child: FieldsForm(_formKey)
                  ),
                  StreamBuilder(
                    stream: bloc.outEquipmentController,
                    builder: (context, snapshot){
                      if (!snapshot.hasData)
                        return Container();

                      return Center(
                        child: QRCodeDraw(snapshot.data, _formKey, MediaQuery.of(context).size.width*0.7)
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: Tooltip(
                      message: "Cancelar",
                      child: RaisedButton(
                        padding: EdgeInsets.all(0),
                        elevation: 4,
                        color: Colors.white,
                        onPressed: (){ 
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        child: Center(child: Icon(Icons.arrow_back, color: Colors.grey,)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: 200,
                    child: StreamBuilder(
                      stream: bloc.outIsRegister,
                      builder: (context, snapshot){
                        if (!snapshot.hasData)
                          Container();
                          
                        return Tooltip(
                          message: (snapshot.data) ? "Salvar" : "Compartilhar",
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            color: Theme.of(context).primaryColor,
                            onPressed: (){ 
                              if (snapshot.data)
                                onSave(context);
                              else {
                                final qrCode = QRCodeMethods();
                                qrCode.captureAndSharePng(_formKey, "qrCode.png", bloc.getDescription());
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100))),
                            child: Center(
                              child: Icon((snapshot.data) ? Icons.save : Icons.share, 
                                color: Colors.white,)),
                          ),
                        );
                      },
                    )
                  )
                ],
              ),
            )            
          ],
        ),
      )
    );
  }   
}

class FieldsForm extends StatelessWidget {
  FieldsForm(this.formKey);

  final GlobalKey<FormState> formKey;
  final bloc = BlocProvider.getBloc<BlocQRCodeGenerator>();

  final List<String> floorList = ["1", "2", "3", "4", "5"];
  final List<String> roomList = ["A1", "A2", "A3", "A4", "A5", "B1", "B2"];

  final TextEditingController _nextMaintenanceController =  TextEditingController();
  final TextEditingController _maintenancePeriodController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime _nextMaintenanceValue;
    GlobalKey<FormState> _formKey = formKey;

    _maintenancePeriodController.addListener((){
      DateTime date = DateTime.now();
      _nextMaintenanceValue = date.add(Duration(days: int.parse(_maintenancePeriodController.text)));
      _nextMaintenanceController.text = formatDate(_nextMaintenanceValue, ["dd", "/", "mm", "/", "yyyy"]);
    });

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CTextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                labelText: 'Nome',
                validator: (value){ return value == "" ? "Obrigatório!" : null;},
                onSaved: (value) => bloc.dataObject.name = value,
              ),
              CTextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                labelText: 'Descrição',
                validator: (value){ return value == "" ? "Obrigatório!" : null;},
                onSaved: (value) => bloc.dataObject.description = value,
              ),
              StreamBuilder(
                stream: bloc.outFloor,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                    
                  return CDropdownButtonFormField(
                    labelText: "Andar",
                    value: snapshot.data,
                    items: floorList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(children: <Widget>[Text(value)]),
                      );
                    }).toList(),
                    onChanged: (value) => bloc.inFloor.add(value),
                    onSaved: (value) => bloc.dataObject.floor = value,
                    validator: (value){ return value == null ? "Obrigatório!" : null;},
                  );
                },
              ),
              StreamBuilder(
                stream: bloc.outRoom,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                    
                    return CDropdownButtonFormField(
                    labelText: "Sala",
                    value: snapshot.data,
                    items: roomList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(children: <Widget>[Text(value)]),
                      );
                    }).toList(),
                    onChanged: (value) => bloc.inRoom.add(value),
                    onSaved: (value) => bloc.dataObject.room = value,
                    validator: (value){ return value == null ? "Obrigatório!" : null;},
                  );
                },
              ),
              CTextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                textInputAction: TextInputAction.done,
                controller: _maintenancePeriodController,
                labelText: 'Tempo de manutenção (dias)',
                validator: (value){ return value == "" ? "Obrigatório!" : null;},
                onSaved: (value) => bloc.dataObject.maintenancePeriod = int.parse(value),
              ),
              CTextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                controller: _nextMaintenanceController,
                enabled: false,
                labelText: 'Próxima manutenção',
                validator: (value){ return value == "" ? "Obrigatório!" : null;},
                onSaved: (value) => bloc.dataObject.nextMaintenance = _nextMaintenanceValue,
              ),
            ]
          ),
        )
      ),
    );
  }
}