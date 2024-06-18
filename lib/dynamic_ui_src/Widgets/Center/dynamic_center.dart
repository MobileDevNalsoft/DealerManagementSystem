import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_center.freezed.dart';
part 'dynamic_center.g.dart';

@freezed
class DynamicCenter with _$DynamicCenter {
  const factory DynamicCenter({
    double? widthFactor,
    double? heightFactor,
    Map<String, dynamic>? child,
  }) = _DynamicCenter;

  factory DynamicCenter.fromJson(Map<String, dynamic> json) =>
      _$DynamicCenterFromJson(json);
}
