import 'package:flutter/material.dart';

enum DynamicScrollPhysics {
  never,
  bouncing,
  clamping,
  fixed,
  page;

  ScrollPhysics get parse {
    switch (this) {
      case DynamicScrollPhysics.bouncing:
        return const BouncingScrollPhysics();

      case DynamicScrollPhysics.clamping:
        return const ClampingScrollPhysics();

      case DynamicScrollPhysics.fixed:
        return const FixedExtentScrollPhysics();

      case DynamicScrollPhysics.page:
        return const PageScrollPhysics();

      default:
        return const NeverScrollableScrollPhysics();
    }
  }
}
