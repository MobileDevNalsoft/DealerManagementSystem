// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_gradient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicGradient _$DynamicGradientFromJson(Map<String, dynamic> json) {
  return _DynamicGradient.fromJson(json);
}

/// @nodoc
mixin _$DynamicGradient {
  List<String> get colors => throw _privateConstructorUsedError;
  List<double>? get stops => throw _privateConstructorUsedError;
  DynamicAlignment get begin => throw _privateConstructorUsedError;
  DynamicAlignment get end => throw _privateConstructorUsedError;
  DynamicAlignment get center => throw _privateConstructorUsedError;
  DynamicGradientType get gradientType => throw _privateConstructorUsedError;
  DynamicAlignmentGeometry? get focal => throw _privateConstructorUsedError;
  TileMode get tileMode => throw _privateConstructorUsedError;
  double get focalRadius => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  double get startAngle => throw _privateConstructorUsedError;
  double get endAngle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicGradientCopyWith<DynamicGradient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicGradientCopyWith<$Res> {
  factory $DynamicGradientCopyWith(
          DynamicGradient value, $Res Function(DynamicGradient) then) =
      _$DynamicGradientCopyWithImpl<$Res, DynamicGradient>;
  @useResult
  $Res call(
      {List<String> colors,
      List<double>? stops,
      DynamicAlignment begin,
      DynamicAlignment end,
      DynamicAlignment center,
      DynamicGradientType gradientType,
      DynamicAlignmentGeometry? focal,
      TileMode tileMode,
      double focalRadius,
      double radius,
      double startAngle,
      double endAngle});

  $DynamicAlignmentGeometryCopyWith<$Res>? get focal;
}

/// @nodoc
class _$DynamicGradientCopyWithImpl<$Res, $Val extends DynamicGradient>
    implements $DynamicGradientCopyWith<$Res> {
  _$DynamicGradientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? stops = freezed,
    Object? begin = null,
    Object? end = null,
    Object? center = null,
    Object? gradientType = null,
    Object? focal = freezed,
    Object? tileMode = null,
    Object? focalRadius = null,
    Object? radius = null,
    Object? startAngle = null,
    Object? endAngle = null,
  }) {
    return _then(_value.copyWith(
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stops: freezed == stops
          ? _value.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      begin: null == begin
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      gradientType: null == gradientType
          ? _value.gradientType
          : gradientType // ignore: cast_nullable_to_non_nullable
              as DynamicGradientType,
      focal: freezed == focal
          ? _value.focal
          : focal // ignore: cast_nullable_to_non_nullable
              as DynamicAlignmentGeometry?,
      tileMode: null == tileMode
          ? _value.tileMode
          : tileMode // ignore: cast_nullable_to_non_nullable
              as TileMode,
      focalRadius: null == focalRadius
          ? _value.focalRadius
          : focalRadius // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      startAngle: null == startAngle
          ? _value.startAngle
          : startAngle // ignore: cast_nullable_to_non_nullable
              as double,
      endAngle: null == endAngle
          ? _value.endAngle
          : endAngle // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicAlignmentGeometryCopyWith<$Res>? get focal {
    if (_value.focal == null) {
      return null;
    }

    return $DynamicAlignmentGeometryCopyWith<$Res>(_value.focal!, (value) {
      return _then(_value.copyWith(focal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicGradientImplCopyWith<$Res>
    implements $DynamicGradientCopyWith<$Res> {
  factory _$$DynamicGradientImplCopyWith(_$DynamicGradientImpl value,
          $Res Function(_$DynamicGradientImpl) then) =
      __$$DynamicGradientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> colors,
      List<double>? stops,
      DynamicAlignment begin,
      DynamicAlignment end,
      DynamicAlignment center,
      DynamicGradientType gradientType,
      DynamicAlignmentGeometry? focal,
      TileMode tileMode,
      double focalRadius,
      double radius,
      double startAngle,
      double endAngle});

  @override
  $DynamicAlignmentGeometryCopyWith<$Res>? get focal;
}

/// @nodoc
class __$$DynamicGradientImplCopyWithImpl<$Res>
    extends _$DynamicGradientCopyWithImpl<$Res, _$DynamicGradientImpl>
    implements _$$DynamicGradientImplCopyWith<$Res> {
  __$$DynamicGradientImplCopyWithImpl(
      _$DynamicGradientImpl _value, $Res Function(_$DynamicGradientImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? stops = freezed,
    Object? begin = null,
    Object? end = null,
    Object? center = null,
    Object? gradientType = null,
    Object? focal = freezed,
    Object? tileMode = null,
    Object? focalRadius = null,
    Object? radius = null,
    Object? startAngle = null,
    Object? endAngle = null,
  }) {
    return _then(_$DynamicGradientImpl(
      colors: null == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stops: freezed == stops
          ? _value._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      begin: null == begin
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as DynamicAlignment,
      gradientType: null == gradientType
          ? _value.gradientType
          : gradientType // ignore: cast_nullable_to_non_nullable
              as DynamicGradientType,
      focal: freezed == focal
          ? _value.focal
          : focal // ignore: cast_nullable_to_non_nullable
              as DynamicAlignmentGeometry?,
      tileMode: null == tileMode
          ? _value.tileMode
          : tileMode // ignore: cast_nullable_to_non_nullable
              as TileMode,
      focalRadius: null == focalRadius
          ? _value.focalRadius
          : focalRadius // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      startAngle: null == startAngle
          ? _value.startAngle
          : startAngle // ignore: cast_nullable_to_non_nullable
              as double,
      endAngle: null == endAngle
          ? _value.endAngle
          : endAngle // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicGradientImpl implements _DynamicGradient {
  const _$DynamicGradientImpl(
      {required final List<String> colors,
      final List<double>? stops,
      this.begin = DynamicAlignment.centerLeft,
      this.end = DynamicAlignment.centerRight,
      this.center = DynamicAlignment.center,
      this.gradientType = DynamicGradientType.linear,
      this.focal,
      this.tileMode = TileMode.clamp,
      this.focalRadius = 0.0,
      this.radius = 0.5,
      this.startAngle = 0.0,
      this.endAngle = math.pi * 2})
      : _colors = colors,
        _stops = stops;

  factory _$DynamicGradientImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicGradientImplFromJson(json);

  final List<String> _colors;
  @override
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  final List<double>? _stops;
  @override
  List<double>? get stops {
    final value = _stops;
    if (value == null) return null;
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final DynamicAlignment begin;
  @override
  @JsonKey()
  final DynamicAlignment end;
  @override
  @JsonKey()
  final DynamicAlignment center;
  @override
  @JsonKey()
  final DynamicGradientType gradientType;
  @override
  final DynamicAlignmentGeometry? focal;
  @override
  @JsonKey()
  final TileMode tileMode;
  @override
  @JsonKey()
  final double focalRadius;
  @override
  @JsonKey()
  final double radius;
  @override
  @JsonKey()
  final double startAngle;
  @override
  @JsonKey()
  final double endAngle;

  @override
  String toString() {
    return 'DynamicGradient(colors: $colors, stops: $stops, begin: $begin, end: $end, center: $center, gradientType: $gradientType, focal: $focal, tileMode: $tileMode, focalRadius: $focalRadius, radius: $radius, startAngle: $startAngle, endAngle: $endAngle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicGradientImpl &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.begin, begin) || other.begin == begin) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.gradientType, gradientType) ||
                other.gradientType == gradientType) &&
            (identical(other.focal, focal) || other.focal == focal) &&
            (identical(other.tileMode, tileMode) ||
                other.tileMode == tileMode) &&
            (identical(other.focalRadius, focalRadius) ||
                other.focalRadius == focalRadius) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.startAngle, startAngle) ||
                other.startAngle == startAngle) &&
            (identical(other.endAngle, endAngle) ||
                other.endAngle == endAngle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_colors),
      const DeepCollectionEquality().hash(_stops),
      begin,
      end,
      center,
      gradientType,
      focal,
      tileMode,
      focalRadius,
      radius,
      startAngle,
      endAngle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicGradientImplCopyWith<_$DynamicGradientImpl> get copyWith =>
      __$$DynamicGradientImplCopyWithImpl<_$DynamicGradientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicGradientImplToJson(
      this,
    );
  }
}

abstract class _DynamicGradient implements DynamicGradient {
  const factory _DynamicGradient(
      {required final List<String> colors,
      final List<double>? stops,
      final DynamicAlignment begin,
      final DynamicAlignment end,
      final DynamicAlignment center,
      final DynamicGradientType gradientType,
      final DynamicAlignmentGeometry? focal,
      final TileMode tileMode,
      final double focalRadius,
      final double radius,
      final double startAngle,
      final double endAngle}) = _$DynamicGradientImpl;

  factory _DynamicGradient.fromJson(Map<String, dynamic> json) =
      _$DynamicGradientImpl.fromJson;

  @override
  List<String> get colors;
  @override
  List<double>? get stops;
  @override
  DynamicAlignment get begin;
  @override
  DynamicAlignment get end;
  @override
  DynamicAlignment get center;
  @override
  DynamicGradientType get gradientType;
  @override
  DynamicAlignmentGeometry? get focal;
  @override
  TileMode get tileMode;
  @override
  double get focalRadius;
  @override
  double get radius;
  @override
  double get startAngle;
  @override
  double get endAngle;
  @override
  @JsonKey(ignore: true)
  _$$DynamicGradientImplCopyWith<_$DynamicGradientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
