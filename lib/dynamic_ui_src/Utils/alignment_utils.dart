import 'package:flutter/material.dart';

enum DynamicAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight;

  Alignment get value {
    switch (this) {
      case DynamicAlignment.topLeft:
        return Alignment.topLeft;
      case DynamicAlignment.topCenter:
        return Alignment.topCenter;
      case DynamicAlignment.topRight:
        return Alignment.topRight;
      case DynamicAlignment.centerLeft:
        return Alignment.centerLeft;
      case DynamicAlignment.center:
        return Alignment.center;
      case DynamicAlignment.centerRight:
        return Alignment.centerRight;
      case DynamicAlignment.bottomLeft:
        return Alignment.bottomLeft;
      case DynamicAlignment.bottomCenter:
        return Alignment.bottomCenter;
      case DynamicAlignment.bottomRight:
        return Alignment.bottomRight;
      default:
        return Alignment.topLeft;
    }
  }
}

enum DynamicAlignmentDirectional {
  topStart,
  topCenter,
  topEnd,
  centerStart,
  center,
  centerEnd,
  bottomStart,
  bottomCenter,
  bottomEnd;

  AlignmentDirectional get value {
    switch (this) {
      case DynamicAlignmentDirectional.topStart:
        return AlignmentDirectional.topStart;
      case DynamicAlignmentDirectional.topCenter:
        return AlignmentDirectional.topCenter;
      case DynamicAlignmentDirectional.topEnd:
        return AlignmentDirectional.topEnd;
      case DynamicAlignmentDirectional.centerStart:
        return AlignmentDirectional.centerStart;
      case DynamicAlignmentDirectional.center:
        return AlignmentDirectional.center;
      case DynamicAlignmentDirectional.centerEnd:
        return AlignmentDirectional.centerEnd;
      case DynamicAlignmentDirectional.bottomStart:
        return AlignmentDirectional.bottomStart;
      case DynamicAlignmentDirectional.bottomCenter:
        return AlignmentDirectional.bottomCenter;
      case DynamicAlignmentDirectional.bottomEnd:
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.topStart;
    }
  }
}
