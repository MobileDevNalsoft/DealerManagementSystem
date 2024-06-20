// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_offset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicOffset _$DynamicOffsetFromJson(Map<String, dynamic> json) {
  return _DynamicOffset.fromJson(json);
}

/// @nodoc
mixin _$DynamicOffset {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicOffsetCopyWith<DynamicOffset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicOffsetCopyWith<$Res> {
  factory $DynamicOffsetCopyWith(
          DynamicOffset value, $Res Function(DynamicOffset) then) =
      _$DynamicOffsetCopyWithImpl<$Res, DynamicOffset>;
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class _$DynamicOffsetCopyWithImpl<$Res, $Val extends DynamicOffset>
    implements $DynamicOffsetCopyWith<$Res> {
  _$DynamicOffsetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_value.copyWith(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicOffsetImplCopyWith<$Res>
    implements $DynamicOffsetCopyWith<$Res> {
  factory _$$DynamicOffsetImplCopyWith(
          _$DynamicOffsetImpl value, $Res Function(_$DynamicOffsetImpl) then) =
      __$$DynamicOffsetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class __$$DynamicOffsetImplCopyWithImpl<$Res>
    extends _$DynamicOffsetCopyWithImpl<$Res, _$DynamicOffsetImpl>
    implements _$$DynamicOffsetImplCopyWith<$Res> {
  __$$DynamicOffsetImplCopyWithImpl(
      _$DynamicOffsetImpl _value, $Res Function(_$DynamicOffsetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_$DynamicOffsetImpl(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicOffsetImpl implements _DynamicOffset {
  const _$DynamicOffsetImpl({required this.dx, required this.dy});

  factory _$DynamicOffsetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicOffsetImplFromJson(json);

  @override
  final double dx;
  @override
  final double dy;

  @override
  String toString() {
    return 'DynamicOffset(dx: $dx, dy: $dy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicOffsetImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dx, dy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicOffsetImplCopyWith<_$DynamicOffsetImpl> get copyWith =>
      __$$DynamicOffsetImplCopyWithImpl<_$DynamicOffsetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicOffsetImplToJson(
      this,
    );
  }
}

abstract class _DynamicOffset implements DynamicOffset {
  const factory _DynamicOffset(
      {required final double dx,
      required final double dy}) = _$DynamicOffsetImpl;

  factory _DynamicOffset.fromJson(Map<String, dynamic> json) =
      _$DynamicOffsetImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;
  @override
  @JsonKey(ignore: true)
  _$$DynamicOffsetImplCopyWith<_$DynamicOffsetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
