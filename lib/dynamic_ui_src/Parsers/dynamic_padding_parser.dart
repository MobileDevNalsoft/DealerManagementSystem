import 'package:dms/dynamic_ui_src/WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';
import 'package:flutter/material.dart';

import '../Entry/JsonToWidgetParser.dart';
import '../Entry/json_to_widget.dart';
import '../Utils/widgetType_utils.dart';
import '../Widgets/Padding/dynamic_padding.dart';

class DynamicPaddingParser extends JsonToWidgetParser<DynamicPadding> {
  const DynamicPaddingParser();

  @override
  DynamicPadding getModel(Map<String, dynamic> json) =>
      DynamicPadding.fromJson(json);

  @override
  String get type => WidgetType.padding.name;

  @override
  Widget parse(BuildContext context, DynamicPadding model,
      [Map<String, dynamic>? functions]) {
    return Padding(
      padding: model.padding.parse,
      child: JsonToWidget.fromJson(model.child, context, functions),
    );
  }
}
