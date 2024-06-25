import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_border.freezed.dart';
part 'dynamic_border.g.dart';

@freezed
class DynamicBorder with _$DynamicBorder {
  const factory DynamicBorder({
    String? color,
    @Default(BorderStyle.solid) BorderStyle borderStyle,
    @Default(1.0) double width,
    @Default(BorderSide.strokeAlignInside) double strokeAlign,
  }) = _DynamicBorder;

  factory DynamicBorder.fromJson(Map<String, dynamic> json) =>
      _$DynamicBorderFromJson(json);
}

extension DynamicBorderParser on DynamicBorder {
  Border parse(BuildContext context) {
    return Border.all(
      color: color.toColor(context) ?? const Color(0xFF000000),
      width: width,
      style: borderStyle,
      strokeAlign: strokeAlign,
    );
  }
}
