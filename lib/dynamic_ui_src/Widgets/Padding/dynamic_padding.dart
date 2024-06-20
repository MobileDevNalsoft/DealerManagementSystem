import 'package:dms/dynamic_ui_src/WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_padding.freezed.dart';
part 'dynamic_padding.g.dart';

@freezed
class DynamicPadding with _$DynamicPadding {
  const factory DynamicPadding({
    required DynamicEdgeInsets padding,
    Map<String, dynamic>? child,
  }) = _DynamicPadding;

  factory DynamicPadding.fromJson(Map<String, dynamic> json) =>
      _$DynamicPaddingFromJson(json);
}
