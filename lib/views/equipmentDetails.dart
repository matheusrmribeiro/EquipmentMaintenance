import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/bloc/blocEquipment.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:qrcode/methods/qrCode.dart';

/* Fazer constructor aqui para abrir direto no leitor para quando for busca por QRCode */
class EquipmentDetails extends StatelessWidget{

  EquipmentDetails(this.equipment);

  final Equipment equipment;
  final bloc = BlocProvider.getBloc<BlocEquipment>();

  @override
  Widget build(BuildContext context){
    bloc.inEquipmentController.add(equipment);
    if (equipment == null)
      bloc.scan();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do equipamento'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.border_color),
        onPressed: () => bloc.newMaintenance(),
      ),
      body: StreamBuilder(
        stream: bloc.outEquipmentController,
        builder: (context, snapshot){
          if (snapshot.hasData)
            return Body(snapshot.data);
          else if (snapshot.hasError)
            return Container(
              child: Text(snapshot.error.toString()),
            );
          else
            return Container();
        },
      )
    );
  }

  void readQRCode() async {
    final _qrCode = QRCodeMethods();
    _qrCode.scanCode();
  }
}

class Body extends StatelessWidget {
  Body(this._equipment);
  
  final Equipment _equipment;
  final _qrCodeWidth = 150;
  GlobalKey globalKey = GlobalKey();
  final QRCodeMethods qrCode = QRCodeMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5),
            height: 160,
            child: Row(
              children: <Widget>[
                DrawQRCode(_equipment, globalKey),
                Container(
                  width: (MediaQuery.of(context).size.width - _qrCodeWidth - 5),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_equipment.description,
                        softWrap: true,
                        style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Row(
                        children: <Widget>[
                          Text("Andar:"),
                          Expanded(child: Container()),
                          Text(_equipment.floor)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Sala:"),
                          Expanded(child: Container()),
                          Text(_equipment.room)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Manutenção:"),
                          Expanded(child: Container()),
                          Text(formatDate(_equipment.nextMaintenance, ["dd", "/", "mm", "/", "yyyy"]))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () { qrCode.captureAndSharePng(globalKey, "qrCode.png", _equipment.description); },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            child: Text("Compartilhar", style: TextStyle(color: Colors.white),),
                          )
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.6),
            height: 30,
            child: Center(
              child: Text("Log de manutenções", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: LogList(_equipment.id)
          )
        ]
      )
    );
  }
}

class LogList extends StatelessWidget {
  LogList(this.id);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: StreamBuilder(
        stream: Firestore.instance.collection("maintenanceLog").where("equipment", isEqualTo: id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data.documents.map((document){
              return LogItem(document);
              }).toList()
            );
        },
      )
    );
  }
}
class LogItem extends StatelessWidget {
  LogItem(this.item);
  final item;

  @override
  Widget build(BuildContext context) {
    Timestamp date = item["date"];

    String subtitle = item["inPeriod"] ? "Feito no prazo" : "Feito fora do prazo";

    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey)
        )
      ),
      child: ListTile(
        title: Text(formatDate(date.toDate(), ["dd", "/", "mm", "/", "yyyy"])),
        subtitle: Text(subtitle),
        onTap: (){},
      ),
    );
  }
}

class DrawQRCode extends StatelessWidget {
  DrawQRCode(this._equipment, this._globalKey);
  final Equipment _equipment;
  final GlobalKey _globalKey;
  final double _qrCodeWidth = 150;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5),
      child: Container(
        width: _qrCodeWidth,
        child: Hero(
          tag: _equipment.id,
          child: RepaintBoundary(
            key: _globalKey,
            child: QrImage(
              backgroundColor: Colors.grey,
              data: json.encode(_equipment.toJson()),
              size: 250,
            ),
          ),
        ),
      ),
    );
  }
}