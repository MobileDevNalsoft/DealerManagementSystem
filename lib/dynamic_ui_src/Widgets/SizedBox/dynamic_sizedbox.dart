import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_sizedbox.freezed.dart';
part 'dynamic_sizedbox.g.dart';

@freezed
class DynamicSizedBox with _$DynamicSizedBox {
  const factory DynamicSizedBox(
      {@Default(false) bool key,
      @Default(0.0) double height,
      @Default(0.0) double width,
      Map<String, dynamic>? child}) = _DynamicSizedBox;

  factory DynamicSizedBox.fromJson(Map<String, dynamic> json) =>
      _$DynamicSizedBoxFromJson(json);
}
