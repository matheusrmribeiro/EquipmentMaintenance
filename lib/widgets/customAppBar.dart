import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyCustomAppBar({Key key, @required this.title, @required this.height, this.actions}) : super(key: key);
  final String title;
  final double height;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(null, height),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          color: Colors.red,
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_back,
                size: 35,
                color: Colors.white
              ),
              Text(title,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}