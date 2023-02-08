import 'package:flutter/material.dart';

Color stringToHslColor (String str, {double s = 0.5, double l = 0.5}) {
  var hash = 0;

  for (var rune in str.runes) {
    hash = rune + ((hash << 5) - hash);
  }

  var h = (hash % 360).toDouble();

  return HSLColor.fromAHSL(1, h, s, l).toColor();
}
