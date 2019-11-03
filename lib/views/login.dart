import 'dart:ui';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
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
            padding: EdgeInsets.all(16.0),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: Text("Cascan", 
                          style: TextStyle(
                            color: Colors.purple, 
                            fontSize: 50.0,
                          )
                        ),
                      )
                    ),              
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Fields(), 
                          SubmitButtons()
                        ],
                      )
                    ),
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
      children: <Widget>[
        Container(
          color: Colors.black.withOpacity(0.6),
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('email'),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email)
            ),
            validator: BlocLogin.validateEmail,
            onSaved: (value) => bloc.inEmail.add(value),
          )
        ),
        Container(padding: EdgeInsets.only(top: 10.0),),
        Container(
          color: Colors.black.withOpacity(0.6),
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(Icons.lock_outline)
            ),
            obscureText: true,
            validator: BlocLogin.validatePassword,
            onSaved: (value) => bloc.inPassword.add(value),
          )
        ),
      ]
    );
  }
}

class SubmitButtons extends StatelessWidget {
  /*SubmitButtons(this._formKey);
  final _formKey;*/
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
        if (snapshot.hasData) {
          if (snapshot.data == ActionType.atLogin) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 50.0),),
                RaisedButton(
                  key: Key('signIn'),
                  color: Theme.of(context).primaryColor,
                  elevation: 10.00,
                  child: Text('Entrar', style: TextStyle(fontSize: 20.0)),
                  onPressed: (){
                    validateAndSubmit(snapshot.data);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                ),
                FlatButton(
                  child: Text('Criar uma conta', style: TextStyle(fontSize: 20.0)),              
                  onPressed: moveToRegister,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                ),
              ],
            );
          } 
          else {
            return Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Criar uma conta', style: TextStyle(fontSize: 20.0)),
                    onPressed: (){
                      validateAndSubmit(snapshot.data);
                    },
                  ),
                  FlatButton(
                    child: Text('Já tenho uma conta', style: TextStyle(fontSize: 20.0)),
                    onPressed: moveToLogin,
                  ),
                ],
              );
          }
        }
        else
          return Container();
      },
    );
    
  }
}