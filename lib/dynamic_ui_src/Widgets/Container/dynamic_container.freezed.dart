// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicContainer _$DynamicContainerFromJson(Map<String, dynamic> json) {
  return _DynamicContainer.fromJson(json);
}

/// @nodoc
mixin _$DynamicContainer {
  DynamicAlignment? get alignment => throw _privateConstructorUsedError;
  DynamicEdgeInsets? get padding => throw _privateConstructorUsedError;
  DynamicBoxDecoration? get decoration => throw _privateConstructorUsedError;
  DynamicBoxDecoration? get foregroundDecoration =>
      throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  double? get opacity => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  DynamicBoxConstraints? get constraints => throw _privateConstructorUsedError;
  DynamicEdgeInsets? get margin => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;
  Clip get clipBehavior => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicContainerCopyWith<DynamicContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicContainerCopyWith<$Res> {
  factory $DynamicContainerCopyWith(
          DynamicContainer value, $Res Function(DynamicContainer) then) =
      _$DynamicContainerCopyWithImpl<$Res, DynamicContainer>;
  @useResult
  $Res call(
      {DynamicAlignment? alignment,
      DynamicEdgeInsets? padding,
      DynamicBoxDecoration? decoration,
      DynamicBoxDecoration? foregroundDecoration,
      String? color,
      double? opacity,
      double? width,
      double? height,
      DynamicBoxConstraints? constraints,
      DynamicEdgeInsets? margin,
      Map<String, dynamic>? child,
      Clip clipBehavior});

  $DynamicEdgeInsetsCopyWith<$Res>? get padding;
  $DynamicBoxDecorationCopyWith<$Res>? get decoration;
  $DynamicBoxDecorationCopyWith<$Res>? get foregroundDecoration;
  $DynamicBoxConstraintsCopyWith<$Res>? get constraints;
  $DynamicEdgeInsetsCopyWith<$Res>? get margin;
}

/// @nodoc
class _$DynamicContainerCopyWithImpl<$Res, $Val extends DynamicContainer>
    implements $DynamicContainerCopyWith<$Res> {
  _$DynamicContainerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alignment = freezed,
    Object? padding = freezed,
    Object? decoration = freezed,
    Object? foregroundDecoration = freezed,
    Object? color = freezed,
    Object? opacity = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? constraints = freezed,
    Object? margin = freezed,
    Object? child = freezed,
    Object? clipBehavior = null,
  }) {
    return _then(_value.copyWith(
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment?,
      padding: freezed == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as DynamicBoxDecoration?,
      foregroundDecoration: freezed == foregroundDecoration
          ? _value.foregroundDecoration
          : foregroundDecoration // ignore: cast_nullable_to_non_nullable
              as DynamicBoxDecoration?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      opacity: freezed == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as DynamicBoxConstraints?,
      margin: freezed == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      clipBehavior: null == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as Clip,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicEdgeInsetsCopyWith<$Res>? get padding {
    if (_value.padding == null) {
      return null;
    }

    return $DynamicEdgeInsetsCopyWith<$Res>(_value.padding!, (value) {
      return _then(_value.copyWith(padding: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicBoxDecorationCopyWith<$Res>? get decoration {
    if (_value.decoration == null) {
      return null;
    }

    return $DynamicBoxDecorationCopyWith<$Res>(_value.decoration!, (value) {
      return _then(_value.copyWith(decoration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicBoxDecorationCopyWith<$Res>? get foregroundDecoration {
    if (_value.foregroundDecoration == null) {
      return null;
    }

    return $DynamicBoxDecorationCopyWith<$Res>(_value.foregroundDecoration!,
        (value) {
      return _then(_value.copyWith(foregroundDecoration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicBoxConstraintsCopyWith<$Res>? get constraints {
    if (_value.constraints == null) {
      return null;
    }

    return $DynamicBoxConstraintsCopyWith<$Res>(_value.constraints!, (value) {
      return _then(_value.copyWith(constraints: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicEdgeInsetsCopyWith<$Res>? get margin {
    if (_value.margin == null) {
      return null;
    }

    return $DynamicEdgeInsetsCopyWith<$Res>(_value.margin!, (value) {
      return _then(_value.copyWith(margin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicContainerImplCopyWith<$Res>
    implements $DynamicContainerCopyWith<$Res> {
  factory _$$DynamicContainerImplCopyWith(_$DynamicContainerImpl value,
          $Res Function(_$DynamicContainerImpl) then) =
      __$$DynamicContainerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DynamicAlignment? alignment,
      DynamicEdgeInsets? padding,
      DynamicBoxDecoration? decoration,
      DynamicBoxDecoration? foregroundDecoration,
      String? color,
      double? opacity,
      double? width,
      double? height,
      DynamicBoxConstraints? constraints,
      DynamicEdgeInsets? margin,
      Map<String, dynamic>? child,
      Clip clipBehavior});

  @override
  $DynamicEdgeInsetsCopyWith<$Res>? get padding;
  @override
  $DynamicBoxDecorationCopyWith<$Res>? get decoration;
  @override
  $DynamicBoxDecorationCopyWith<$Res>? get foregroundDecoration;
  @override
  $DynamicBoxConstraintsCopyWith<$Res>? get constraints;
  @override
  $DynamicEdgeInsetsCopyWith<$Res>? get margin;
}

/// @nodoc
class __$$DynamicContainerImplCopyWithImpl<$Res>
    extends _$DynamicContainerCopyWithImpl<$Res, _$DynamicContainerImpl>
    implements _$$DynamicContainerImplCopyWith<$Res> {
  __$$DynamicContainerImplCopyWithImpl(_$DynamicContainerImpl _value,
      $Res Function(_$DynamicContainerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alignment = freezed,
    Object? padding = freezed,
    Object? decoration = freezed,
    Object? foregroundDecoration = freezed,
    Object? color = freezed,
    Object? opacity = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? constraints = freezed,
    Object? margin = freezed,
    Object? child = freezed,
    Object? clipBehavior = null,
  }) {
    return _then(_$DynamicContainerImpl(
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment?,
      padding: freezed == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as DynamicBoxDecoration?,
      foregroundDecoration: freezed == foregroundDecoration
          ? _value.foregroundDecoration
          : foregroundDecoration // ignore: cast_nullable_to_non_nullable
              as DynamicBoxDecoration?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      opacity: freezed == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as DynamicBoxConstraints?,
      margin: freezed == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as DynamicEdgeInsets?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      clipBehavior: null == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as Clip,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicContainerImpl implements _DynamicContainer {
  const _$DynamicContainerImpl(
      {this.alignment,
      this.padding,
      this.decoration,
      this.foregroundDecoration,
      this.color,
      this.opacity,
      this.width,
      this.height,
      this.constraints,
      this.margin,
      final Map<String, dynamic>? child,
      this.clipBehavior = Clip.none})
      : _child = child;

  factory _$DynamicContainerImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicContainerImplFromJson(json);

  @override
  final DynamicAlignment? alignment;
  @override
  final DynamicEdgeInsets? padding;
  @override
  final DynamicBoxDecoration? decoration;
  @override
  final DynamicBoxDecoration? foregroundDecoration;
  @override
  final String? color;
  @override
  final double? opacity;
  @override
  final double? width;
  @override
  final double? height;
  @override
  final DynamicBoxConstraints? constraints;
  @override
  final DynamicEdgeInsets? margin;
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
  @JsonKey()
  final Clip clipBehavior;

  @override
  String toString() {
    return 'DynamicContainer(alignment: $alignment, padding: $padding, decoration: $decoration, foregroundDecoration: $foregroundDecoration, color: $color, opacity: $opacity, width: $width, height: $height, constraints: $constraints, margin: $margin, child: $child, clipBehavior: $clipBehavior)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicContainerImpl &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.decoration, decoration) ||
                other.decoration == decoration) &&
            (identical(other.foregroundDecoration, foregroundDecoration) ||
                other.foregroundDecoration == foregroundDecoration) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.constraints, constraints) ||
                other.constraints == constraints) &&
            (identical(other.margin, margin) || other.margin == margin) &&
            const DeepCollectionEquality().equals(other._child, _child) &&
            (identical(other.clipBehavior, clipBehavior) ||
                other.clipBehavior == clipBehavior));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      alignment,
      padding,
      decoration,
      foregroundDecoration,
      color,
      opacity,
      width,
      height,
      constraints,
      margin,
      const DeepCollectionEquality().hash(_child),
      clipBehavior);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicContainerImplCopyWith<_$DynamicContainerImpl> get copyWith =>
      __$$DynamicContainerImplCopyWithImpl<_$DynamicContainerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicContainerImplToJson(
      this,
    );
  }
}

abstract class _DynamicContainer implements DynamicContainer {
  const factory _DynamicContainer(
      {final DynamicAlignment? alignment,
      final DynamicEdgeInsets? padding,
      final DynamicBoxDecoration? decoration,
      final DynamicBoxDecoration? foregroundDecoration,
      final String? color,
      final double? opacity,
      final double? width,
      final double? height,
      final DynamicBoxConstraints? constraints,
      final DynamicEdgeInsets? margin,
      final Map<String, dynamic>? child,
      final Clip clipBehavior}) = _$DynamicContainerImpl;

  factory _DynamicContainer.fromJson(Map<String, dynamic> json) =
      _$DynamicContainerImpl.fromJson;

  @override
  DynamicAlignment? get alignment;
  @override
  DynamicEdgeInsets? get padding;
  @override
  DynamicBoxDecoration? get decoration;
  @override
  DynamicBoxDecoration? get foregroundDecoration;
  @override
  String? get color;
  @override
  double? get opacity;
  @override
  double? get width;
  @override
  double? get height;
  @override
  DynamicBoxConstraints? get constraints;
  @override
  DynamicEdgeInsets? get margin;
  @override
  Map<String, dynamic>? get child;
  @override
  Clip get clipBehavior;
  @override
  @JsonKey(ignore: true)
  _$$DynamicContainerImplCopyWith<_$DynamicContainerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
