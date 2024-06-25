// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_gradient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicGradientImpl _$$DynamicGradientImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicGradientImpl(
      colors:
          (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
      stops: (json['stops'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      begin: $enumDecodeNullable(_$DynamicAlignmentEnumMap, json['begin']) ??
          DynamicAlignment.centerLeft,
      end: $enumDecodeNullable(_$DynamicAlignmentEnumMap, json['end']) ??
          DynamicAlignment.centerRight,
      center: $enumDecodeNullable(_$DynamicAlignmentEnumMap, json['center']) ??
          DynamicAlignment.center,
      gradientType: $enumDecodeNullable(
              _$DynamicGradientTypeEnumMap, json['gradientType']) ??
          DynamicGradientType.linear,
      focal: json['focal'] == null
          ? null
          : DynamicAlignmentGeometry.fromJson(
              json['focal'] as Map<String, dynamic>),
      tileMode: $enumDecodeNullable(_$TileModeEnumMap, json['tileMode']) ??
          TileMode.clamp,
      focalRadius: (json['focalRadius'] as num?)?.toDouble() ?? 0.0,
      radius: (json['radius'] as num?)?.toDouble() ?? 0.5,
      startAngle: (json['startAngle'] as num?)?.toDouble() ?? 0.0,
      endAngle: (json['endAngle'] as num?)?.toDouble() ?? math.pi * 2,
    );

Map<String, dynamic> _$$DynamicGradientImplToJson(
        _$DynamicGradientImpl instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'stops': instance.stops,
      'begin': _$DynamicAlignmentEnumMap[instance.begin]!,
      'end': _$DynamicAlignmentEnumMap[instance.end]!,
      'center': _$DynamicAlignmentEnumMap[instance.center]!,
      'gradientType': _$DynamicGradientTypeEnumMap[instance.gradientType]!,
      'focal': instance.focal,
      'tileMode': _$TileModeEnumMap[instance.tileMode]!,
      'focalRadius': instance.focalRadius,
      'radius': instance.radius,
      'startAngle': instance.startAngle,
      'endAngle': instance.endAngle,
    };

const _$DynamicAlignmentEnumMap = {
  DynamicAlignment.topLeft: 'topLeft',
  DynamicAlignment.topCenter: 'topCenter',
  DynamicAlignment.topRight: 'topRight',
  DynamicAlignment.centerLeft: 'centerLeft',
  DynamicAlignment.center: 'center',
  DynamicAlignment.centerRight: 'centerRight',
  DynamicAlignment.bottomLeft: 'bottomLeft',
  DynamicAlignment.bottomCenter: 'bottomCenter',
  DynamicAlignment.bottomRight: 'bottomRight',
};

const _$DynamicGradientTypeEnumMap = {
  DynamicGradientType.linear: 'linear',
  DynamicGradientType.radial: 'radial',
  DynamicGradientType.sweep: 'sweep',
};

const _$TileModeEnumMap = {
  TileMode.clamp: 'clamp',
  TileMode.repeated: 'repeated',
  TileMode.mirror: 'mirror',
  TileMode.decal: 'decal',
};
