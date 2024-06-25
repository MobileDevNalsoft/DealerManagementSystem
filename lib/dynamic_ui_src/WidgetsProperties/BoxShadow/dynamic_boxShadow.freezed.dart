// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_boxShadow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicBoxShadow _$DynamicBoxShadowFromJson(Map<String, dynamic> json) {
  return _DynamicBoxShadow.fromJson(json);
}

/// @nodoc
mixin _$DynamicBoxShadow {
  String? get color => throw _privateConstructorUsedError;
  double? get blurRadius => throw _privateConstructorUsedError;
  DynamicOffset get offset => throw _privateConstructorUsedError;
  double? get spreadRadius => throw _privateConstructorUsedError;
  BlurStyle? get blurStyle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicBoxShadowCopyWith<DynamicBoxShadow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicBoxShadowCopyWith<$Res> {
  factory $DynamicBoxShadowCopyWith(
          DynamicBoxShadow value, $Res Function(DynamicBoxShadow) then) =
      _$DynamicBoxShadowCopyWithImpl<$Res, DynamicBoxShadow>;
  @useResult
  $Res call(
      {String? color,
      double? blurRadius,
      DynamicOffset offset,
      double? spreadRadius,
      BlurStyle? blurStyle});

  $DynamicOffsetCopyWith<$Res> get offset;
}

/// @nodoc
class _$DynamicBoxShadowCopyWithImpl<$Res, $Val extends DynamicBoxShadow>
    implements $DynamicBoxShadowCopyWith<$Res> {
  _$DynamicBoxShadowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? blurRadius = freezed,
    Object? offset = null,
    Object? spreadRadius = freezed,
    Object? blurStyle = freezed,
  }) {
    return _then(_value.copyWith(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      blurRadius: freezed == blurRadius
          ? _value.blurRadius
          : blurRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as DynamicOffset,
      spreadRadius: freezed == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      blurStyle: freezed == blurStyle
          ? _value.blurStyle
          : blurStyle // ignore: cast_nullable_to_non_nullable
              as BlurStyle?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicOffsetCopyWith<$Res> get offset {
    return $DynamicOffsetCopyWith<$Res>(_value.offset, (value) {
      return _then(_value.copyWith(offset: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicBoxShadowImplCopyWith<$Res>
    implements $DynamicBoxShadowCopyWith<$Res> {
  factory _$$DynamicBoxShadowImplCopyWith(_$DynamicBoxShadowImpl value,
          $Res Function(_$DynamicBoxShadowImpl) then) =
      __$$DynamicBoxShadowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? color,
      double? blurRadius,
      DynamicOffset offset,
      double? spreadRadius,
      BlurStyle? blurStyle});

  @override
  $DynamicOffsetCopyWith<$Res> get offset;
}

/// @nodoc
class __$$DynamicBoxShadowImplCopyWithImpl<$Res>
    extends _$DynamicBoxShadowCopyWithImpl<$Res, _$DynamicBoxShadowImpl>
    implements _$$DynamicBoxShadowImplCopyWith<$Res> {
  __$$DynamicBoxShadowImplCopyWithImpl(_$DynamicBoxShadowImpl _value,
      $Res Function(_$DynamicBoxShadowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? blurRadius = freezed,
    Object? offset = null,
    Object? spreadRadius = freezed,
    Object? blurStyle = freezed,
  }) {
    return _then(_$DynamicBoxShadowImpl(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      blurRadius: freezed == blurRadius
          ? _value.blurRadius
          : blurRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as DynamicOffset,
      spreadRadius: freezed == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      blurStyle: freezed == blurStyle
          ? _value.blurStyle
          : blurStyle // ignore: cast_nullable_to_non_nullable
              as BlurStyle?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicBoxShadowImpl implements _DynamicBoxShadow {
  const _$DynamicBoxShadowImpl(
      {this.color,
      this.blurRadius = 0.0,
      this.offset = const DynamicOffset(dx: 0, dy: 0),
      this.spreadRadius = 0.0,
      this.blurStyle = BlurStyle.normal});

  factory _$DynamicBoxShadowImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicBoxShadowImplFromJson(json);

  @override
  final String? color;
  @override
  @JsonKey()
  final double? blurRadius;
  @override
  @JsonKey()
  final DynamicOffset offset;
  @override
  @JsonKey()
  final double? spreadRadius;
  @override
  @JsonKey()
  final BlurStyle? blurStyle;

  @override
  String toString() {
    return 'DynamicBoxShadow(color: $color, blurRadius: $blurRadius, offset: $offset, spreadRadius: $spreadRadius, blurStyle: $blurStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicBoxShadowImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.blurRadius, blurRadius) ||
                other.blurRadius == blurRadius) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.spreadRadius, spreadRadius) ||
                other.spreadRadius == spreadRadius) &&
            (identical(other.blurStyle, blurStyle) ||
                other.blurStyle == blurStyle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, color, blurRadius, offset, spreadRadius, blurStyle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicBoxShadowImplCopyWith<_$DynamicBoxShadowImpl> get copyWith =>
      __$$DynamicBoxShadowImplCopyWithImpl<_$DynamicBoxShadowImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicBoxShadowImplToJson(
      this,
    );
  }
}

abstract class _DynamicBoxShadow implements DynamicBoxShadow {
  const factory _DynamicBoxShadow(
      {final String? color,
      final double? blurRadius,
      final DynamicOffset offset,
      final double? spreadRadius,
      final BlurStyle? blurStyle}) = _$DynamicBoxShadowImpl;

  factory _DynamicBoxShadow.fromJson(Map<String, dynamic> json) =
      _$DynamicBoxShadowImpl.fromJson;

  @override
  String? get color;
  @override
  double? get blurRadius;
  @override
  DynamicOffset get offset;
  @override
  double? get spreadRadius;
  @override
  BlurStyle? get blurStyle;
  @override
  @JsonKey(ignore: true)
  _$$DynamicBoxShadowImplCopyWith<_$DynamicBoxShadowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
