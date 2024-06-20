// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_sizedbox.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicSizedBox _$DynamicSizedBoxFromJson(Map<String, dynamic> json) {
  return _DynamicSizedBox.fromJson(json);
}

/// @nodoc
mixin _$DynamicSizedBox {
  bool get key => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicSizedBoxCopyWith<DynamicSizedBox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicSizedBoxCopyWith<$Res> {
  factory $DynamicSizedBoxCopyWith(
          DynamicSizedBox value, $Res Function(DynamicSizedBox) then) =
      _$DynamicSizedBoxCopyWithImpl<$Res, DynamicSizedBox>;
  @useResult
  $Res call(
      {bool key, double height, double width, Map<String, dynamic>? child});
}

/// @nodoc
class _$DynamicSizedBoxCopyWithImpl<$Res, $Val extends DynamicSizedBox>
    implements $DynamicSizedBoxCopyWith<$Res> {
  _$DynamicSizedBoxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? height = null,
    Object? width = null,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as bool,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DynamicSizedBoxImplCopyWith<$Res>
    implements $DynamicSizedBoxCopyWith<$Res> {
  factory _$$DynamicSizedBoxImplCopyWith(_$DynamicSizedBoxImpl value,
          $Res Function(_$DynamicSizedBoxImpl) then) =
      __$$DynamicSizedBoxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool key, double height, double width, Map<String, dynamic>? child});
}

/// @nodoc
class __$$DynamicSizedBoxImplCopyWithImpl<$Res>
    extends _$DynamicSizedBoxCopyWithImpl<$Res, _$DynamicSizedBoxImpl>
    implements _$$DynamicSizedBoxImplCopyWith<$Res> {
  __$$DynamicSizedBoxImplCopyWithImpl(
      _$DynamicSizedBoxImpl _value, $Res Function(_$DynamicSizedBoxImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? height = null,
    Object? width = null,
    Object? child = freezed,
  }) {
    return _then(_$DynamicSizedBoxImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as bool,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicSizedBoxImpl
    with DiagnosticableTreeMixin
    implements _DynamicSizedBox {
  const _$DynamicSizedBoxImpl(
      {this.key = false,
      this.height = 0.0,
      this.width = 0.0,
      final Map<String, dynamic>? child})
      : _child = child;

  factory _$DynamicSizedBoxImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicSizedBoxImplFromJson(json);

  @override
  @JsonKey()
  final bool key;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final double width;
  final Map<String, dynamic>? _child;
  @override
  Map<String, dynamic>? get child {
    final value = _child;
    if (value == null) return null;
    if (_child is EqualUnmodifiableMapView) return _child;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DynamicSizedBox(key: $key, height: $height, width: $width, child: $child)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DynamicSizedBox'))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('child', child));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicSizedBoxImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, height, width,
      const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicSizedBoxImplCopyWith<_$DynamicSizedBoxImpl> get copyWith =>
      __$$DynamicSizedBoxImplCopyWithImpl<_$DynamicSizedBoxImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicSizedBoxImplToJson(
      this,
    );
  }
}

abstract class _DynamicSizedBox implements DynamicSizedBox {
  const factory _DynamicSizedBox(
      {final bool key,
      final double height,
      final double width,
      final Map<String, dynamic>? child}) = _$DynamicSizedBoxImpl;

  factory _DynamicSizedBox.fromJson(Map<String, dynamic> json) =
      _$DynamicSizedBoxImpl.fromJson;

  @override
  bool get key;
  @override
  double get height;
  @override
  double get width;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$DynamicSizedBoxImplCopyWith<_$DynamicSizedBoxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
