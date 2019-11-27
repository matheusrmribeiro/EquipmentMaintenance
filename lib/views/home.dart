import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrcode/bloc/blocAuth.dart';
import 'package:qrcode/bloc/blocEquipment.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:qrcode/globals.dart';
import 'package:qrcode/methods.dart';
import 'package:qrcode/views/equipmentDetails.dart';
import 'package:qrcode/views/qrCodeGenerator.dart';
import 'settings.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Header(),
            Expanded(
              child: Body(),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.1,
        overlayColor: Theme.of(context).primaryColor,
        tooltip: "Ações",
        children: [
          SpeedDialChild(
            label: "Ler QRCode",
            labelBackgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.settings_overscan),
            onTap: (){
              Navigation navigation = Navigation();
              navigation.navigaTo(context, EquipmentDetails(null));
            }
          ),
          SpeedDialChild(
            label: "Novo equipamento",
            labelBackgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.add),
            onTap: (){
              Navigation navigation = Navigation();
              navigation.navigaTo(context, QRCodeGenerator());
            },
          )
        ],
      )
    );
  }
}

class Header extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocAuth>();
  final PeriodoDia periodo = PeriodoDia();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
          color: Theme.of(context).primaryColor,
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(periodo.descricao()+ ", ",
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 25,
                        ),
                      ),
                      StreamBuilder(
                        stream: bloc.outAuthStatus,
                        builder: (context, snapshot){
                          return Text(bloc.currentUser.nickname??"Usuário",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          );
                        },
                      ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: PopupMenuButton(
                        tooltip: "Conta",
                        icon: Icon(FontAwesomeIcons.userCog),
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>( child: const Text('Sair'), value: 'exit'),
                          PopupMenuItem<String>( child: const Text('Configurações'), value: 'settings'),
                        ],
                        onSelected: (value){
                          if (value=='exit')
                            bloc.signedOut();
                          else if (value=='settings') {
                            Navigation navigation = Navigation();
                            navigation.navigaTo(context, Settings());
                          }
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget{
  final bloc = BlocProvider.getBloc<BlocEquipment>();

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: StreamBuilder(
        stream: Firestore.instance.collection("equipment").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            return ListView(
              children: snapshot.data.documents.map((document){
                return EquipmentItem(document);
              }).toList()
            );
          }
        },
      ),
    );
  }
}

class EquipmentItem extends StatelessWidget {
  EquipmentItem(this._item) : _documentID = _item.documentID;
  final DocumentSnapshot _item;
  final String _documentID;
  final Equipment _equipment = Equipment();

  @override
  Widget build(BuildContext context) {
    _equipment.snapToClass(_item);

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white)
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        if(direction == DismissDirection.startToEnd)
          Firestore.instance.collection("equipment").document(_documentID).delete();
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: colorLevel(_equipment.nextMaintenance),
        child: Card(
          margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigation navigation = Navigation();
                  navigation.navigaTo(context, EquipmentDetails(_equipment));
                },
                child: Column(
                  children: <Widget>[                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_equipment.name, 
                                style: TextStyle(
                                  fontSize: 20, 
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold)),
                              Container(height: 5,),
                              Text("${_equipment.floor}º andar, sala ${_equipment.room}"),
                              Text("Próxima manutenção: ${formatDate(_equipment.nextMaintenance, ["dd", "/", "mm", "/", "yyyy"])}"),
                            ],
                          ),
                        ),
                        Container(                          
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Hero(
                            tag: _documentID,
                            child: Icon(Icons.lightbulb_outline, color: colorLevel(_equipment.nextMaintenance),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}