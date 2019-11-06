import 'dart:ui';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import '../bloc/blocAuth.dart';
import '../bloc/blocLogin.dart';
import '../widgets/customTextFormField.dart';

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
        CustomTextForm(
          textKey: Key('email'),
          keyboardType: TextInputType.emailAddress,
          label: 'Email',
          icon: Icons.email,
          validator: BlocLogin.validateEmail,
          onSaved: (value) => bloc.inEmail.add(value),
        ),
        CustomTextForm(
          textKey: Key('password'),
          label: 'Senha',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: BlocLogin.validatePassword,
          onSaved: (value) => bloc.inPassword.add(value),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){},
              child: Text("Esqueceu a senha?",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600]
                ),
              ),
            ),
          ),
        )
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
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Ainda não tem uma conta? "),
                  GestureDetector(
                    onTap: (){},
                    child: Text("Cria conta",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                  ),
                  /*FlatButton(
                    child: Text('Criar conta', style: TextStyle(fontSize: 20.0)),              
                    onPressed: moveToRegister,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                  ),*/
                ],
              ),
            )
          ],
        );
      },
    );
    
  }
}