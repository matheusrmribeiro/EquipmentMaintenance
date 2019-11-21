import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/defaultResponse.dart';
import '../classes/user.dart';

class FirebaseConnection{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<DefaultResponse> createUserWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult request = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return DefaultResponse('OK', request.user.uid);
    } catch(error) {
      var errorMessage;
        switch (error.code) {
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Senha fraca!";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_INVALID_EMAIL":
          errorMessage = "O email informado não parece ser um email!";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "O email já está sendo usado por outro usuário.";
          return DefaultResponse('ERROR', errorMessage);
        default:
          errorMessage = "Um erro desconhecido ocorreu.";
          return DefaultResponse('ERROR', errorMessage);
      }
    }
  }
 
  Future<DefaultResponse> signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult request = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return DefaultResponse('OK', request.user.uid);
    } catch(error) {
      var errorMessage;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "O email informado não parece ser um email!";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Senha errada!";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "O usuário não existe.";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_USER_DISABLED":
          errorMessage = "Esse usuário foi desabilitado.";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Muitas requisições. Tente mais tarde.";
          return DefaultResponse('ERROR', errorMessage);
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Login com email e senha não está habilitado.";
          return DefaultResponse('ERROR', errorMessage);
        default:
          errorMessage = "Um erro desconhecido ocorreu.";
          return DefaultResponse('ERROR', errorMessage);
      }
    }    
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  Future<FirebaseUser> currentUserObject() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }  

  Future<User> getCurrentUserObject() async {
    User user = User();
    FirebaseUser objeto = await currentUserObject();

    if (objeto!=null){
      DocumentSnapshot document = await Firestore.instance.collection("users").document(objeto.uid).get();
      if (document.data != null)
        user.toClass(document.documentID, document.data);
    }
    
    return user;
  }  
}