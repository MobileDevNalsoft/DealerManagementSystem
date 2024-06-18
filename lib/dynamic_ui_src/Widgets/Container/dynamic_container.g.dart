// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicContainerImpl _$$DynamicContainerImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicContainerImpl(
      alignment:
          $enumDecodeNullable(_$DynamicAlignmentEnumMap, json['alignment']),
      padding: json['padding'] == null
          ? null
          : DynamicEdgeInsets.fromJson(json['padding']),
      decoration: json['decoration'] == null
          ? null
          : DynamicBoxDecoration.fromJson(
              json['decoration'] as Map<String, dynamic>),
      foregroundDecoration: json['foregroundDecoration'] == null
          ? null
          : DynamicBoxDecoration.fromJson(
              json['foregroundDecoration'] as Map<String, dynamic>),
      color: json['color'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      constraints: json['constraints'] == null
          ? null
          : DynamicBoxConstraints.fromJson(
              json['constraints'] as Map<String, dynamic>),
      margin: json['margin'] == null
          ? null
          : DynamicEdgeInsets.fromJson(json['margin']),
      child: json['child'] as Map<String, dynamic>?,
      clipBehavior:
          $enumDecodeNullable(_$ClipEnumMap, json['clipBehavior']) ?? Clip.none,
    );

Map<String, dynamic> _$$DynamicContainerImplToJson(
        _$DynamicContainerImpl instance) =>
    <String, dynamic>{
      'alignment': _$DynamicAlignmentEnumMap[instance.alignment],
      'padding': instance.padding,
      'decoration': instance.decoration,
      'foregroundDecoration': instance.foregroundDecoration,
      'color': instance.color,
      'opacity': instance.opacity,
      'width': instance.width,
      'height': instance.height,
      'constraints': instance.constraints,
      'margin': instance.margin,
      'child': instance.child,
      'clipBehavior': _$ClipEnumMap[instance.clipBehavior]!,
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

const _$ClipEnumMap = {
  Clip.none: 'none',
  Clip.hardEdge: 'hardEdge',
  Clip.antiAlias: 'antiAlias',
  Clip.antiAliasWithSaveLayer: 'antiAliasWithSaveLayer',
};
