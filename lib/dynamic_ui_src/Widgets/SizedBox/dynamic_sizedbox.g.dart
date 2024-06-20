// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_sizedbox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicSizedBoxImpl _$$DynamicSizedBoxImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicSizedBoxImpl(
      key: json['key'] as bool? ?? false,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DynamicSizedBoxImplToJson(
        _$DynamicSizedBoxImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'height': instance.height,
      'width': instance.width,
      'child': instance.child,
    };
