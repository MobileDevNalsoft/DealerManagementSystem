import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_column.freezed.dart';
part 'dynamic_column.g.dart';

@freezed
class DynamicColumn with _$DynamicColumn {
  const factory DynamicColumn({
    @Default(MainAxisAlignment.start) MainAxisAlignment mainAxisAlignment,
    @Default(CrossAxisAlignment.center) CrossAxisAlignment crossAxisAlignment,
    @Default(MainAxisSize.max) MainAxisSize mainAxisSize,
    TextDirection? textDirection,
    @Default(VerticalDirection.down) VerticalDirection verticalDirection,
    @Default([]) List<Map<String, dynamic>> children,
  }) = _DynamicColumn;

  factory DynamicColumn.fromJson(Map<String, dynamic> json) =>
      _$DynamicColumnFromJson(json);
}
