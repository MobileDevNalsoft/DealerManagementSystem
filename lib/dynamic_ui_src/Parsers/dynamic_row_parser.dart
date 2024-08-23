import 'package:flutter/material.dart';

import '../Entry/JsonToWidgetParser.dart';
import '../Entry/json_to_widget.dart';
import '../Utils/widgetType_utils.dart';
import '../Widgets/Row/dynamic_row.dart';

class DynamicRowParser extends JsonToWidgetParser<DynamicRow> {
  const DynamicRowParser();

  @override
  DynamicRow getModel(Map<String, dynamic> json) => DynamicRow.fromJson(json);

  @override
  String get type => WidgetType.row.name;

  @override
  Widget parse(BuildContext context, DynamicRow model, [Map<String, dynamic>? functions]) {
    return Row(
      mainAxisAlignment: model.mainAxisAlignment,
      crossAxisAlignment: model.crossAxisAlignment,
      mainAxisSize: model.mainAxisSize,
      textDirection: model.textDirection,
      verticalDirection: model.verticalDirection,
      children: model.children.map((value) => JsonToWidget.fromJson(value, context, functions) ?? const SizedBox()).toList(),
    );
  }
}
