import 'dart:ui';

import 'package:dms/dynamic_ui_src/Utils/alignment_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../WidgetsProperties/BoxContraints/dynamic_boxConstraints.dart';
import '../../WidgetsProperties/BoxDecoration/dynamic_boxDecoration.dart';
import '../../WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';

part 'dynamic_container.freezed.dart';
part 'dynamic_container.g.dart';

@freezed
class DynamicContainer with _$DynamicContainer {
  const factory DynamicContainer({
    DynamicAlignment? alignment,
    DynamicEdgeInsets? padding,
    DynamicBoxDecoration? decoration,
    DynamicBoxDecoration? foregroundDecoration,
    String? color,
    double? opacity,
    double? width,
    double? height,
    DynamicBoxConstraints? constraints,
    DynamicEdgeInsets? margin,
    Map<String, dynamic>? child,
    @Default(Clip.none) Clip clipBehavior,
  }) = _DynamicContainer;

  factory DynamicContainer.fromJson(Map<String, dynamic> json) => _$DynamicContainerFromJson(json);
}
