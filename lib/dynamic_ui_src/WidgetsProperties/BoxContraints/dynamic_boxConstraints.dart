import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_boxConstraints.freezed.dart';
part 'dynamic_boxConstraints.g.dart';

@freezed
class DynamicBoxConstraints with _$DynamicBoxConstraints {
  const factory DynamicBoxConstraints({
    required double minWidth,
    required double maxWidth,
    required double minHeight,
    required double maxHeight,
  }) = _DynamicBoxConstraints;

  factory DynamicBoxConstraints.fromJson(Map<String, dynamic> json) =>
      _$DynamicBoxConstraintsFromJson(json);
}

extension DynamicBoxConstraintsParser on DynamicBoxConstraints {
  BoxConstraints get parse {
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}
