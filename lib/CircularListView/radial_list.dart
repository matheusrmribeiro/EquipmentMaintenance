import 'package:flutter/material.dart';
import 'dart:math';
import 'package:qrcode/CircularListView/radial_position.dart';

class RadialList extends StatefulWidget {

  final RadialListViewModel radialList;
  final double radius;

  RadialList({
    this.radialList,
    this.radius,
  });

  List<Widget> _radialListItems(){

    final double firstItemAngle = pi/4;
    final double lastItemAngle = pi/4;
    final double angleDiff = (firstItemAngle + lastItemAngle) / (radialList.items.length -1);

    double currentAngle = firstItemAngle;

    return radialList.items.map((RadialListItemViewModel viewModel){
      final listItem = _radialListItem(viewModel,currentAngle);
      currentAngle += angleDiff;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle){
    return Transform(
      transform: new Matrix4.translationValues(
          200.0,
          100.0,
          0.0
      ),
      child: RadialPosition(
        radius: radius,
        angle: angle,
        child: new RadialListItem(
          listItem: viewModel,
        ),
      ),
    );
  }

  @override
  RadialListState createState() {
    return new RadialListState();
  }
}

class RadialListState extends State<RadialList> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: widget._radialListItems(),
    );
  }
}

class RadialListItem extends StatefulWidget {

  final RadialListItemViewModel listItem;

  RadialListItem({
    this.listItem
  });

  @override
  RadialListItemState createState() {
    return new RadialListItemState();
  }

}

class RadialListItemState extends State<RadialListItem> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: new Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurpleAccent,
            border: new Border.all(
                color: Colors.red,
                width: 2.0
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: OutlineButton(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(60.0)),
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                widget.listItem.isSelected = true;
                //widget.listItem.number = widget.listItem.number + 1;
              });
            },
            child: new Text(
              widget.listItem.number.toString(),
              style: new TextStyle(
                  color: widget.listItem.isSelected ? Colors.red : Colors.yellow,
                  fontSize: 20.0
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialListViewModel{
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items = const [],
  });

}


class RadialListItemViewModel{
  int number;
  bool isSelected;

  RadialListItemViewModel({
    this.isSelected = false,
    this.number,
  });

}