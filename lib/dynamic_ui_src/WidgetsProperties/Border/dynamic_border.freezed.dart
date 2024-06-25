// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_border.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicBorder _$DynamicBorderFromJson(Map<String, dynamic> json) {
  return _DynamicBorder.fromJson(json);
}

/// @nodoc
mixin _$DynamicBorder {
  String? get color => throw _privateConstructorUsedError;
  BorderStyle get borderStyle => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get strokeAlign => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicBorderCopyWith<DynamicBorder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicBorderCopyWith<$Res> {
  factory $DynamicBorderCopyWith(
          DynamicBorder value, $Res Function(DynamicBorder) then) =
      _$DynamicBorderCopyWithImpl<$Res, DynamicBorder>;
  @useResult
  $Res call(
      {String? color,
      BorderStyle borderStyle,
      double width,
      double strokeAlign});
}

/// @nodoc
class _$DynamicBorderCopyWithImpl<$Res, $Val extends DynamicBorder>
    implements $DynamicBorderCopyWith<$Res> {
  _$DynamicBorderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderStyle = null,
    Object? width = null,
    Object? strokeAlign = null,
  }) {
    return _then(_value.copyWith(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderStyle: null == borderStyle
          ? _value.borderStyle
          : borderStyle // ignore: cast_nullable_to_non_nullable
              as BorderStyle,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      strokeAlign: null == strokeAlign
          ? _value.strokeAlign
          : strokeAlign // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicBorderImplCopyWith<$Res>
    implements $DynamicBorderCopyWith<$Res> {
  factory _$$DynamicBorderImplCopyWith(
          _$DynamicBorderImpl value, $Res Function(_$DynamicBorderImpl) then) =
      __$$DynamicBorderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? color,
      BorderStyle borderStyle,
      double width,
      double strokeAlign});
}

/// @nodoc
class __$$DynamicBorderImplCopyWithImpl<$Res>
    extends _$DynamicBorderCopyWithImpl<$Res, _$DynamicBorderImpl>
    implements _$$DynamicBorderImplCopyWith<$Res> {
  __$$DynamicBorderImplCopyWithImpl(
      _$DynamicBorderImpl _value, $Res Function(_$DynamicBorderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderStyle = null,
    Object? width = null,
    Object? strokeAlign = null,
  }) {
    return _then(_$DynamicBorderImpl(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderStyle: null == borderStyle
          ? _value.borderStyle
          : borderStyle // ignore: cast_nullable_to_non_nullable
              as BorderStyle,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      strokeAlign: null == strokeAlign
          ? _value.strokeAlign
          : strokeAlign // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicBorderImpl implements _DynamicBorder {
  const _$DynamicBorderImpl(
      {this.color,
      this.borderStyle = BorderStyle.solid,
      this.width = 1.0,
      this.strokeAlign = BorderSide.strokeAlignInside});

  factory _$DynamicBorderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicBorderImplFromJson(json);

  @override
  final String? color;
  @override
  @JsonKey()
  final BorderStyle borderStyle;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double strokeAlign;

  @override
  String toString() {
    return 'DynamicBorder(color: $color, borderStyle: $borderStyle, width: $width, strokeAlign: $strokeAlign)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicBorderImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.borderStyle, borderStyle) ||
                other.borderStyle == borderStyle) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.strokeAlign, strokeAlign) ||
                other.strokeAlign == strokeAlign));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, color, borderStyle, width, strokeAlign);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicBorderImplCopyWith<_$DynamicBorderImpl> get copyWith =>
      __$$DynamicBorderImplCopyWithImpl<_$DynamicBorderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicBorderImplToJson(
      this,
    );
  }
}

abstract class _DynamicBorder implements DynamicBorder {
  const factory _DynamicBorder(
      {final String? color,
      final BorderStyle borderStyle,
      final double width,
      final double strokeAlign}) = _$DynamicBorderImpl;

  factory _DynamicBorder.fromJson(Map<String, dynamic> json) =
      _$DynamicBorderImpl.fromJson;

  @override
  String? get color;
  @override
  BorderStyle get borderStyle;
  @override
  double get width;
  @override
  double get strokeAlign;
  @override
  @JsonKey(ignore: true)
  _$$DynamicBorderImplCopyWith<_$DynamicBorderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
