// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_borderRadius.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicBorderImpl _$$DynamicBorderImplFromJson(Map<String, dynamic> json) =>
    _$DynamicBorderImpl(
      topLeft: (json['topLeft'] as num?)?.toDouble() ?? 0.0,
      topRight: (json['topRight'] as num?)?.toDouble() ?? 0.0,
      bottomLeft: (json['bottomLeft'] as num?)?.toDouble() ?? 0.0,
      bottomRight: (json['bottomRight'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$DynamicBorderImplToJson(_$DynamicBorderImpl instance) =>
    <String, dynamic>{
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
      'bottomLeft': instance.bottomLeft,
      'bottomRight': instance.bottomRight,
    };
