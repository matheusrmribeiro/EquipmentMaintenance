import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/bloc/blocAuth.dart';
import 'package:qrcode/bloc/blocEquipment.dart';
import 'package:qrcode/bloc/blocLogin.dart';
import 'package:qrcode/bloc/blocQRCodeGenerator.dart';
import 'package:qrcode/bloc/blocThemes.dart';
import 'package:qrcode/views/rootPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Firestore firestore = Firestore(); 
  await firestore.settings(persistenceEnabled: true, timestampsInSnapshotsEnabled: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [ 
        Bloc((i) => BlocThemes()), 
        Bloc((i) => BlocAuth()), 
        Bloc((i) => BlocLogin()), 
        Bloc((i) => BlocEquipment()), 
        Bloc((i) => BlocQRCodeGenerator()),
      ],
      child: RootPage()
    );
  }
}