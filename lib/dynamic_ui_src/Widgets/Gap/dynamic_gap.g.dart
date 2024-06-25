// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_gap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicGapImpl _$$DynamicGapImplFromJson(Map<String, dynamic> json) =>
    _$DynamicGapImpl(
      key: json['key'] as bool? ?? false,
      max: json['max'] as bool? ?? false,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$DynamicGapImplToJson(_$DynamicGapImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'max': instance.max,
      'value': instance.value,
    };
