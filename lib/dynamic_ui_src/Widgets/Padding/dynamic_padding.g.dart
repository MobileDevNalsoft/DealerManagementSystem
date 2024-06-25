// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_padding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicPaddingImpl _$$DynamicPaddingImplFromJson(Map<String, dynamic> json) =>
    _$DynamicPaddingImpl(
      padding: DynamicEdgeInsets.fromJson(json['padding']),
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DynamicPaddingImplToJson(
        _$DynamicPaddingImpl instance) =>
    <String, dynamic>{
      'padding': instance.padding,
      'child': instance.child,
    };
