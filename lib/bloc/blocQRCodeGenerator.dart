import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:rxdart/rxdart.dart';

class BlocQRCodeGenerator extends BlocBase {
  @override
  void dispose() {
    equipmentController.close();
    _description.close();
    _floor.close();
    _room.close();
    _maintenancePeriod.close();
    _nextMaintenance.close();
    super.dispose();
  }

  final Equipment dataObject = Equipment();

  final BehaviorSubject<Equipment> equipmentController= BehaviorSubject<Equipment>();
  Stream<Equipment> get outEquipmentController => equipmentController.stream;
  Sink<Equipment> get inEquipmentController => equipmentController.sink;

  final BehaviorSubject<String> _description = BehaviorSubject<String>.seeded("");
  Stream<String> get outDescription => _description.stream;
  Sink<String> get inDescription => _description.sink;

  final BehaviorSubject<String> _floor = BehaviorSubject<String>.seeded("1");
  Stream<String> get outFloor => _floor.stream;
  Sink<String> get inFloor => _floor.sink;  

  final BehaviorSubject<String> _room = BehaviorSubject<String>.seeded("A1");
  Stream<String> get outRoom => _room.stream;
  Sink<String> get inRoom => _room.sink;  

  final BehaviorSubject<int> _maintenancePeriod = BehaviorSubject<int>();
  Stream<int> get outMaintenancePeriod => _maintenancePeriod.stream;
  Sink<int> get inMaintenancePeriod => _maintenancePeriod.sink;  

  final BehaviorSubject<DateTime> _nextMaintenance = BehaviorSubject<DateTime>();
  Stream<DateTime> get outNextMaintenance => _nextMaintenance.stream;
  Sink<DateTime> get inNextMaintenance => _nextMaintenance.sink;  
}