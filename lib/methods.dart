import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Navigation {
  Future<bool> navigaToLogin(context, menu) async {
    var navigation = await Navigator.push(context, MaterialPageRoute(builder: (context) => menu,));
    return navigation;
  }

  void navigaTo(context, menu, {VoidCallback method}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => menu,)).then((result)
      {
        if(method != null)
          method();
      }
    );
  }
}

class HTTP {
  Future<List> getData(String url) async {
  var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

  return json.decode(response.body);
  }
}