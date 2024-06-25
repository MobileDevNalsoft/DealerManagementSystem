import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_materialColor.freezed.dart';
part 'dynamic_materialColor.g.dart';

@freezed
class DynamicMaterialColor with _$DynamicMaterialColor {
  const factory DynamicMaterialColor({
    required String primary,
    required String shade50,
    required String shade100,
    required String shade200,
    required String shade300,
    required String shade400,
    required String shade500,
    required String shade600,
    required String shade700,
    required String shade800,
    required String shade900,
  }) = _DynamicMaterialColor;

  factory DynamicMaterialColor.fromJson(Map<String, dynamic> json) =>
      _$DynamicMaterialColorFromJson(json);
}

extension DynamicThemeParser on DynamicMaterialColor {
  MaterialColor parse(BuildContext context) {
    Map<int, Color> color = {
      50: shade50.toColor(context)!,
      100: shade100.toColor(context)!,
      200: shade200.toColor(context)!,
      300: shade300.toColor(context)!,
      400: shade400.toColor(context)!,
      500: shade500.toColor(context)!,
      600: shade600.toColor(context)!,
      700: shade700.toColor(context)!,
      800: shade800.toColor(context)!,
      900: shade900.toColor(context)!,
    };

    return MaterialColor(
      (primary.toColor(context))!.value,
      color,
    );
  }
}
