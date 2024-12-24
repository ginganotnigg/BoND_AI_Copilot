import 'package:flutter/material.dart';

// Colors
const Color primaryColor = Color(0xFFBB68AA);
const Color secondaryColor = Color(0xFF73ACAA);
const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[secondaryColor, primaryColor],
    tileMode: TileMode.mirror);

// Style
ButtonStyle outlined = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: primaryColor,
  side: const BorderSide(color: primaryColor),
  textStyle: const TextStyle(fontSize: 16, fontFamily: 'FiraSans'),
);

ButtonStyle filled = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.white,
  textStyle: const TextStyle(
      fontSize: 16, fontFamily: 'FiraSans', fontWeight: FontWeight.w700),
);