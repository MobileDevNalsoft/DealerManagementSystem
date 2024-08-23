import 'package:dms/dynamic_ui_src/Entry/JsonToWidgetParser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_center_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_checkBox_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_column_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_container_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_gap_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_gridView_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_listView_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_padding_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_row_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_sizedbox_parser.dart';
import 'package:dms/dynamic_ui_src/Parsers/dynamic_text_parser.dart';
import 'package:dms/dynamic_ui_src/Registry/dynamic_widget_registry.dart';
import 'package:dms/logger/logger.dart';
import 'package:flutter/widgets.dart';

class JsonToWidget {
  static final _parsers = <JsonToWidgetParser>[
    const DynamicCenterParser(),
    const DynamicColumnParser(),
    const DynamicRowParser(),
    const DynamicTextParser(),
    const DynamicPaddingParser(),
    const DynamicGridViewParser(),
    const DynamicSizedBoxParser(),
    const DynamicContainerParser(),
    const DynamicGapParser(),
    const DynamicCheckBoxParser(),
    const DynamicListViewParser()
  ];

  static Future<void> initialize() async {
    DynamicWidgetRegistry.instance.registerAll(_parsers);
  }

  static Widget? fromJson(Map<String, dynamic>? json, context, [Map<String, dynamic>? functions]) {
    try {
      if (json != null) {
        String widgetType = json['type'];
        JsonToWidgetParser? widgetParser = DynamicWidgetRegistry.instance.getParser(widgetType);
        if (widgetParser != null) {
          final model = widgetParser.getModel(json);
          return widgetParser.parse(context, model, functions);
        } else {
          Log.d('Widget $widgetType not supported');
        }
      }
    } catch (e) {
      Log.e(e);
    }
    return null;
  }
}

extension JsonToWidgetExtension on Widget? {
  PreferredSizeWidget? get toPreferredSizeWidget {
    if (this != null) {
      return this as PreferredSizeWidget;
    }
    return null;
  }
}
