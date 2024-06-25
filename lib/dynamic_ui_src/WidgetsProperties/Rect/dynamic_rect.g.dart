// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_rect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicRectImpl _$$DynamicRectImplFromJson(Map<String, dynamic> json) =>
    _$DynamicRectImpl(
      rectType: $enumDecode(_$DynamicRectTypeEnumMap, json['rectType']),
      center: json['center'] == null
          ? null
          : DynamicOffset.fromJson(json['center'] as Map<String, dynamic>),
      a: json['a'] == null
          ? null
          : DynamicOffset.fromJson(json['a'] as Map<String, dynamic>),
      b: json['b'] == null
          ? null
          : DynamicOffset.fromJson(json['b'] as Map<String, dynamic>),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      left: (json['left'] as num?)?.toDouble(),
      top: (json['top'] as num?)?.toDouble(),
      right: (json['right'] as num?)?.toDouble(),
      bottom: (json['bottom'] as num?)?.toDouble(),
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DynamicRectImplToJson(_$DynamicRectImpl instance) =>
    <String, dynamic>{
      'rectType': _$DynamicRectTypeEnumMap[instance.rectType]!,
      'center': instance.center,
      'a': instance.a,
      'b': instance.b,
      'width': instance.width,
      'height': instance.height,
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
      'radius': instance.radius,
    };

const _$DynamicRectTypeEnumMap = {
  DynamicRectType.fromCenter: 'fromCenter',
  DynamicRectType.fromCircle: 'fromCircle',
  DynamicRectType.fromLTRB: 'fromLTRB',
  DynamicRectType.fromLTWH: 'fromLTWH',
  DynamicRectType.fromPoints: 'fromPoints',
};
