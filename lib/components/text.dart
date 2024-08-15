import 'package:flutter/material.dart';

Widget text(text, {Color? color, double? size, FontWeight? weight}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: size ?? 14,
      fontWeight: weight ?? FontWeight.normal,
    ),
  );
}
