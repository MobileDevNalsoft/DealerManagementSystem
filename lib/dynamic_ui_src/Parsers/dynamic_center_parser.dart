import 'package:dms/dynamic_ui_src/Entry/JsonToWidgetParser.dart';
import 'package:dms/dynamic_ui_src/Utils/widgetType_utils.dart';
import 'package:flutter/material.dart';
import '../Entry/json_to_widget.dart';
import '../Widgets/widgets_barrel.dart';

class DynamicCenterParser extends JsonToWidgetParser<DynamicCenter> {
  const DynamicCenterParser();

  @override
  DynamicCenter getModel(Map<String, dynamic> json) =>
      DynamicCenter.fromJson(json);

  @override
  String get type => WidgetType.center.name;

  @override
  Widget parse(BuildContext context, DynamicCenter model,
      [Map<String, dynamic>? functions]) {
    return Center(
      widthFactor: model.widthFactor,
      heightFactor: model.heightFactor,
      child: JsonToWidget.fromJson(model.child, context, functions),
    );
  }
}
