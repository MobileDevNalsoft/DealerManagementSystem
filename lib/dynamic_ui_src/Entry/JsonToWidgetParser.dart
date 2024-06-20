import 'package:flutter/material.dart';

abstract class JsonToWidgetParser<T> {
  const JsonToWidgetParser();

  String get type;

  T getModel(Map<String, dynamic> json);

  Widget parse(BuildContext context, T model,
      [Map<String, dynamic>? functions]);
}
