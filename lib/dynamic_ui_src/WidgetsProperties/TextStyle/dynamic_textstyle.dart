import 'package:dms/dynamic_ui_src/Utils/color_utils.dart';
import 'package:dms/dynamic_ui_src/Utils/font_weight_utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_textstyle.freezed.dart';
part 'dynamic_textstyle.g.dart';

@freezed
class DynamicTextStyle with _$DynamicTextStyle {
  const factory DynamicTextStyle({
    @Default(true) bool inherit,
    String? color,
    String? backgroundColor,
    String? styleFromTheme,
    double? fontSize,
    DynamicFontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
  }) = _DynamicTextStyle;

  factory DynamicTextStyle.fromJson(dynamic json) => _fromJson(json);

  static DynamicTextStyle _fromJson(dynamic json) {
    if (json is String) {
      return _$DynamicTextStyleFromJson({"styleFromTheme": json});
    } else if (json is Map<String, dynamic>) {
      return _$DynamicTextStyleFromJson(json);
    }

    return _$DynamicTextStyleFromJson({});
  }
}

extension DynamicTextStyleParser on DynamicTextStyle {
  TextStyle? parse(BuildContext context) {
    if (styleFromTheme != null) {
      switch (styleFromTheme) {
        case 'displayLarge':
          return Theme.of(context).textTheme.displayLarge;
        case 'displayMedium':
          return Theme.of(context).textTheme.displayMedium;
        case 'displaySmall':
          return Theme.of(context).textTheme.displaySmall;
        case 'headlineLarge':
          return Theme.of(context).textTheme.headlineLarge;
        case 'headlineMedium':
          return Theme.of(context).textTheme.headlineMedium;
        case 'headlineSmall':
          return Theme.of(context).textTheme.headlineSmall;
        case 'titleLarge':
          return Theme.of(context).textTheme.titleLarge;
        case 'titleMedium':
          return Theme.of(context).textTheme.titleMedium;
        case 'titleSmall':
          return Theme.of(context).textTheme.titleSmall;
        case 'bodyLarge':
          return Theme.of(context).textTheme.bodyLarge;
        case 'bodyMedium':
          return Theme.of(context).textTheme.bodyMedium;
        case 'bodySmall':
          return Theme.of(context).textTheme.bodySmall;
        case 'labelLarge':
          return Theme.of(context).textTheme.labelLarge;
        case 'labelMedium':
          return Theme.of(context).textTheme.labelMedium;
        case 'labelSmall':
          return Theme.of(context).textTheme.labelSmall;
      }
    }

    return TextStyle(
      inherit: inherit,
      color: color != null
          ? Color(int.parse(color!.substring(1, 7), radix: 16) + 0xFF000000)
          : Colors.black,
      backgroundColor: backgroundColor.toColor(context),
      fontSize: fontSize,
      fontWeight: fontWeight?.value,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
    );
  }
}
