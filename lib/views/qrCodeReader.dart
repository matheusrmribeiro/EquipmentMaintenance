import 'package:flutter/material.dart';
import 'package:qrcode/methods/qrCode.dart';

class QRCodeReader extends StatelessWidget{
  final TextEditingController controllerText = TextEditingController();
  final QRCodeMethods qrCode = QRCodeMethods();

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerText,
              autocorrect: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            RaisedButton(
              child: Text("Scan"),
              onPressed: () => qrCode.scanCode().then((value){ controllerText.text = value[1]; })
            )
          ],
        ),
      ),
    );
  }
}