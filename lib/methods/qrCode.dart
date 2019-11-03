import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class QRCodeMethods{

  Future<void> captureAndSharePng(GlobalKey globalKey, String imageName, String description) async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData imageShare = await image.toByteData(format: ImageByteFormat.png);

      await Share.file(description, imageName, imageShare.buffer.asUint8List(), 'image/png');

    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<dynamic>> scanCode() async {
    String error = 'OK';
    String qrCode = '';
    try {
      qrCode = await BarcodeScanner.scan();
    }
    catch (e) {
      /*if (e.code == BarcodeScanner.CameraAccessDenied)
        error = 'É preciso permissão para acessar a câmera!';*/
      error = "Erro: "+ e.toString();
    }
    
    return [error, qrCode];
  }
}