import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_gap.freezed.dart';
part 'dynamic_gap.g.dart';

@freezed
class DynamicGap with _$DynamicGap {
  const factory DynamicGap(
      {@Default(false) bool key,
      @Default(false) bool max,
      @Default(0.0) double value}) = _DynamicGap;

  factory DynamicGap.fromJson(Map<String, dynamic> json) =>
      _$DynamicGapFromJson(json);
}
