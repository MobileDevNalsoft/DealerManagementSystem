// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_border_side.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicBorderSideImpl _$$DynamicBorderSideImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicBorderSideImpl(
      color: json['color'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      strokeAlign: (json['strokeAlign'] as num?)?.toDouble() ?? 0.0,
      borderStyle:
          $enumDecodeNullable(_$BorderStyleEnumMap, json['borderStyle']) ??
              BorderStyle.solid,
    );

Map<String, dynamic> _$$DynamicBorderSideImplToJson(
        _$DynamicBorderSideImpl instance) =>
    <String, dynamic>{
      'color': instance.color,
      'width': instance.width,
      'strokeAlign': instance.strokeAlign,
      'borderStyle': _$BorderStyleEnumMap[instance.borderStyle]!,
    };

const _$BorderStyleEnumMap = {
  BorderStyle.none: 'none',
  BorderStyle.solid: 'solid',
};
