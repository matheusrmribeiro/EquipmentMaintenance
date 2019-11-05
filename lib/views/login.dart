import 'dart:ui';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrcode/bloc/blocAuth.dart';
import 'package:qrcode/bloc/blocLogin.dart';

final formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocLogin>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          child: Container(
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: Text("LogScan", 
                          style: TextStyle(
                            color: Theme.of(context).primaryColor, 
                            fontSize: 50.0,
                          )
                        ),
                      )
                    ),              
                    Expanded(
                      child: Fields(),
                    ),
                    SubmitButtons()
                  ]
                ),
              )
            )
          ) 
        )
      ],
    );
  }
}

class Fields extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocLogin>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 6,
          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 2, 2, 2),
            child: TextFormField(
              key: Key('email'),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 18
              ),
              validator: BlocLogin.validateEmail,
              onSaved: (value) => bloc.inEmail.add(value),
            )
          ),
        ),
        Card(
          elevation: 6,
          margin: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 2, 2, 2),
            child: TextFormField(
              key: Key('password'),
              decoration: InputDecoration(
                labelText: 'Senha',
                icon: Icon(Icons.lock_outline),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 18
              ),
              obscureText: true,
              validator: BlocLogin.validatePassword,
              onSaved: (value) => bloc.inPassword.add(value),
            ),
          )
        ),
      ]
    );
  }
}

class SubmitButtons extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocLogin>();
  final blocAuth = BlocProvider.getBloc<BlocAuth>();
  
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(ActionType type) async {
    if (validateAndSave())
      bloc.submitLogIn(blocAuth);
  }

  void moveToRegister() {
    formKey.currentState.reset();
  }

  void moveToLogin() {
    formKey.currentState.reset();
    bloc.inType.add(ActionType.atLogin);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.outType,
      builder: (context, snapshot){
        if (!snapshot.hasData)
          return Container();
        
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 200,
              child: RaisedButton(
                key: Key('signIn'),
                color: Theme.of(context).primaryColor,
                elevation: 10.00,
                child: Text('Entrar', 
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.white)
                  ),
                onPressed: (){
                  validateAndSubmit(snapshot.data);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
              ),
            ),
            FlatButton(
              child: Text('Criar uma conta', style: TextStyle(fontSize: 20.0)),              
              onPressed: moveToRegister,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
            ),
          ],
        );
      },
    );
    
  }
}