import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Entry/JsonToWidgetParser.dart';
import '../Utils/widgetType_utils.dart';
import '../Widgets/Gap/dynamic_gap.dart';

class DynamicGapParser extends JsonToWidgetParser<DynamicGap> {
  const DynamicGapParser();

  @override
  DynamicGap getModel(Map<String, dynamic> json) => DynamicGap.fromJson(json);

  @override
  String get type => WidgetType.gap.name;

  @override
  Widget parse(BuildContext context, DynamicGap model, [Map<String, dynamic>? functions]) {
    return model.max ? MaxGap(model.value) : Gap(model.value);
  }
}
