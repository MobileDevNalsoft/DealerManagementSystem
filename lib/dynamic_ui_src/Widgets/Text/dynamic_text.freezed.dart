// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicText _$DynamicTextFromJson(Map<String, dynamic> json) {
  return _DynamicText.fromJson(json);
}

/// @nodoc
mixin _$DynamicText {
  String get data => throw _privateConstructorUsedError;
  List<DynamicTextSpan> get children => throw _privateConstructorUsedError;
  DynamicTextStyle? get style => throw _privateConstructorUsedError;
  TextAlign? get textAlign => throw _privateConstructorUsedError;
  TextDirection? get textDirection => throw _privateConstructorUsedError;
  bool? get softWrap => throw _privateConstructorUsedError;
  TextOverflow? get overflow => throw _privateConstructorUsedError;
  double? get textScaleFactor => throw _privateConstructorUsedError;
  int? get maxLines => throw _privateConstructorUsedError;
  String? get semanticsLabel => throw _privateConstructorUsedError;
  TextWidthBasis? get textWidthBasis => throw _privateConstructorUsedError;
  String? get selectionColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicTextCopyWith<DynamicText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicTextCopyWith<$Res> {
  factory $DynamicTextCopyWith(
          DynamicText value, $Res Function(DynamicText) then) =
      _$DynamicTextCopyWithImpl<$Res, DynamicText>;
  @useResult
  $Res call(
      {String data,
      List<DynamicTextSpan> children,
      DynamicTextStyle? style,
      TextAlign? textAlign,
      TextDirection? textDirection,
      bool? softWrap,
      TextOverflow? overflow,
      double? textScaleFactor,
      int? maxLines,
      String? semanticsLabel,
      TextWidthBasis? textWidthBasis,
      String? selectionColor});

  $DynamicTextStyleCopyWith<$Res>? get style;
}

/// @nodoc
class _$DynamicTextCopyWithImpl<$Res, $Val extends DynamicText>
    implements $DynamicTextCopyWith<$Res> {
  _$DynamicTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? children = null,
    Object? style = freezed,
    Object? textAlign = freezed,
    Object? textDirection = freezed,
    Object? softWrap = freezed,
    Object? overflow = freezed,
    Object? textScaleFactor = freezed,
    Object? maxLines = freezed,
    Object? semanticsLabel = freezed,
    Object? textWidthBasis = freezed,
    Object? selectionColor = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<DynamicTextSpan>,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as DynamicTextStyle?,
      textAlign: freezed == textAlign
          ? _value.textAlign
          : textAlign // ignore: cast_nullable_to_non_nullable
              as TextAlign?,
      textDirection: freezed == textDirection
          ? _value.textDirection
          : textDirection // ignore: cast_nullable_to_non_nullable
              as TextDirection?,
      softWrap: freezed == softWrap
          ? _value.softWrap
          : softWrap // ignore: cast_nullable_to_non_nullable
              as bool?,
      overflow: freezed == overflow
          ? _value.overflow
          : overflow // ignore: cast_nullable_to_non_nullable
              as TextOverflow?,
      textScaleFactor: freezed == textScaleFactor
          ? _value.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLines: freezed == maxLines
          ? _value.maxLines
          : maxLines // ignore: cast_nullable_to_non_nullable
              as int?,
      semanticsLabel: freezed == semanticsLabel
          ? _value.semanticsLabel
          : semanticsLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      textWidthBasis: freezed == textWidthBasis
          ? _value.textWidthBasis
          : textWidthBasis // ignore: cast_nullable_to_non_nullable
              as TextWidthBasis?,
      selectionColor: freezed == selectionColor
          ? _value.selectionColor
          : selectionColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicTextStyleCopyWith<$Res>? get style {
    if (_value.style == null) {
      return null;
    }

    return $DynamicTextStyleCopyWith<$Res>(_value.style!, (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicTextImplCopyWith<$Res>
    implements $DynamicTextCopyWith<$Res> {
  factory _$$DynamicTextImplCopyWith(
          _$DynamicTextImpl value, $Res Function(_$DynamicTextImpl) then) =
      __$$DynamicTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String data,
      List<DynamicTextSpan> children,
      DynamicTextStyle? style,
      TextAlign? textAlign,
      TextDirection? textDirection,
      bool? softWrap,
      TextOverflow? overflow,
      double? textScaleFactor,
      int? maxLines,
      String? semanticsLabel,
      TextWidthBasis? textWidthBasis,
      String? selectionColor});

  @override
  $DynamicTextStyleCopyWith<$Res>? get style;
}

/// @nodoc
class __$$DynamicTextImplCopyWithImpl<$Res>
    extends _$DynamicTextCopyWithImpl<$Res, _$DynamicTextImpl>
    implements _$$DynamicTextImplCopyWith<$Res> {
  __$$DynamicTextImplCopyWithImpl(
      _$DynamicTextImpl _value, $Res Function(_$DynamicTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? children = null,
    Object? style = freezed,
    Object? textAlign = freezed,
    Object? textDirection = freezed,
    Object? softWrap = freezed,
    Object? overflow = freezed,
    Object? textScaleFactor = freezed,
    Object? maxLines = freezed,
    Object? semanticsLabel = freezed,
    Object? textWidthBasis = freezed,
    Object? selectionColor = freezed,
  }) {
    return _then(_$DynamicTextImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<DynamicTextSpan>,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as DynamicTextStyle?,
      textAlign: freezed == textAlign
          ? _value.textAlign
          : textAlign // ignore: cast_nullable_to_non_nullable
              as TextAlign?,
      textDirection: freezed == textDirection
          ? _value.textDirection
          : textDirection // ignore: cast_nullable_to_non_nullable
              as TextDirection?,
      softWrap: freezed == softWrap
          ? _value.softWrap
          : softWrap // ignore: cast_nullable_to_non_nullable
              as bool?,
      overflow: freezed == overflow
          ? _value.overflow
          : overflow // ignore: cast_nullable_to_non_nullable
              as TextOverflow?,
      textScaleFactor: freezed == textScaleFactor
          ? _value.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLines: freezed == maxLines
          ? _value.maxLines
          : maxLines // ignore: cast_nullable_to_non_nullable
              as int?,
      semanticsLabel: freezed == semanticsLabel
          ? _value.semanticsLabel
          : semanticsLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      textWidthBasis: freezed == textWidthBasis
          ? _value.textWidthBasis
          : textWidthBasis // ignore: cast_nullable_to_non_nullable
              as TextWidthBasis?,
      selectionColor: freezed == selectionColor
          ? _value.selectionColor
          : selectionColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicTextImpl implements _DynamicText {
  const _$DynamicTextImpl(
      {required this.data,
      final List<DynamicTextSpan> children = const [],
      this.style,
      this.textAlign,
      this.textDirection,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.selectionColor})
      : _children = children;

  factory _$DynamicTextImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicTextImplFromJson(json);

  @override
  final String data;
  final List<DynamicTextSpan> _children;
  @override
  @JsonKey()
  List<DynamicTextSpan> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  final DynamicTextStyle? style;
  @override
  final TextAlign? textAlign;
  @override
  final TextDirection? textDirection;
  @override
  final bool? softWrap;
  @override
  final TextOverflow? overflow;
  @override
  final double? textScaleFactor;
  @override
  final int? maxLines;
  @override
  final String? semanticsLabel;
  @override
  final TextWidthBasis? textWidthBasis;
  @override
  final String? selectionColor;

  @override
  String toString() {
    return 'DynamicText(data: $data, children: $children, style: $style, textAlign: $textAlign, textDirection: $textDirection, softWrap: $softWrap, overflow: $overflow, textScaleFactor: $textScaleFactor, maxLines: $maxLines, semanticsLabel: $semanticsLabel, textWidthBasis: $textWidthBasis, selectionColor: $selectionColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicTextImpl &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.textAlign, textAlign) ||
                other.textAlign == textAlign) &&
            (identical(other.textDirection, textDirection) ||
                other.textDirection == textDirection) &&
            (identical(other.softWrap, softWrap) ||
                other.softWrap == softWrap) &&
            (identical(other.overflow, overflow) ||
                other.overflow == overflow) &&
            (identical(other.textScaleFactor, textScaleFactor) ||
                other.textScaleFactor == textScaleFactor) &&
            (identical(other.maxLines, maxLines) ||
                other.maxLines == maxLines) &&
            (identical(other.semanticsLabel, semanticsLabel) ||
                other.semanticsLabel == semanticsLabel) &&
            (identical(other.textWidthBasis, textWidthBasis) ||
                other.textWidthBasis == textWidthBasis) &&
            (identical(other.selectionColor, selectionColor) ||
                other.selectionColor == selectionColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      data,
      const DeepCollectionEquality().hash(_children),
      style,
      textAlign,
      textDirection,
      softWrap,
      overflow,
      textScaleFactor,
      maxLines,
      semanticsLabel,
      textWidthBasis,
      selectionColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicTextImplCopyWith<_$DynamicTextImpl> get copyWith =>
      __$$DynamicTextImplCopyWithImpl<_$DynamicTextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicTextImplToJson(
      this,
    );
  }
}

abstract class _DynamicText implements DynamicText {
  const factory _DynamicText(
      {required final String data,
      final List<DynamicTextSpan> children,
      final DynamicTextStyle? style,
      final TextAlign? textAlign,
      final TextDirection? textDirection,
      final bool? softWrap,
      final TextOverflow? overflow,
      final double? textScaleFactor,
      final int? maxLines,
      final String? semanticsLabel,
      final TextWidthBasis? textWidthBasis,
      final String? selectionColor}) = _$DynamicTextImpl;

  factory _DynamicText.fromJson(Map<String, dynamic> json) =
      _$DynamicTextImpl.fromJson;

  @override
  String get data;
  @override
  List<DynamicTextSpan> get children;
  @override
  DynamicTextStyle? get style;
  @override
  TextAlign? get textAlign;
  @override
  TextDirection? get textDirection;
  @override
  bool? get softWrap;
  @override
  TextOverflow? get overflow;
  @override
  double? get textScaleFactor;
  @override
  int? get maxLines;
  @override
  String? get semanticsLabel;
  @override
  TextWidthBasis? get textWidthBasis;
  @override
  String? get selectionColor;
  @override
  @JsonKey(ignore: true)
  _$$DynamicTextImplCopyWith<_$DynamicTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DynamicTextSpan _$DynamicTextSpanFromJson(Map<String, dynamic> json) {
  return _DynamicTextSpan.fromJson(json);
}

/// @nodoc
mixin _$DynamicTextSpan {
  String? get data => throw _privateConstructorUsedError;
  DynamicTextStyle? get style => throw _privateConstructorUsedError;
  Map<String, dynamic>? get onTap => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicTextSpanCopyWith<DynamicTextSpan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicTextSpanCopyWith<$Res> {
  factory $DynamicTextSpanCopyWith(
          DynamicTextSpan value, $Res Function(DynamicTextSpan) then) =
      _$DynamicTextSpanCopyWithImpl<$Res, DynamicTextSpan>;
  @useResult
  $Res call(
      {String? data, DynamicTextStyle? style, Map<String, dynamic>? onTap});

  $DynamicTextStyleCopyWith<$Res>? get style;
}

/// @nodoc
class _$DynamicTextSpanCopyWithImpl<$Res, $Val extends DynamicTextSpan>
    implements $DynamicTextSpanCopyWith<$Res> {
  _$DynamicTextSpanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? style = freezed,
    Object? onTap = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as DynamicTextStyle?,
      onTap: freezed == onTap
          ? _value.onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DynamicTextStyleCopyWith<$Res>? get style {
    if (_value.style == null) {
      return null;
    }

    return $DynamicTextStyleCopyWith<$Res>(_value.style!, (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicTextSpanImplCopyWith<$Res>
    implements $DynamicTextSpanCopyWith<$Res> {
  factory _$$DynamicTextSpanImplCopyWith(_$DynamicTextSpanImpl value,
          $Res Function(_$DynamicTextSpanImpl) then) =
      __$$DynamicTextSpanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? data, DynamicTextStyle? style, Map<String, dynamic>? onTap});

  @override
  $DynamicTextStyleCopyWith<$Res>? get style;
}

/// @nodoc
class __$$DynamicTextSpanImplCopyWithImpl<$Res>
    extends _$DynamicTextSpanCopyWithImpl<$Res, _$DynamicTextSpanImpl>
    implements _$$DynamicTextSpanImplCopyWith<$Res> {
  __$$DynamicTextSpanImplCopyWithImpl(
      _$DynamicTextSpanImpl _value, $Res Function(_$DynamicTextSpanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? style = freezed,
    Object? onTap = freezed,
  }) {
    return _then(_$DynamicTextSpanImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as DynamicTextStyle?,
      onTap: freezed == onTap
          ? _value._onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicTextSpanImpl implements _DynamicTextSpan {
  const _$DynamicTextSpanImpl(
      {this.data, this.style, final Map<String, dynamic>? onTap})
      : _onTap = onTap;

  factory _$DynamicTextSpanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicTextSpanImplFromJson(json);

  @override
  final String? data;
  @override
  final DynamicTextStyle? style;
  final Map<String, dynamic>? _onTap;
  @override
  Map<String, dynamic>? get onTap {
    final value = _onTap;
    if (value == null) return null;
    if (_onTap is EqualUnmodifiableMapView) return _onTap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DynamicTextSpan(data: $data, style: $style, onTap: $onTap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicTextSpanImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.style, style) || other.style == style) &&
            const DeepCollectionEquality().equals(other._onTap, _onTap));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, data, style, const DeepCollectionEquality().hash(_onTap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicTextSpanImplCopyWith<_$DynamicTextSpanImpl> get copyWith =>
      __$$DynamicTextSpanImplCopyWithImpl<_$DynamicTextSpanImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicTextSpanImplToJson(
      this,
    );
  }
}

abstract class _DynamicTextSpan implements DynamicTextSpan {
  const factory _DynamicTextSpan(
      {final String? data,
      final DynamicTextStyle? style,
      final Map<String, dynamic>? onTap}) = _$DynamicTextSpanImpl;

  factory _DynamicTextSpan.fromJson(Map<String, dynamic> json) =
      _$DynamicTextSpanImpl.fromJson;

  @override
  String? get data;
  @override
  DynamicTextStyle? get style;
  @override
  Map<String, dynamic>? get onTap;
  @override
  @JsonKey(ignore: true)
  _$$DynamicTextSpanImplCopyWith<_$DynamicTextSpanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
