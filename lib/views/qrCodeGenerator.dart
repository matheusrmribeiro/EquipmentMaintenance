import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcode/bloc/blocQRCodeGenerator.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:qrcode/views/qrCodeView.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QRCodeGeneratorState();
}

class QRCodeGeneratorState extends State<QRCodeGenerator> with TickerProviderStateMixin {
  final bloc = BlocProvider.getBloc<BlocQRCodeGenerator>();

  TabController _controller;
  QRCodeView _showQRCode;
  bool _showSaveButton = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerar QRCode'),
        actions: <Widget>[
          (_showSaveButton)
          ?
            IconButton(
              icon: Icon(Icons.save),
              onPressed: onSave,
            )
          :
            Container()
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
            FieldsForm(_formKey),
            StreamBuilder(
              stream: bloc.outEquipmentController,
              builder: (context, snapshot){
                return QRCodeView(snapshot.data);
              },
            ),
          ],
        ),
      )
    );
  }

  void onSave() async {
    var form = _formKey.currentState;
    if(form.validate()){
      form.save();

      DocumentReference docResult = await Firestore.instance.collection("equipment")
                                          .add(bloc.dataObject.toJson(removeId: true, useTimestamp: true));

      DocumentSnapshot doc = await docResult.get();

      bloc.dataObject.snapToClass(doc);
      
      /* Verificar isso aqui */
      FocusScope.of(context).requestFocus(FocusNode());
      _showSaveButton = false;
      _controller.index = 1;
      bloc.inEquipmentController.add(bloc.dataObject);
    }
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
  DateTime _nextMaintenanceValue;

  @override
  Widget build(BuildContext context) {
    _maintenancePeriodController.addListener((){
      DateTime date = DateTime.now();
      _nextMaintenanceValue = date.add(Duration(days: int.parse(_maintenancePeriodController.text)));
      _nextMaintenanceController.text = formatDate(_nextMaintenanceValue, ["dd", "/", "mm", "/", "yyyy"]);
    });

    GlobalKey<FormState> _formKey = formKey;
    
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Descrição',
              ),
              validator: (value){ return value == "" ? "Obrigatório!" : null;},
              onSaved: (value) => bloc.dataObject.description = value,
            ),
            StreamBuilder(
              stream: bloc.outFloor,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container();
                  
                return DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: "Andar"
                  ),
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
                  
                  return DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: "Sala"
                  ),
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
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              controller: _maintenancePeriodController,
              decoration: InputDecoration(
                labelText: 'Tempo de manutenção (dias)',
              ),
              validator: (value){ return value == "" ? "Obrigatório!" : null;},
              onSaved: (value) => bloc.dataObject.maintenancePeriod = int.parse(value),
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              controller: _nextMaintenanceController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Próxima manutenção',
              ),
              validator: (value){ return value == "" ? "Obrigatório!" : null;},
              onSaved: (value) => bloc.dataObject.nextMaintenance = _nextMaintenanceValue,
            ),
          ]
        ),
      )
    );
  }
}