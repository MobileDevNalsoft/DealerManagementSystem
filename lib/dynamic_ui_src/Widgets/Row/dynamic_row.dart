import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_row.freezed.dart';
part 'dynamic_row.g.dart';

@freezed
class DynamicRow with _$DynamicRow {
  const factory DynamicRow({
    @Default(MainAxisAlignment.start) MainAxisAlignment mainAxisAlignment,
    @Default(CrossAxisAlignment.center) CrossAxisAlignment crossAxisAlignment,
    @Default(MainAxisSize.max) MainAxisSize mainAxisSize,
    TextDirection? textDirection,
    @Default(VerticalDirection.down) VerticalDirection verticalDirection,
    @Default([]) List<Map<String, dynamic>> children,
  }) = _DynamicRow;

  factory DynamicRow.fromJson(Map<String, dynamic> json) =>
      _$DynamicRowFromJson(json);
}
