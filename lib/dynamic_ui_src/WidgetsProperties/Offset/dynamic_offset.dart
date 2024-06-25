import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_offset.freezed.dart';
part 'dynamic_offset.g.dart';

@freezed
class DynamicOffset with _$DynamicOffset {
  const factory DynamicOffset({
    required double dx,
    required double dy,
  }) = _DynamicOffset;

  factory DynamicOffset.fromJson(Map<String, dynamic> json) =>
      _$DynamicOffsetFromJson(json);
}

extension DynamicOffsetParser on DynamicOffset {
  Offset get parse {
    return Offset(dx, dy);
  }
}
