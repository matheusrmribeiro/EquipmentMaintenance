import 'package:flutter/material.dart';

List<String> states = ["São Paulo"];
List<String> cities = ["Bariri", "Jaú", "Bauru", "Dois Córregos", "Boracéia", "Perdeneiras", "Barra Bonita"];

BuildContext mainContext;

class PeriodoDia{
  String descricao() {
    DateTime dateTime = DateTime.now();
    int hora = dateTime.hour;

    if((hora >= 06)&&(hora < 12))
      return "Bom dia";
    else
    if((hora >= 12)&&(hora < 18))
      return "Boa tarde";
    else
    if(hora >= 18)
      return "Boa noite";
    else
    if((hora >= 00)&&(hora < 06))
      return "Vai dormir";
    else
      return "";
  }
}