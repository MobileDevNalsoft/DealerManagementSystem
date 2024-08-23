import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/Offset/dynamic_offset.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_boxShadow.freezed.dart';
part 'dynamic_boxShadow.g.dart';

@freezed
class DynamicBoxShadow with _$DynamicBoxShadow {
  const factory DynamicBoxShadow({
    String? color,
    @Default(0.0) double? blurRadius,
    @Default(DynamicOffset(dx: 0, dy: 0)) DynamicOffset offset,
    @Default(0.0) double? spreadRadius,
    @Default(BlurStyle.normal) BlurStyle? blurStyle,
  }) = _DynamicBoxShadow;

  factory DynamicBoxShadow.fromJson(Map<String, dynamic> json) => _$DynamicBoxShadowFromJson(json);
}

extension DynamicBoxShadowParser on DynamicBoxShadow? {
  BoxShadow parse(BuildContext context) {
    return BoxShadow(
      color: this?.color.toColor(context) ?? const Color(0xFF000000),
      blurRadius: this?.blurRadius ?? 0.0,
      offset: this?.offset.parse ?? Offset.zero,
      spreadRadius: this?.spreadRadius ?? 0.0,
      blurStyle: this?.blurStyle ?? BlurStyle.normal,
    );
  }
}
