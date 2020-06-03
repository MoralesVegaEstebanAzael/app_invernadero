import 'dart:math';

import 'package:app_invernadero/src/widgets/custom_scroll_physics.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final List<int> pages = List.generate(4, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left:5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: CustomScrollPhysics(itemDimension: 300),
            itemCount: pages.length,
            itemBuilder: (context, index) => Container(
              height: double.infinity,
              width: 290,
              color: randomColor,
              margin: const EdgeInsets.only(right: 10),
            ),
          ),
        ),
      ),
    );
  }

  Color get randomColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}