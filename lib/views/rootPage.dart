import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import '../bloc/blocAuth.dart';
import '../bloc/blocThemes.dart';
import '../views/home.dart';
import '../views/login.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final blocThemes = BlocProvider.getBloc<BlocThemes>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: blocThemes.outTheme,
      builder: (context, snapshot){
        if (!snapshot.hasData)
          return Container();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Maintenance Control',
          theme: blocThemes.currentTheme(),
          home: PageController()
        );
      },
    ); 
  }
}

class PageController extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocAuth>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.outAuthStatus,
      builder: (context, snapshot){
        if (!snapshot.hasData)
          return WaitingScreen();
        
        switch (snapshot.data) {
          case AuthStatus.notSignedIn:
            return LoginPage();
          case AuthStatus.signedIn:
            return Home();
        default : return WaitingScreen();
        }
      },
    );
  }
}

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}