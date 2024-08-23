import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../Utils/scrollPhysics_utils.dart';
import '../../WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';

part 'dynamic_listView.freezed.dart';
part 'dynamic_listView.g.dart';

@freezed
class DynamicListView with _$DynamicListView {
  const factory DynamicListView({
    @Default(Axis.vertical) Axis scrollDirection,
    @Default(false) bool reverse,
    bool? primary,
    DynamicScrollPhysics? physics,
    @Default(false) bool shrinkWrap,
    DynamicEdgeInsets? padding,
    @Default(true) bool addAutomaticKeepAlives,
    @Default(true) bool addRepaintBoundaries,
    @Default(true) bool addSemanticIndexes,
    double? cacheExtent,
    @Default([]) List<Map<String, dynamic>> children,
    Map<String, dynamic>? separator,
    int? semanticChildCount,
    @Default(DragStartBehavior.start) DragStartBehavior dragStartBehavior,
    @Default(ScrollViewKeyboardDismissBehavior.manual) ScrollViewKeyboardDismissBehavior keyboardDismissBehavior,
    String? restorationId,
    @Default(Clip.hardEdge) Clip clipBehavior,
  }) = _DynamicListView;

  factory DynamicListView.fromJson(Map<String, dynamic> json) => _$DynamicListViewFromJson(json);
}
