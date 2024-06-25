// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_gap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicGap _$DynamicGapFromJson(Map<String, dynamic> json) {
  return _DynamicGap.fromJson(json);
}

/// @nodoc
mixin _$DynamicGap {
  bool get key => throw _privateConstructorUsedError;
  bool get max => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicGapCopyWith<DynamicGap> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicGapCopyWith<$Res> {
  factory $DynamicGapCopyWith(
          DynamicGap value, $Res Function(DynamicGap) then) =
      _$DynamicGapCopyWithImpl<$Res, DynamicGap>;
  @useResult
  $Res call({bool key, bool max, double value});
}

/// @nodoc
class _$DynamicGapCopyWithImpl<$Res, $Val extends DynamicGap>
    implements $DynamicGapCopyWith<$Res> {
  _$DynamicGapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? max = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as bool,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as bool,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicGapImplCopyWith<$Res>
    implements $DynamicGapCopyWith<$Res> {
  factory _$$DynamicGapImplCopyWith(
          _$DynamicGapImpl value, $Res Function(_$DynamicGapImpl) then) =
      __$$DynamicGapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool key, bool max, double value});
}

/// @nodoc
class __$$DynamicGapImplCopyWithImpl<$Res>
    extends _$DynamicGapCopyWithImpl<$Res, _$DynamicGapImpl>
    implements _$$DynamicGapImplCopyWith<$Res> {
  __$$DynamicGapImplCopyWithImpl(
      _$DynamicGapImpl _value, $Res Function(_$DynamicGapImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? max = null,
    Object? value = null,
  }) {
    return _then(_$DynamicGapImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as bool,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as bool,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicGapImpl implements _DynamicGap {
  const _$DynamicGapImpl(
      {this.key = false, this.max = false, this.value = 0.0});

  factory _$DynamicGapImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicGapImplFromJson(json);

  @override
  @JsonKey()
  final bool key;
  @override
  @JsonKey()
  final bool max;
  @override
  @JsonKey()
  final double value;

  @override
  String toString() {
    return 'DynamicGap(key: $key, max: $max, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicGapImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, max, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicGapImplCopyWith<_$DynamicGapImpl> get copyWith =>
      __$$DynamicGapImplCopyWithImpl<_$DynamicGapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicGapImplToJson(
      this,
    );
  }
}

abstract class _DynamicGap implements DynamicGap {
  const factory _DynamicGap(
      {final bool key, final bool max, final double value}) = _$DynamicGapImpl;

  factory _DynamicGap.fromJson(Map<String, dynamic> json) =
      _$DynamicGapImpl.fromJson;

  @override
  bool get key;
  @override
  bool get max;
  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$DynamicGapImplCopyWith<_$DynamicGapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
