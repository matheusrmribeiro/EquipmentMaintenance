import '../classes/user.dart';
import 'package:flutter/material.dart';
import '../bloc/blocRegisterUser.dart';
import '../classes/registerSteps.dart';
import '../views/registerBase.dart';
import '../views/registerUserSteps.dart';

class RegisterUser extends StatelessWidget {
  RegisterUser({Key key, this.data}) : super(key: key){
    if (data!=null)
      bloc.inUser.add(data);
  }
  final bloc = BlocRegisterUser();
  final User data;  
  
  List<RegisterSteps> steps(){
    return [
      StepOne(bloc),
      StepTwo(bloc),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BaseRegister(title: "Novo usuário", bloc: this.bloc, steps: steps()),
    );
  }
}