import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_border_side.freezed.dart';
part 'dynamic_border_side.g.dart';

@freezed
class DynamicBorderSide with _$DynamicBorderSide {
  const factory DynamicBorderSide({
    String? color,
    @Default(0.0) double width,
    @Default(0.0) double strokeAlign,
    @Default(BorderStyle.solid) BorderStyle borderStyle,
  }) = _DynamicBorderSide;

  factory DynamicBorderSide.fromJson(Map<String, dynamic> json) => _$DynamicBorderSideFromJson(json);
}

extension DynamicBorderSideParser on DynamicBorderSide? {
  BorderSide parse(BuildContext context) {
    return BorderSide(
      color: this?.color.toColor(context) ?? const Color(0xFF000000),
      width: this?.width ?? 0.0,
      style: this?.borderStyle ?? BorderStyle.solid,
      strokeAlign: this?.strokeAlign ?? 0.0,
    );
  }
}
