// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_decorationImage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicDecorationImageImpl _$$DynamicDecorationImageImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicDecorationImageImpl(
      src: json['src'] as String,
      fit: $enumDecodeNullable(_$BoxFitEnumMap, json['fit']),
      imageType: $enumDecodeNullable(
              _$DynamicDecorationImageTypeEnumMap, json['imageType']) ??
          DynamicDecorationImageType.network,
      alignment:
          $enumDecodeNullable(_$DynamicAlignmentEnumMap, json['alignment']) ??
              DynamicAlignment.center,
      centerSlice: json['centerSlice'] == null
          ? null
          : DynamicRect.fromJson(json['centerSlice'] as Map<String, dynamic>),
      repeat: $enumDecodeNullable(_$ImageRepeatEnumMap, json['repeat']) ??
          ImageRepeat.noRepeat,
      matchTextDirection: json['matchTextDirection'] as bool? ?? false,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      filterQuality:
          $enumDecodeNullable(_$FilterQualityEnumMap, json['filterQuality']) ??
              FilterQuality.low,
      invertColors: json['invertColors'] as bool? ?? false,
      isAntiAlias: json['isAntiAlias'] as bool? ?? false,
    );

Map<String, dynamic> _$$DynamicDecorationImageImplToJson(
        _$DynamicDecorationImageImpl instance) =>
    <String, dynamic>{
      'src': instance.src,
      'fit': _$BoxFitEnumMap[instance.fit],
      'imageType': _$DynamicDecorationImageTypeEnumMap[instance.imageType]!,
      'alignment': _$DynamicAlignmentEnumMap[instance.alignment]!,
      'centerSlice': instance.centerSlice,
      'repeat': _$ImageRepeatEnumMap[instance.repeat]!,
      'matchTextDirection': instance.matchTextDirection,
      'scale': instance.scale,
      'opacity': instance.opacity,
      'filterQuality': _$FilterQualityEnumMap[instance.filterQuality]!,
      'invertColors': instance.invertColors,
      'isAntiAlias': instance.isAntiAlias,
    };

const _$BoxFitEnumMap = {
  BoxFit.fill: 'fill',
  BoxFit.contain: 'contain',
  BoxFit.cover: 'cover',
  BoxFit.fitWidth: 'fitWidth',
  BoxFit.fitHeight: 'fitHeight',
  BoxFit.none: 'none',
  BoxFit.scaleDown: 'scaleDown',
};

const _$DynamicDecorationImageTypeEnumMap = {
  DynamicDecorationImageType.file: 'file',
  DynamicDecorationImageType.network: 'network',
  DynamicDecorationImageType.asset: 'asset',
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

const _$ImageRepeatEnumMap = {
  ImageRepeat.repeat: 'repeat',
  ImageRepeat.repeatX: 'repeatX',
  ImageRepeat.repeatY: 'repeatY',
  ImageRepeat.noRepeat: 'noRepeat',
};

const _$FilterQualityEnumMap = {
  FilterQuality.none: 'none',
  FilterQuality.low: 'low',
  FilterQuality.medium: 'medium',
  FilterQuality.high: 'high',
};
