// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicCenterImpl _$$DynamicCenterImplFromJson(Map<String, dynamic> json) =>
    _$DynamicCenterImpl(
      widthFactor: (json['widthFactor'] as num?)?.toDouble(),
      heightFactor: (json['heightFactor'] as num?)?.toDouble(),
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DynamicCenterImplToJson(_$DynamicCenterImpl instance) =>
    <String, dynamic>{
      'widthFactor': instance.widthFactor,
      'heightFactor': instance.heightFactor,
      'child': instance.child,
    };
