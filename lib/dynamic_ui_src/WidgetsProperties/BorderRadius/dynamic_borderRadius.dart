import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_borderRadius.freezed.dart';
part 'dynamic_borderRadius.g.dart';

@freezed
class DynamicBorderRadius with _$DynamicBorderRadius {
  const factory DynamicBorderRadius({
    @Default(0.0) double topLeft,
    @Default(0.0) double topRight,
    @Default(0.0) double bottomLeft,
    @Default(0.0) double bottomRight,
  }) = _DynamicBorder;

  factory DynamicBorderRadius.fromJson(dynamic json) => _fromJson(json);

  static DynamicBorderRadius _fromJson(dynamic json) {
    Map<String, dynamic> resultantJson;

    if (json is num) {
      resultantJson = {
        "topLeft": json,
        "topRight": json,
        "bottomLeft": json,
        "bottomRight": json
      };
    } else if (json is List<dynamic> && json.length == 4) {
      bool allElementsNum = json.every((element) => element is num);
      if (!allElementsNum) {
        throw ArgumentError('Invalid input format for DynamicEdgeInsets');
      }
      resultantJson = {
        "topLeft": json[0],
        "topRight": json[1],
        "bottomLeft": json[2],
        "bottomRight": json[3]
      };
    } else if (json is Map<String, dynamic>) {
      resultantJson = json;
    } else {
      throw ArgumentError('Invalid input format for DynamicEdgeInsets');
    }

    return _$DynamicBorderRadiusFromJson(resultantJson);
  }
}

extension DynamicBorderRadiusParser on DynamicBorderRadius? {
  BorderRadius get parse {
    return BorderRadius.only(
      topLeft: Radius.circular(this?.topLeft ?? 0.0),
      topRight: Radius.circular(this?.topRight ?? 0.0),
      bottomLeft: Radius.circular(this?.bottomLeft ?? 0.0),
      bottomRight: Radius.circular(this?.bottomRight ?? 0.0),
    );
  }
}
