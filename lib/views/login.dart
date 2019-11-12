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
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            height: 300,
            width: 300,
            child: DecorationCircle(),
          ),
          Positioned(
            left: 0,
            top: 0,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 110,
            child: Container(
              margin: EdgeInsets.only(left: 40, bottom: 55),
              child: Text("LogScan", 
                style: TextStyle(
                  color: Theme.of(context).primaryColor, 
                  fontSize: 50.0,
                  fontFamily: "RobotoMono",
                  fontWeight: FontWeight.w500
                )
              )
            ),
          ),          
          Fields(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SubmitButtons()
          )
        ],
      ),
    );
  }
}

class Fields extends StatelessWidget {
  final bloc = BlocProvider.getBloc<BlocLogin>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Container(
            margin: EdgeInsets.only(top: 80),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
          ),
        ),
      ),
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
              height: 45,
              margin: EdgeInsets.only(bottom: 15),
              child: RaisedButton(
                key: Key('signIn'),
                color: Theme.of(context).primaryColor,
                elevation: 10,
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
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class DecorationCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.withOpacity(0.5), Colors.red.withOpacity(0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(200),
              )
            ),
          ),
        ),        
        Positioned(
          right: 0,
          top: 10,
          child: Container(
            height: 200,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(200),
              )
            ),
          ),
        ),        
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(200),
              )
            ),
          ),
        ),
      ],
    );
  }
}
