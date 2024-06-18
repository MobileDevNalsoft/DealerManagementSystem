// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_textstyle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicTextStyleImpl _$$DynamicTextStyleImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicTextStyleImpl(
      inherit: json['inherit'] as bool? ?? true,
      color: json['color'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      styleFromTheme: json['styleFromTheme'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight:
          $enumDecodeNullable(_$DynamicFontWeightEnumMap, json['fontWeight']),
      fontStyle: $enumDecodeNullable(_$FontStyleEnumMap, json['fontStyle']),
      fontFamily: json['fontFamily'] as String?,
      fontFamilyFallback: (json['fontFamilyFallback'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
      wordSpacing: (json['wordSpacing'] as num?)?.toDouble(),
      textBaseline:
          $enumDecodeNullable(_$TextBaselineEnumMap, json['textBaseline']),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DynamicTextStyleImplToJson(
        _$DynamicTextStyleImpl instance) =>
    <String, dynamic>{
      'inherit': instance.inherit,
      'color': instance.color,
      'backgroundColor': instance.backgroundColor,
      'styleFromTheme': instance.styleFromTheme,
      'fontSize': instance.fontSize,
      'fontWeight': _$DynamicFontWeightEnumMap[instance.fontWeight],
      'fontStyle': _$FontStyleEnumMap[instance.fontStyle],
      'fontFamily': instance.fontFamily,
      'fontFamilyFallback': instance.fontFamilyFallback,
      'letterSpacing': instance.letterSpacing,
      'wordSpacing': instance.wordSpacing,
      'textBaseline': _$TextBaselineEnumMap[instance.textBaseline],
      'height': instance.height,
    };

const _$DynamicFontWeightEnumMap = {
  DynamicFontWeight.w100: 'w100',
  DynamicFontWeight.w200: 'w200',
  DynamicFontWeight.w300: 'w300',
  DynamicFontWeight.w400: 'w400',
  DynamicFontWeight.w500: 'w500',
  DynamicFontWeight.w600: 'w600',
  DynamicFontWeight.w700: 'w700',
  DynamicFontWeight.w800: 'w800',
  DynamicFontWeight.w900: 'w900',
};

const _$FontStyleEnumMap = {
  FontStyle.normal: 'normal',
  FontStyle.italic: 'italic',
};

const _$TextBaselineEnumMap = {
  TextBaseline.alphabetic: 'alphabetic',
  TextBaseline.ideographic: 'ideographic',
};
