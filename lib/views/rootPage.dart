import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/bloc/blocAuth.dart';
import 'package:qrcode/views/home.dart';
import 'package:qrcode/views/login.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final bloc = BlocProvider.getBloc<BlocAuth>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.outAuthStatus,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          switch (snapshot.data) {
            case AuthStatus.notSignedIn:
              return LoginPage();
            case AuthStatus.signedIn:
              return Home();
          default : return WaitingScreen();
          }
        } 
        else
          return WaitingScreen();
      },
    );
  }
}

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}