import 'package:dms/dynamic_ui_src/WidgetsProperties/Offset/dynamic_offset.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_rect.freezed.dart';
part 'dynamic_rect.g.dart';

enum DynamicRectType { fromCenter, fromCircle, fromLTRB, fromLTWH, fromPoints }

@freezed
class DynamicRect with _$DynamicRect {
  const factory DynamicRect({
    required DynamicRectType rectType,
    DynamicOffset? center,
    DynamicOffset? a,
    DynamicOffset? b,
    double? width,
    double? height,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? radius,
  }) = _DynamicRect;

  factory DynamicRect.fromJson(Map<String, dynamic> json) =>
      _$DynamicRectFromJson(json);
}

extension DynamicRectParser on DynamicRect {
  Rect? get parse {
    Rect fromCenter() => Rect.fromCenter(
          center: center?.parse ?? Offset.zero,
          width: width ?? 0.0,
          height: height ?? 0.0,
        );
    Rect fromCircle() => Rect.fromCircle(
          center: center?.parse ?? Offset.zero,
          radius: radius ?? 0.0,
        );
    Rect fromLTRB() => Rect.fromLTRB(
          left ?? 0.0,
          top ?? 0.0,
          right ?? 0.0,
          bottom ?? 0.0,
        );
    Rect fromLTWH() => Rect.fromLTWH(
          left ?? 0.0,
          top ?? 0.0,
          width ?? 0.0,
          height ?? 0.0,
        );
    Rect fromPoints() => Rect.fromPoints(
          a?.parse ?? Offset.zero,
          b?.parse ?? Offset.zero,
        );

    switch (rectType) {
      case DynamicRectType.fromCenter:
        return fromCenter();
      case DynamicRectType.fromCircle:
        return fromCircle();
      case DynamicRectType.fromLTRB:
        return fromLTRB();
      case DynamicRectType.fromLTWH:
        return fromLTWH();
      case DynamicRectType.fromPoints:
        return fromPoints();
      default:
        return null;
    }
  }
}
