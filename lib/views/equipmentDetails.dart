import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../bloc/blocEquipment.dart';
import '../classes/equipment.dart';
import '../methods/qrCode.dart';
import 'qrCodeDraw.dart';

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
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.1,
        overlayColor: Theme.of(context).primaryColor,
        tooltip: "Ações",
        children: [
          SpeedDialChild(
            label: "Nova manutenção",
            labelBackgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.border_color),
            onTap: () => bloc.newMaintenance(),
          ),
          SpeedDialChild(
            label: "Compartilhar",
            labelBackgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.share),
            onTap: (){
              final QRCodeMethods qrCode = QRCodeMethods();
              qrCode.captureAndSharePng(Body.getKey(), "qrCode.png", Body.equipment.description);
            },
          )
        ],
      )
    );
  }

  void readQRCode() async {
    final _qrCode = QRCodeMethods();
    _qrCode.scanCode();
  }
}

class Body extends StatelessWidget {
  Body(Equipment _equipment){
    equipment = _equipment;
  }
  
  static GlobalKey getKey() => globalKey;

  static Equipment equipment;
  static GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: QRCodeDraw(equipment, globalKey, 150)
                ),
                Text(equipment.name,
                  softWrap: true,
                  style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            height: 160,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 5, right: 5, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("Localização",
                          softWrap: true,
                          style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                          )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Andar:"),
                          Text(equipment.floor)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Sala:"),
                          Text(equipment.room)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Manutenção:"),
                          Text(formatDate(equipment.nextMaintenance, ["dd", "/", "mm", "/", "yyyy"]))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: Text("Últimas manutenções",
              softWrap: true,
              style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey
              )
            ),
          ),
          Expanded(
            child: LogList(equipment.id)
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
    String description = item["description"];

    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Text(formatDate(date.toDate(), ["dd", "/", "mm", "/", "yyyy"]),
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey
              )
            ),
            Text(" - "+ subtitle,
              softWrap: true,
              style: TextStyle(
                color: Colors.grey
              )
            )
          ],
        ),
        subtitle: Text(description??"",
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey
          )
        ),
        onTap: (){},
      ),
    );
  }
}