import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:balti_app/themes/colors.dart';
import 'package:balti_app/themes/fonts.dart';
import 'dart:math' as math;

class Logo extends StatelessWidget {
  final color;
  Logo({this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: -math.pi / 5,
            child: Icon(
              Icons.pets_outlined,
              size: 24,
              color: AppColor.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Petswala', style: AppFont.logo(this.color)),
          )
        ],
      ),
    );
  }
}
