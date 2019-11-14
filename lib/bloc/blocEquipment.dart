import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/classes/equipment.dart';
import 'package:qrcode/methods/qrCode.dart';
import 'package:rxdart/rxdart.dart';

class BlocEquipment extends BlocBase {
  final _qrCode = QRCodeMethods();
  String _error;

  BlocEquipment() {
    _equipmentController.stream.listen((value){
      inNextmaintenance.add(value.nextMaintenance);
    });
  }

  void scan(){
    _qrCode.scanCode().then((value){
      _error = value[0];
      if (_error == 'OK') {
        Equipment equipment = Equipment();
        var result = jsonDecode(value[1]);

        equipment.jsonToClass(result);
        inEquipmentController.add(equipment);
      }
      else {
        inEquipmentController.add(null);
        _equipmentController.addError(_error);
      }
    });
  }

  void newMaintenance() async {
    final inPeriod = DateTime.now().isBefore(_equipmentController.value.nextMaintenance);

    Map<String, dynamic> newMaintenance = {
      "description": "Usar um popup para preencher aqui",
      "equipment": _equipmentController.value.id,
      "date": DateTime.now(),
      "inPeriod": inPeriod
    };

    DocumentReference docResult = await Firestore.instance.collection("maintenanceLog").add(newMaintenance);
  }

  @override
  void dispose() {
    _equipmentController.close();
    _key.close();
    _nextmaintenance.close();
    super.dispose();
  }

  final BehaviorSubject<Equipment> _equipmentController= BehaviorSubject<Equipment>();
  Stream<Equipment> get outEquipmentController => _equipmentController.stream;
  Sink<Equipment> get inEquipmentController => _equipmentController.sink;

  final BehaviorSubject<GlobalKey> _key = BehaviorSubject<GlobalKey>.seeded(GlobalKey());
  Stream<GlobalKey> get outKey => _key.stream;
  Sink<GlobalKey> get inKey=> _key.sink;

  final BehaviorSubject<DateTime> _nextmaintenance = BehaviorSubject<DateTime>();
  Stream<DateTime> get outNextmaintenance => _nextmaintenance.stream;
  Sink<DateTime> get inNextmaintenance => _nextmaintenance.sink;  
}