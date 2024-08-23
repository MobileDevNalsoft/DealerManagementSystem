import 'package:dms/dynamic_ui_src/Entry/JsonToWidgetParser.dart';
import 'package:dms/dynamic_ui_src/Utils/widgetType_utils.dart';
import 'package:flutter/material.dart';

import '../Entry/json_to_widget.dart';
import '../Widgets/Column/dynamic_column.dart';

class DynamicColumnParser extends JsonToWidgetParser<DynamicColumn> {
  const DynamicColumnParser();

  @override
  DynamicColumn getModel(Map<String, dynamic> json) => DynamicColumn.fromJson(json);

  @override
  String get type => WidgetType.column.name;

  @override
  Widget parse(BuildContext context, DynamicColumn model, [Map<String, dynamic>? functions]) {
    return Column(
      mainAxisAlignment: model.mainAxisAlignment,
      crossAxisAlignment: model.crossAxisAlignment,
      mainAxisSize: model.mainAxisSize,
      textDirection: model.textDirection,
      verticalDirection: model.verticalDirection,
      children: model.children
          .map(
            (value) => JsonToWidget.fromJson(value, context, functions) ?? const SizedBox(),
          )
          .toList(),
    );
  }
}
