import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/classes/equipment.dart';

class QRCodeDraw extends StatelessWidget {
  QRCodeDraw(this._equipment, this._globalKey);
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
              version: 6,
              size: 250,
              /*onError: (ex) {
                print("[QR] ERROR - $ex");
              },*/
            ),
          ),
        ),
      ),
    );
  }
}