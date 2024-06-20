import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../WidgetsProperties/BorderSide/dynamic_border_side.dart';
import '../../WidgetsProperties/MaterialColor/dynamic_materialColor.dart';

part 'dynamic_checkBox.freezed.dart';
part 'dynamic_checkBox.g.dart';

@freezed
class DynamicCheckBox with _$DynamicCheckBox {
  const factory DynamicCheckBox({
    bool? value,
    String? activeColor,
    String? checkColor,
    String? onChanged,
    DynamicMaterialColor? fillColor,
    @Default(false) bool tristate,
    String? focusColor,
    String? hoverColor,
    DynamicBorderSide? side,
    DynamicMaterialColor? overlayColor,
    double? splashRadius,
    @Default(false) bool autofocus,
    @Default(false) bool isError,
  }) = _DynamicCheckBox;

  factory DynamicCheckBox.fromJson(Map<String, dynamic> json) =>
      _$DynamicCheckBoxFromJson(json);
}
