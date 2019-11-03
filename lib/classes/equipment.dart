import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Equipment{
  String id;
  String description;
  String floor;
  String room;
  int maintenancePeriod;
  DateTime nextMaintenance;

  Map<String, dynamic> toJson({bool removeId = false, bool useTimestamp = false}) {
    var data = {
      "id": "$id",
      "description": "$description",
      "floor": "$floor",
      "room": "$room",
      "maintenancePeriod": maintenancePeriod,
      "nextMaintenance": (useTimestamp) ? nextMaintenance : nextMaintenance.microsecondsSinceEpoch
    };

    if (removeId)
      data.remove("id");

    return data;
  }

  void snapToClass(DocumentSnapshot doc){
    Timestamp timestamp = doc.data["nextMaintenance"];

    id                = doc.documentID;
    description       = doc.data["description"];
    floor             = doc.data["floor"];
    room              = doc.data["room"];
    maintenancePeriod = doc.data["maintenancePeriod"];
    nextMaintenance   = timestamp.toDate();
  }

  void jsonToClass(Map<String, dynamic> json){
    id                = json["id"];
    description       = json["description"];
    floor             = json["floor"];
    room              = json["room"];
    maintenancePeriod = json["maintenancePeriod"];
    nextMaintenance   = DateTime.fromMicrosecondsSinceEpoch(json["nextMaintenance"]);
  }  
}

Color colorLevel(DateTime date){
  Duration dateDifference = date.toLocal().difference(DateTime.now());
  Color corGravidade = Colors.green;

  if(dateDifference.inDays >= 90)
    corGravidade = Colors.green;
  else
  if((dateDifference.inDays >= 30)&&(dateDifference.inDays <= 45))
    corGravidade = Colors.orangeAccent;
  else
    corGravidade = Colors.redAccent;

  return corGravidade;
}