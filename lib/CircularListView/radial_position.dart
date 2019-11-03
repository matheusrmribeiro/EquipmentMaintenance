import 'package:flutter/material.dart';
import 'dart:math';

class RadialPosition extends StatefulWidget {

  final double radius;
  final double angle;
  final Widget child;

  RadialPosition({
    this.angle,
    this.child,
    this.radius,
  });


  @override
  RadialPositionState createState() {
    return new RadialPositionState();
  }
}

class RadialPositionState extends State<RadialPosition> {
  @override
  Widget build(BuildContext context) {
    final x = cos(widget.angle) * widget.radius;
    final y = sin(widget.angle) * widget.radius;

    return Transform(
      transform: new Matrix4.translationValues(x, y, 0.0),
      child: widget.child,
    );
  }
}