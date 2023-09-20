import 'dart:ui';

import 'package:flutter/material.dart';

Widget mainHeading(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontVariations: [FontVariation('wght', 800)],
      fontSize: 35,
    ),
  );
}
