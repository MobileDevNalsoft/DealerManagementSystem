import 'dart:math' as math;

import 'package:dms/dynamic_ui_src/Utils/alignment_utils.dart';
import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/AlignmentGeometry/dynamic_alignmentGeometry.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_gradient.freezed.dart';
part 'dynamic_gradient.g.dart';

enum DynamicGradientType { linear, radial, sweep }

@freezed
class DynamicGradient with _$DynamicGradient {
  const factory DynamicGradient({
    required List<String> colors,
    List<double>? stops,
    @Default(DynamicAlignment.centerLeft) DynamicAlignment begin,
    @Default(DynamicAlignment.centerRight) DynamicAlignment end,
    @Default(DynamicAlignment.center) DynamicAlignment center,
    @Default(DynamicGradientType.linear) DynamicGradientType gradientType,
    DynamicAlignmentGeometry? focal,
    @Default(TileMode.clamp) TileMode tileMode,
    @Default(0.0) double focalRadius,
    @Default(0.5) double radius,
    @Default(0.0) double startAngle,
    @Default(math.pi * 2) double endAngle,
  }) = _DynamicGradient;

  factory DynamicGradient.fromJson(Map<String, dynamic> json) => _$DynamicGradientFromJson(json);
}

extension DynamicGradientParser on DynamicGradient {
  Gradient? parse(BuildContext context) {
    Gradient linearGradient() => LinearGradient(
          colors: colors.map((e) => e.toColor(context)!).toList(),
          begin: begin.value,
          end: end.value,
          stops: stops,
          tileMode: tileMode,
        );

    Gradient radialGradient() => RadialGradient(
          colors: colors.map((e) => e.toColor(context)!).toList(),
          stops: stops,
          tileMode: tileMode,
          focal: focal?.parse,
          focalRadius: focalRadius,
          radius: radius,
          center: center.value,
        );

    Gradient sweepGradient() => SweepGradient(
          colors: colors.map((e) => e.toColor(context)!).toList(),
          stops: stops,
          center: center.value,
          startAngle: startAngle,
          endAngle: endAngle,
          tileMode: tileMode,
        );

    switch (gradientType) {
      case DynamicGradientType.linear:
        return linearGradient();
      case DynamicGradientType.radial:
        return radialGradient();
      case DynamicGradientType.sweep:
        return sweepGradient();
      default:
        return null;
    }
  }
}
