import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BlocRegisterBase extends BlocBase {
  String url;
  final dataObject=null;

  final BehaviorSubject<int> _tabControllIndex= BehaviorSubject<int>.seeded(0);
  Stream<int> get outTabControllIndex => _tabControllIndex.stream;
  Sink<int> get inTabControllIndex => _tabControllIndex.sink;
 
 final BehaviorSubject<bool> _nextButtonVisibility= BehaviorSubject<bool>.seeded(true);
  Stream<bool> get outNextButtonVisibility=> _nextButtonVisibility.stream;
  Sink<bool> get inNextButtonVisibility => _nextButtonVisibility.sink;
  bool nextButtonVisibilityValue() => _nextButtonVisibility.value;

  void beforeSave(){}

  Future<bool> save() async {}

  @override
  void dispose() {
    _tabControllIndex.close();
    _nextButtonVisibility.close();
    super.dispose();
  }
}