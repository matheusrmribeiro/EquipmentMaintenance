import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import '../bloc/blocThemes.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final blocThemes = BlocProvider.getBloc<BlocThemes>();
  bool isSwitched = false;
  
  @override
  void initState() {
    super.initState();
    isSwitched = (blocThemes.selectedTheme() == ApplicationTheme.darkTheme);
  }
  
  void changeTheme(){
    setState(() {
      isSwitched = !isSwitched; 
    });

    if (isSwitched)
      blocThemes.selectTheme(ApplicationTheme.darkTheme);
    else
      blocThemes.selectTheme(ApplicationTheme.lightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: changeTheme,
                    child: Text("Modo escuro",
                      style: TextStyle(
                        fontSize: 25
                      ),
                    ),
                  ),
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    changeTheme();
                  },
                  activeTrackColor: Theme.of(context).accentColor, 
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}