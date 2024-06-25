// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_alignmentGeometry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicAlignmentGeometry _$DynamicAlignmentGeometryFromJson(
    Map<String, dynamic> json) {
  return _DynamicAlignmentGeometry.fromJson(json);
}

/// @nodoc
mixin _$DynamicAlignmentGeometry {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicAlignmentGeometryCopyWith<DynamicAlignmentGeometry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicAlignmentGeometryCopyWith<$Res> {
  factory $DynamicAlignmentGeometryCopyWith(DynamicAlignmentGeometry value,
          $Res Function(DynamicAlignmentGeometry) then) =
      _$DynamicAlignmentGeometryCopyWithImpl<$Res, DynamicAlignmentGeometry>;
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class _$DynamicAlignmentGeometryCopyWithImpl<$Res,
        $Val extends DynamicAlignmentGeometry>
    implements $DynamicAlignmentGeometryCopyWith<$Res> {
  _$DynamicAlignmentGeometryCopyWithImpl(this._value, this._then);

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
abstract class _$$DynamicAlignmentGeometryImplCopyWith<$Res>
    implements $DynamicAlignmentGeometryCopyWith<$Res> {
  factory _$$DynamicAlignmentGeometryImplCopyWith(
          _$DynamicAlignmentGeometryImpl value,
          $Res Function(_$DynamicAlignmentGeometryImpl) then) =
      __$$DynamicAlignmentGeometryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class __$$DynamicAlignmentGeometryImplCopyWithImpl<$Res>
    extends _$DynamicAlignmentGeometryCopyWithImpl<$Res,
        _$DynamicAlignmentGeometryImpl>
    implements _$$DynamicAlignmentGeometryImplCopyWith<$Res> {
  __$$DynamicAlignmentGeometryImplCopyWithImpl(
      _$DynamicAlignmentGeometryImpl _value,
      $Res Function(_$DynamicAlignmentGeometryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_$DynamicAlignmentGeometryImpl(
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
class _$DynamicAlignmentGeometryImpl implements _DynamicAlignmentGeometry {
  const _$DynamicAlignmentGeometryImpl({required this.dx, required this.dy});

  factory _$DynamicAlignmentGeometryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicAlignmentGeometryImplFromJson(json);

  @override
  final double dx;
  @override
  final double dy;

  @override
  String toString() {
    return 'DynamicAlignmentGeometry(dx: $dx, dy: $dy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicAlignmentGeometryImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dx, dy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicAlignmentGeometryImplCopyWith<_$DynamicAlignmentGeometryImpl>
      get copyWith => __$$DynamicAlignmentGeometryImplCopyWithImpl<
          _$DynamicAlignmentGeometryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicAlignmentGeometryImplToJson(
      this,
    );
  }
}

abstract class _DynamicAlignmentGeometry implements DynamicAlignmentGeometry {
  const factory _DynamicAlignmentGeometry(
      {required final double dx,
      required final double dy}) = _$DynamicAlignmentGeometryImpl;

  factory _DynamicAlignmentGeometry.fromJson(Map<String, dynamic> json) =
      _$DynamicAlignmentGeometryImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;
  @override
  @JsonKey(ignore: true)
  _$$DynamicAlignmentGeometryImplCopyWith<_$DynamicAlignmentGeometryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
