import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/classes/equipment.dart';

class QRCodeDraw extends StatelessWidget {
  QRCodeDraw(this._equipment, this._globalKey, this.size);
  final Equipment _equipment;
  final GlobalKey _globalKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 3)
        ),
        width: size,
        height: size,
        child: Hero(
          tag: _equipment.id,
          child: RepaintBoundary(
            key: _globalKey,
            child: QrImage(
              foregroundColor: Theme.of(context).primaryColor,
              data: json.encode(_equipment.toJson()),
            ),
          ),
        ),
      ),
    );
  }
}