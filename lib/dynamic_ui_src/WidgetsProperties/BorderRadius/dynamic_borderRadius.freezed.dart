// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_borderRadius.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicBorderRadius _$DynamicBorderRadiusFromJson(Map<String, dynamic> json) {
  return _DynamicBorder.fromJson(json);
}

/// @nodoc
mixin _$DynamicBorderRadius {
  double get topLeft => throw _privateConstructorUsedError;
  double get topRight => throw _privateConstructorUsedError;
  double get bottomLeft => throw _privateConstructorUsedError;
  double get bottomRight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicBorderRadiusCopyWith<DynamicBorderRadius> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicBorderRadiusCopyWith<$Res> {
  factory $DynamicBorderRadiusCopyWith(
          DynamicBorderRadius value, $Res Function(DynamicBorderRadius) then) =
      _$DynamicBorderRadiusCopyWithImpl<$Res, DynamicBorderRadius>;
  @useResult
  $Res call(
      {double topLeft, double topRight, double bottomLeft, double bottomRight});
}

/// @nodoc
class _$DynamicBorderRadiusCopyWithImpl<$Res, $Val extends DynamicBorderRadius>
    implements $DynamicBorderRadiusCopyWith<$Res> {
  _$DynamicBorderRadiusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(_value.copyWith(
      topLeft: null == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double,
      topRight: null == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double,
      bottomLeft: null == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double,
      bottomRight: null == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicBorderImplCopyWith<$Res>
    implements $DynamicBorderRadiusCopyWith<$Res> {
  factory _$$DynamicBorderImplCopyWith(
          _$DynamicBorderImpl value, $Res Function(_$DynamicBorderImpl) then) =
      __$$DynamicBorderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double topLeft, double topRight, double bottomLeft, double bottomRight});
}

/// @nodoc
class __$$DynamicBorderImplCopyWithImpl<$Res>
    extends _$DynamicBorderRadiusCopyWithImpl<$Res, _$DynamicBorderImpl>
    implements _$$DynamicBorderImplCopyWith<$Res> {
  __$$DynamicBorderImplCopyWithImpl(
      _$DynamicBorderImpl _value, $Res Function(_$DynamicBorderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(_$DynamicBorderImpl(
      topLeft: null == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double,
      topRight: null == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double,
      bottomLeft: null == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double,
      bottomRight: null == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicBorderImpl implements _DynamicBorder {
  const _$DynamicBorderImpl(
      {this.topLeft = 0.0,
      this.topRight = 0.0,
      this.bottomLeft = 0.0,
      this.bottomRight = 0.0});

  factory _$DynamicBorderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicBorderImplFromJson(json);

  @override
  @JsonKey()
  final double topLeft;
  @override
  @JsonKey()
  final double topRight;
  @override
  @JsonKey()
  final double bottomLeft;
  @override
  @JsonKey()
  final double bottomRight;

  @override
  String toString() {
    return 'DynamicBorderRadius(topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicBorderImpl &&
            (identical(other.topLeft, topLeft) || other.topLeft == topLeft) &&
            (identical(other.topRight, topRight) ||
                other.topRight == topRight) &&
            (identical(other.bottomLeft, bottomLeft) ||
                other.bottomLeft == bottomLeft) &&
            (identical(other.bottomRight, bottomRight) ||
                other.bottomRight == bottomRight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topLeft, topRight, bottomLeft, bottomRight);

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

abstract class _DynamicBorder implements DynamicBorderRadius {
  const factory _DynamicBorder(
      {final double topLeft,
      final double topRight,
      final double bottomLeft,
      final double bottomRight}) = _$DynamicBorderImpl;

  factory _DynamicBorder.fromJson(Map<String, dynamic> json) =
      _$DynamicBorderImpl.fromJson;

  @override
  double get topLeft;
  @override
  double get topRight;
  @override
  double get bottomLeft;
  @override
  double get bottomRight;
  @override
  @JsonKey(ignore: true)
  _$$DynamicBorderImplCopyWith<_$DynamicBorderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
