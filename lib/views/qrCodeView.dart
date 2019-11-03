import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:qrcode/methods/qrCode.dart';
import 'package:qrcode/views/qrCodeDraw.dart';

class QRCodeView extends StatelessWidget {
  QRCodeView(this._equipment);
  final Equipment _equipment;

  final GlobalKey _globalKey = GlobalKey();
  final qrCode = QRCodeMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Equipamento cadastrado com \nsucesso!", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,)
                ],
              ),
              Expanded(child: Container()),
              Text(_equipment.description,
                style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                softWrap: true,
              ),
              QRCodeDraw(_equipment, _globalKey),
              Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){ qrCode.captureAndSharePng(_globalKey, "qrCode.png", _equipment.description); },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Text("Compartilhar", style: TextStyle(color: Colors.white),),
                )
              ),
              Expanded(child: Container()),
            ],
          ),
        )
      )
    );
  }
}