import 'package:dms/dynamic_ui_src/Entry/JsonToWidgetParser.dart';
import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:dms/dynamic_ui_src/Widgets/widgets_barrel.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/BoxContraints/dynamic_boxConstraints.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/BoxDecoration/dynamic_boxDecoration.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/EdgeInsets/dynamic_edgeInsets.dart';
import 'package:flutter/cupertino.dart';
import '../Entry/json_to_widget.dart';
import '../Utils/widgetType_utils.dart';

class DynamicContainerParser extends JsonToWidgetParser<DynamicContainer> {
  const DynamicContainerParser();

  @override
  String get type => WidgetType.container.name;

  @override
  DynamicContainer getModel(Map<String, dynamic> json) =>
      DynamicContainer.fromJson(json);

  @override
  Widget parse(BuildContext context, DynamicContainer model,
      [Map<String, dynamic>? functions]) {
    return Container(
      alignment: model.alignment?.value,
      padding: model.padding?.parse,
      color: model.color.toColor(context, opacity: model.opacity ?? 1),
      decoration: model.decoration?.parse(context),
      foregroundDecoration: model.foregroundDecoration?.parse(context),
      width: model.width,
      height: model.height,
      constraints: model.constraints?.parse,
      margin: model.margin?.parse,
      clipBehavior: model.clipBehavior,
      child: JsonToWidget.fromJson(model.child, context, functions),
    );
  }
}
