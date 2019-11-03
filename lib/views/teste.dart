/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraState extends StatelessWidget {
  Future<CameraController> setupCameras() async {
    try {
      List<CameraDescription> cameras;
      cameras = await availableCameras();
      CameraController controller = CameraController(cameras[0], ResolutionPreset.high);
      await controller.initialize();

    } on CameraException catch (_) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setupCameras(),
      builder: (context, snapshotData){
        if (snapshotData.hasData){
          final CameraController controller = snapshotData.data;

          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller));
        }
        else
          return Container(child: CircularProgressIndicator(), color: Colors.white);
      },
    );
  }
}*/