import 'package:flutter/material.dart';

Widget text(text,
    {Color? color, double? size, FontWeight? weight, TextOverflow? overflow}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: size ?? 14,
      fontWeight: weight ?? FontWeight.normal,
      overflow: overflow,
    ),
  );
}
