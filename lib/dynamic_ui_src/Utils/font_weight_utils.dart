import 'package:flutter/material.dart';

enum DynamicFontWeight {
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900;

  FontWeight get value {
    switch (this) {
      case DynamicFontWeight.w100:
        return FontWeight.w100;

      case DynamicFontWeight.w200:
        return FontWeight.w200;

      case DynamicFontWeight.w300:
        return FontWeight.w300;

      case DynamicFontWeight.w400:
        return FontWeight.w400;

      case DynamicFontWeight.w500:
        return FontWeight.w500;

      case DynamicFontWeight.w600:
        return FontWeight.w600;

      case DynamicFontWeight.w700:
        return FontWeight.w700;

      case DynamicFontWeight.w800:
        return FontWeight.w800;

      case DynamicFontWeight.w900:
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }
}
