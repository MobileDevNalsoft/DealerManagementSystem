import 'package:dms/dynamic_ui_src/WidgetsProperties/TextStyle/dynamic_textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Entry/JsonToWidgetParser.dart';
import '../Utils/widgetType_utils.dart';
import '../Widgets/Text/dynamic_text.dart';

class DynamicTextParser extends JsonToWidgetParser<DynamicText> {
  const DynamicTextParser();

  @override
  DynamicText getModel(Map<String, dynamic> json) => DynamicText.fromJson(json);

  @override
  String get type => WidgetType.text.name;

  @override
  Widget parse(BuildContext context, DynamicText model,
      [Map<String, dynamic>? functions]) {
    return Text.rich(
      TextSpan(
        text: model.data,
        children: model.children
            .map(
              (child) => TextSpan(
                text: child.data,
                style: child.style?.parse(context),
                recognizer: TapGestureRecognizer()..onTap = () => {},
              ),
            )
            .toList(),
      ),
      style: model.style?.parse(context),
      textAlign: model.textAlign,
      textDirection: model.textDirection,
      softWrap: model.softWrap,
      overflow: model.overflow,
      textScaler: model.textScaleFactor != null
          ? TextScaler.linear(model.textScaleFactor!)
          : TextScaler.noScaling,
      maxLines: model.maxLines,
      semanticsLabel: model.semanticsLabel,
      textWidthBasis: model.textWidthBasis,
      selectionColor: model.selectionColor != null
          ? Color(int.parse(model.selectionColor!.substring(1, 7), radix: 16) +
              0xFF000000)
          : Colors.black,
    );
  }
}
