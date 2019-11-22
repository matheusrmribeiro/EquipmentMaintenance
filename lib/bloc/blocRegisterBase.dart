import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../classes/defaultResponse.dart';

class BlocRegisterBase extends BlocBase {
  String url;
  final dataObject=null;
  TabController tabController;
  DefaultResponse registerState = DefaultResponse("OK", "Inserido com sucesso!");

  BlocRegisterBase(){
    _tabControllIndex.stream.listen((data){
      tabController.animateTo(data);
    });
  }

  @override
  void dispose() {
    _tabControllIndex.close();
    _nextButtonVisibility.close();
    _error.close();
    super.dispose();
  }  

  void moveToStep(int tabIndex) => inTabControllIndex.add(tabIndex);

  final BehaviorSubject<int> _tabControllIndex= BehaviorSubject<int>.seeded(0);
  Stream<int> get outTabControllIndex => _tabControllIndex.stream;
  Sink<int> get inTabControllIndex => _tabControllIndex.sink;
 
  final BehaviorSubject<bool> _nextButtonVisibility= BehaviorSubject<bool>.seeded(true);
  Stream<bool> get outNextButtonVisibility => _nextButtonVisibility.stream;
  Sink<bool> get inNextButtonVisibility => _nextButtonVisibility.sink;
  bool nextButtonVisibilityValue() => _nextButtonVisibility.value;

  final BehaviorSubject<String> _error = BehaviorSubject<String>();
  Stream<String> get outError => _error.stream;
  Sink<String> get inError => _error.sink;

  void beforeSave(){}

  Future<DefaultResponse> save() async {
    if (registerState.code=="ERROR")
      inError.add(registerState.value);

    return registerState;
  }
}