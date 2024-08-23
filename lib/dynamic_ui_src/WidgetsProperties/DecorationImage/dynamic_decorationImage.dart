import 'dart:io';

import 'package:dms/dynamic_ui_src/Utils/alignment_utils.dart';
import 'package:dms/dynamic_ui_src/WidgetsProperties/Rect/dynamic_rect.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dynamic_decorationImage.freezed.dart';
part 'dynamic_decorationImage.g.dart';

enum DynamicDecorationImageType { file, network, asset }

@freezed
class DynamicDecorationImage with _$DynamicDecorationImage {
  const factory DynamicDecorationImage({
    required String src,
    BoxFit? fit,
    @Default(DynamicDecorationImageType.network) DynamicDecorationImageType imageType,
    @Default(DynamicAlignment.center) DynamicAlignment alignment,
    DynamicRect? centerSlice,
    @Default(ImageRepeat.noRepeat) ImageRepeat repeat,
    @Default(false) bool matchTextDirection,
    @Default(1.0) double scale,
    @Default(1.0) double opacity,
    @Default(FilterQuality.low) FilterQuality filterQuality,
    @Default(false) bool invertColors,
    @Default(false) bool isAntiAlias,
  }) = _DynamicDecorationImage;

  factory DynamicDecorationImage.fromJson(Map<String, dynamic> json) => _$DynamicDecorationImageFromJson(json);
}

extension DynamicDecorationImageParser on DynamicDecorationImage? {
  DecorationImage? get parse {
    if (this?.src == null) return null;

    late ImageProvider image;
    switch (this?.imageType) {
      case DynamicDecorationImageType.network:
        image = NetworkImage(this?.src ?? '');
        break;
      case DynamicDecorationImageType.file:
        image = FileImage(File(this?.src ?? ''));
        break;
      case DynamicDecorationImageType.asset:
        image = AssetImage(this?.src ?? '');
        break;
      default:
        return null;
    }

    return DecorationImage(
      image: image,
      fit: this?.fit,
      alignment: this?.alignment.value ?? Alignment.center,
      centerSlice: this?.centerSlice?.parse,
      repeat: this?.repeat ?? ImageRepeat.noRepeat,
      matchTextDirection: this?.matchTextDirection ?? false,
      scale: this?.scale ?? 1.0,
      opacity: this?.opacity ?? 1.0,
      filterQuality: this?.filterQuality ?? FilterQuality.low,
      invertColors: this?.invertColors ?? false,
      isAntiAlias: this?.isAntiAlias ?? false,
    );
  }
}
