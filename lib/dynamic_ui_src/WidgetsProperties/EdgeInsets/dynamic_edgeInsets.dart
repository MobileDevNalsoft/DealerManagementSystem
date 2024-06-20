import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_edgeInsets.freezed.dart';
part 'dynamic_edgeInsets.g.dart';

@freezed
class DynamicEdgeInsets with _$DynamicEdgeInsets {
  const factory DynamicEdgeInsets({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) = _DynamicEdgeInsets;

  factory DynamicEdgeInsets.fromJson(dynamic json) => _fromJson(json);

  static DynamicEdgeInsets _fromJson(dynamic json) {
    Map<String, dynamic> resultantJson;

    if (json is num) {
      resultantJson = {
        "left": json,
        "top": json,
        "right": json,
        "bottom": json
      };
    } else if (json is Map<String, dynamic> && json.length == 2) {
      resultantJson = {
        "left": json['horizontal'],
        "top": json['vertical'],
        "right": json['horizontal'],
        "bottom": json['vertical']
      };
    } else if (json is Map<String, dynamic>) {
      resultantJson = json;
    } else {
      throw ArgumentError('Invalid input format for DynamicEdgeInsets');
    }

    return _$DynamicEdgeInsetsFromJson(resultantJson);
  }
}

extension DynamicEdgeInsetsParser on DynamicEdgeInsets? {
  EdgeInsets get parse {
    return EdgeInsets.only(
      left: this?.left ?? 0,
      right: this?.right ?? 0,
      top: this?.top ?? 0,
      bottom: this?.bottom ?? 0,
    );
  }
}
