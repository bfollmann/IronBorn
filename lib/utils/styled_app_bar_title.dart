import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class StyledAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContextcontext) {
    return Center(
      child: Text(
        'IronBorn',
        style: TextStyle(
          fontFamily: 'RustCore',
          fontSize: 50,
          fontWeight: FontWeight.w900,
          foreground: Paint()..shader = ui.Gradient.linear(
            const Offset(0, 0),
            const Offset(200, 0),
            [Colors.grey[400]!, Colors.white, Colors.grey[400]!],
            [0.0, 0.5, 1.0],
            TileMode.mirror,
          ),
        ),
      ),
    );
  }
}