import 'package:dms/dynamic_ui_src/WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';
import 'package:flutter/material.dart';

import '../Entry/JsonToWidgetParser.dart';
import '../Entry/json_to_widget.dart';
import '../Utils/widgetType_utils.dart';
import '../Widgets/ListView/dynamic_listView.dart';

class DynamicListViewParser extends JsonToWidgetParser<DynamicListView> {
  const DynamicListViewParser({this.controller});

  final ScrollController? controller;

  @override
  String get type => WidgetType.listView.name;

  @override
  DynamicListView getModel(Map<String, dynamic> json) => DynamicListView.fromJson(json);

  @override
  Widget parse(BuildContext context, DynamicListView model, [Map<String, dynamic>? functions]) {
    return ListView.separated(
      scrollDirection: model.scrollDirection,
      reverse: model.reverse,
      controller: controller,
      primary: model.primary,
      physics: model.physics?.parse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding?.parse,
      addAutomaticKeepAlives: model.addAutomaticKeepAlives,
      addRepaintBoundaries: model.addRepaintBoundaries,
      addSemanticIndexes: model.addSemanticIndexes,
      cacheExtent: model.cacheExtent,
      dragStartBehavior: model.dragStartBehavior,
      keyboardDismissBehavior: model.keyboardDismissBehavior,
      restorationId: model.restorationId,
      clipBehavior: model.clipBehavior,
      itemCount: model.children.length,
      itemBuilder: (context, index) => JsonToWidget.fromJson(model.children[index], context, functions),
      separatorBuilder: (context, _) => JsonToWidget.fromJson(model.separator, context, functions) ?? const SizedBox(),
    );
  }
}
