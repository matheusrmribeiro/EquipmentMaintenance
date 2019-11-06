import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcode/classes/user.dart';

class FirebaseConnection{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user.user.email;
    return user?.user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user?.user.uid;
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