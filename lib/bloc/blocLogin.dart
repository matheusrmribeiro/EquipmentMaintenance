import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:qrcode/bloc/blocAuth.dart';
import 'package:qrcode/classes/user.dart';
import 'package:rxdart/rxdart.dart';

enum ActionType {
  atLogin,
  atRegister,
}

class BlocLogin extends BlocBase {
  final blocAuth = BlocProvider.getBloc<BlocAuth>();

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _typeController.close();
    super.dispose();
  }

  static String validateEmail(String value) {
    return value.isEmpty ? 'Informe um email válido!' : null;
  }

  static String validatePassword(String value) {
    if(value.isEmpty)
      return 'Informe uma senha!';
    if(value.length < 6)
      return 'A senha deve possuir 6 ou mais caracteres!';
    return null;
  }  

  final BehaviorSubject<String> _emailController = BehaviorSubject<String>.seeded("");
  Stream<String> get outEmail => _emailController.stream;
  Sink<String> get inEmail => _emailController.sink;

  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>.seeded("");
  Stream<String> get outPassword => _passwordController.stream;
  Sink<String> get inPassword => _passwordController.sink;  

  final BehaviorSubject<ActionType> _typeController = BehaviorSubject<ActionType>.seeded(ActionType.atLogin);
  Stream<ActionType> get outType => _typeController.stream;
  Sink<ActionType> get inType => _typeController.sink;  

  void submitLogIn(BlocAuth blocAuth) async {
    try {
      if (_typeController.value == ActionType.atLogin) {
        String userId = "";
        userId = await blocAuth.firebase.signInWithEmailAndPassword(_emailController.value, _passwordController.value);
        if(userId != "") 
          blocAuth.currentUser = await blocAuth.firebase.getCurrentUserObject();
      } 
      else
        String userId = await blocAuth.firebase.createUserWithEmailAndPassword(_emailController.value, _passwordController.value);

      blocAuth.signedIn();
      
    } catch (e) {
      print('Error: $e');
    }
  }  
}