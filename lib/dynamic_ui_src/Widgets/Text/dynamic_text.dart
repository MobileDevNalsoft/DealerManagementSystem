import 'package:dms/dynamic_ui_src/WidgetsProperties/TextStyle/dynamic_textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_text.freezed.dart';
part 'dynamic_text.g.dart';

@freezed
class DynamicText with _$DynamicText {
  const factory DynamicText({
    required String data,
    @Default([]) List<DynamicTextSpan> children,
    DynamicTextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    String? selectionColor,
  }) = _DynamicText;

  factory DynamicText.fromJson(Map<String, dynamic> json) => _$DynamicTextFromJson(json);
}

@freezed
class DynamicTextSpan with _$DynamicTextSpan {
  const factory DynamicTextSpan({
    String? data,
    DynamicTextStyle? style,
    Map<String, dynamic>? onTap,
  }) = _DynamicTextSpan;

  factory DynamicTextSpan.fromJson(Map<String, dynamic> json) => _$DynamicTextSpanFromJson(json);
}
