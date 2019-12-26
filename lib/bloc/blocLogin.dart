import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc/blocAuth.dart';

enum SubmitStatus{
  ssNormal,
  ssLoading,
  ssFinalized
}

class BlocLogin extends BlocBase {
  final blocAuth = BlocProvider.getBloc<BlocAuth>();

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _statuController.close();
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

  final BehaviorSubject<SubmitStatus> _statuController = BehaviorSubject<SubmitStatus>.seeded(SubmitStatus.ssNormal);
  Stream<SubmitStatus> get outSubmitStatus => _statuController.stream;
  Sink<SubmitStatus> get inSubmitStatus => _statuController.sink;  

  void submitLogIn(BlocAuth blocAuth) async {
    try {
      inSubmitStatus.add(SubmitStatus.ssLoading);
      await Future.delayed(Duration(seconds: 2));
      final request = await blocAuth.firebase.signInWithEmailAndPassword(_emailController.value, _passwordController.value);
      if(request.code != "ERROR"){
        blocAuth.currentUser = await blocAuth.firebase.getCurrentUserObject();
        blocAuth.signedIn();
        inSubmitStatus.add(SubmitStatus.ssFinalized);
        await Future.delayed(Duration(seconds: 5));
      }
      
      inSubmitStatus.add(SubmitStatus.ssNormal);
    } catch (e) {
      print('Error: $e');
    }
  }  
}