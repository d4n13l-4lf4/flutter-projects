
import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double diam = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diam,
      height: diam,
      decoration: new BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle,
      ),
    );
  }
}
