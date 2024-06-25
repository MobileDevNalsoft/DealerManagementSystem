// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_checkBox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicCheckBoxImpl _$$DynamicCheckBoxImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicCheckBoxImpl(
      value: json['value'] as bool?,
      activeColor: json['activeColor'] as String?,
      checkColor: json['checkColor'] as String?,
      onChanged: json['onChanged'] as String?,
      fillColor: json['fillColor'] == null
          ? null
          : DynamicMaterialColor.fromJson(
              json['fillColor'] as Map<String, dynamic>),
      tristate: json['tristate'] as bool? ?? false,
      focusColor: json['focusColor'] as String?,
      hoverColor: json['hoverColor'] as String?,
      side: json['side'] == null
          ? null
          : DynamicBorderSide.fromJson(json['side'] as Map<String, dynamic>),
      overlayColor: json['overlayColor'] == null
          ? null
          : DynamicMaterialColor.fromJson(
              json['overlayColor'] as Map<String, dynamic>),
      splashRadius: (json['splashRadius'] as num?)?.toDouble(),
      autofocus: json['autofocus'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
    );

Map<String, dynamic> _$$DynamicCheckBoxImplToJson(
        _$DynamicCheckBoxImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'activeColor': instance.activeColor,
      'checkColor': instance.checkColor,
      'onChanged': instance.onChanged,
      'fillColor': instance.fillColor,
      'tristate': instance.tristate,
      'focusColor': instance.focusColor,
      'hoverColor': instance.hoverColor,
      'side': instance.side,
      'overlayColor': instance.overlayColor,
      'splashRadius': instance.splashRadius,
      'autofocus': instance.autofocus,
      'isError': instance.isError,
    };
