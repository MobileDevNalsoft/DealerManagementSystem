import 'package:dms/dynamic_ui_src/Utils/scrollPhysics_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';

part 'dynamic_gridView.freezed.dart';
part 'dynamic_gridView.g.dart';

@freezed
class DynamicGridView with _$DynamicGridView {
  const factory DynamicGridView({
    @Default(Axis.vertical) Axis scrollDirection,
    @Default(false) bool reverse,
    @Default(false) bool primary,
    DynamicScrollPhysics? physics,
    @Default(false) bool shrinkWrap,
    DynamicEdgeInsets? padding,
    int? crossAxisCount,
    @Default(0.0) double mainAxisSpacing,
    @Default(0.0) double crossAxisSpacing,
    @Default(1.0) double childAspectRatio,
    double? mainAxisExtent,
    @Default(true) bool addAutomaticKeepAlives,
    @Default(true) bool addRepaintBoundaries,
    @Default(true) bool addSemanticIndexes,
    double? cacheExtent,
    @Default([]) List<Map<String, dynamic>> children,
    int? semanticChildCount,
    @Default(DragStartBehavior.start) DragStartBehavior dragStartBehavior,
    @Default(ScrollViewKeyboardDismissBehavior.manual) ScrollViewKeyboardDismissBehavior keyboardDismissBehavior,
    String? restorationId,
    @Default(Clip.hardEdge) Clip clipBehavior,
  }) = _DynamicGridView;

  factory DynamicGridView.fromJson(Map<String, dynamic> json) => _$DynamicGridViewFromJson(json);
}
