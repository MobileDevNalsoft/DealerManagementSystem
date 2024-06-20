import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_alignmentGeometry.freezed.dart';
part 'dynamic_alignmentGeometry.g.dart';

@freezed
class DynamicAlignmentGeometry with _$DynamicAlignmentGeometry {
  const factory DynamicAlignmentGeometry({
    required double dx,
    required double dy,
  }) = _DynamicAlignmentGeometry;

  factory DynamicAlignmentGeometry.fromJson(Map<String, dynamic> json) =>
      _$DynamicAlignmentGeometryFromJson(json);
}

extension DynamicOffsetParser on DynamicAlignmentGeometry {
  Alignment get parse {
    return Alignment(dx, dy);
  }
}
