// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_boxConstraints.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicBoxConstraints _$DynamicBoxConstraintsFromJson(
    Map<String, dynamic> json) {
  return _DynamicBoxConstraints.fromJson(json);
}

/// @nodoc
mixin _$DynamicBoxConstraints {
  double get minWidth => throw _privateConstructorUsedError;
  double get maxWidth => throw _privateConstructorUsedError;
  double get minHeight => throw _privateConstructorUsedError;
  double get maxHeight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicBoxConstraintsCopyWith<DynamicBoxConstraints> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicBoxConstraintsCopyWith<$Res> {
  factory $DynamicBoxConstraintsCopyWith(DynamicBoxConstraints value,
          $Res Function(DynamicBoxConstraints) then) =
      _$DynamicBoxConstraintsCopyWithImpl<$Res, DynamicBoxConstraints>;
  @useResult
  $Res call(
      {double minWidth, double maxWidth, double minHeight, double maxHeight});
}

/// @nodoc
class _$DynamicBoxConstraintsCopyWithImpl<$Res,
        $Val extends DynamicBoxConstraints>
    implements $DynamicBoxConstraintsCopyWith<$Res> {
  _$DynamicBoxConstraintsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minWidth = null,
    Object? maxWidth = null,
    Object? minHeight = null,
    Object? maxHeight = null,
  }) {
    return _then(_value.copyWith(
      minWidth: null == minWidth
          ? _value.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as double,
      maxWidth: null == maxWidth
          ? _value.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double,
      minHeight: null == minHeight
          ? _value.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxHeight: null == maxHeight
          ? _value.maxHeight
          : maxHeight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicBoxConstraintsImplCopyWith<$Res>
    implements $DynamicBoxConstraintsCopyWith<$Res> {
  factory _$$DynamicBoxConstraintsImplCopyWith(
          _$DynamicBoxConstraintsImpl value,
          $Res Function(_$DynamicBoxConstraintsImpl) then) =
      __$$DynamicBoxConstraintsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double minWidth, double maxWidth, double minHeight, double maxHeight});
}

/// @nodoc
class __$$DynamicBoxConstraintsImplCopyWithImpl<$Res>
    extends _$DynamicBoxConstraintsCopyWithImpl<$Res,
        _$DynamicBoxConstraintsImpl>
    implements _$$DynamicBoxConstraintsImplCopyWith<$Res> {
  __$$DynamicBoxConstraintsImplCopyWithImpl(_$DynamicBoxConstraintsImpl _value,
      $Res Function(_$DynamicBoxConstraintsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minWidth = null,
    Object? maxWidth = null,
    Object? minHeight = null,
    Object? maxHeight = null,
  }) {
    return _then(_$DynamicBoxConstraintsImpl(
      minWidth: null == minWidth
          ? _value.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as double,
      maxWidth: null == maxWidth
          ? _value.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double,
      minHeight: null == minHeight
          ? _value.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxHeight: null == maxHeight
          ? _value.maxHeight
          : maxHeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicBoxConstraintsImpl implements _DynamicBoxConstraints {
  const _$DynamicBoxConstraintsImpl(
      {required this.minWidth,
      required this.maxWidth,
      required this.minHeight,
      required this.maxHeight});

  factory _$DynamicBoxConstraintsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicBoxConstraintsImplFromJson(json);

  @override
  final double minWidth;
  @override
  final double maxWidth;
  @override
  final double minHeight;
  @override
  final double maxHeight;

  @override
  String toString() {
    return 'DynamicBoxConstraints(minWidth: $minWidth, maxWidth: $maxWidth, minHeight: $minHeight, maxHeight: $maxHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicBoxConstraintsImpl &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.maxWidth, maxWidth) ||
                other.maxWidth == maxWidth) &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.maxHeight, maxHeight) ||
                other.maxHeight == maxHeight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minWidth, maxWidth, minHeight, maxHeight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicBoxConstraintsImplCopyWith<_$DynamicBoxConstraintsImpl>
      get copyWith => __$$DynamicBoxConstraintsImplCopyWithImpl<
          _$DynamicBoxConstraintsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicBoxConstraintsImplToJson(
      this,
    );
  }
}

abstract class _DynamicBoxConstraints implements DynamicBoxConstraints {
  const factory _DynamicBoxConstraints(
      {required final double minWidth,
      required final double maxWidth,
      required final double minHeight,
      required final double maxHeight}) = _$DynamicBoxConstraintsImpl;

  factory _DynamicBoxConstraints.fromJson(Map<String, dynamic> json) =
      _$DynamicBoxConstraintsImpl.fromJson;

  @override
  double get minWidth;
  @override
  double get maxWidth;
  @override
  double get minHeight;
  @override
  double get maxHeight;
  @override
  @JsonKey(ignore: true)
  _$$DynamicBoxConstraintsImplCopyWith<_$DynamicBoxConstraintsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
