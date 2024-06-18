// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_padding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicPadding _$DynamicPaddingFromJson(Map<String, dynamic> json) {
  return _DynamicPadding.fromJson(json);
}

/// @nodoc
mixin _$DynamicPadding {
  DynamicEdgeInsets get padding => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicPaddingCopyWith<DynamicPadding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicPaddingCopyWith<$Res> {
  factory $DynamicPaddingCopyWith(
          DynamicPadding value, $Res Function(DynamicPadding) then) =
      _$DynamicPaddingCopyWithImpl<$Res, DynamicPadding>;
  @useResult
  $Res call({DynamicEdgeInsets padding, Map<String, dynamic>? child});

  $DynamicEdgeInsetsCopyWith<$Res> get padding;
}

/// @nodoc
class _$DynamicPaddingCopyWithImpl<$Res, $Val extends DynamicPadding>
    implements $DynamicPaddingCopyWith<$Res> {
  _$DynamicPaddingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? padding = null,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      padding: null == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicEdgeInsetsCopyWith<$Res> get padding {
    return $DynamicEdgeInsetsCopyWith<$Res>(_value.padding, (value) {
      return _then(_value.copyWith(padding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicPaddingImplCopyWith<$Res>
    implements $DynamicPaddingCopyWith<$Res> {
  factory _$$DynamicPaddingImplCopyWith(_$DynamicPaddingImpl value,
          $Res Function(_$DynamicPaddingImpl) then) =
      __$$DynamicPaddingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DynamicEdgeInsets padding, Map<String, dynamic>? child});

  @override
  $DynamicEdgeInsetsCopyWith<$Res> get padding;
}

/// @nodoc
class __$$DynamicPaddingImplCopyWithImpl<$Res>
    extends _$DynamicPaddingCopyWithImpl<$Res, _$DynamicPaddingImpl>
    implements _$$DynamicPaddingImplCopyWith<$Res> {
  __$$DynamicPaddingImplCopyWithImpl(
      _$DynamicPaddingImpl _value, $Res Function(_$DynamicPaddingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? padding = null,
    Object? child = freezed,
  }) {
    return _then(_$DynamicPaddingImpl(
      padding: null == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicPaddingImpl implements _DynamicPadding {
  const _$DynamicPaddingImpl(
      {required this.padding, final Map<String, dynamic>? child})
      : _child = child;

  factory _$DynamicPaddingImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicPaddingImplFromJson(json);

  @override
  final DynamicEdgeInsets padding;
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
  String toString() {
    return 'DynamicPadding(padding: $padding, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicPaddingImpl &&
            (identical(other.padding, padding) || other.padding == padding) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, padding, const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicPaddingImplCopyWith<_$DynamicPaddingImpl> get copyWith =>
      __$$DynamicPaddingImplCopyWithImpl<_$DynamicPaddingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicPaddingImplToJson(
      this,
    );
  }
}

abstract class _DynamicPadding implements DynamicPadding {
  const factory _DynamicPadding(
      {required final DynamicEdgeInsets padding,
      final Map<String, dynamic>? child}) = _$DynamicPaddingImpl;

  factory _DynamicPadding.fromJson(Map<String, dynamic> json) =
      _$DynamicPaddingImpl.fromJson;

  @override
  DynamicEdgeInsets get padding;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$DynamicPaddingImplCopyWith<_$DynamicPaddingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
