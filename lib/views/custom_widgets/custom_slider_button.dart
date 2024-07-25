import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliderButton extends StatefulWidget {
  final double height;
  final double width;
  final Position position;
  final Decoration decoration;
  final Widget leftLabel;
  final void Function() onLeftLabelReached;
  final void Function() onRightLabelReached;
  final void Function() onNoStatus;
  final Widget rightLabel;
  final Widget icon;
  CustomSliderButton(
      {Key? key,
      this.height = 45,
      this.width = 100,
      this.decoration = const BoxDecoration(),
      required this.onLeftLabelReached,
      required this.onRightLabelReached,
      required this.onNoStatus,
      this.position = Position.middle,
      required this.leftLabel,
      required this.rightLabel,
      required this.icon})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _position;
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;
  @override
  void initState() {
    super.initState();
    print('in init state');

    _leftPosition = widget.width * 0.35;
    _startPosition = widget.width * 0.735;
    _rightPosition = widget.width * 1.12;

    if (widget.position == Position.middle) {
      print('in middle');
      _position = _startPosition;
    } else if (widget.position == Position.right) {
      _position = _rightPosition;
      print('in right');
    } else if (widget.position == Position.left) {
      _position = _leftPosition;
      print('in left');
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = details.localPosition.dx;
      if (_position >= _rightPosition * 0.9) {
        _position = _rightPosition;
      } else if (_position <= _leftPosition * 1.3) {
        _position = _leftPosition;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (_position == _rightPosition) {
        widget.onRightLabelReached();
        return;
      } else if (_position == _leftPosition) {
        widget.onLeftLabelReached();
        return;
      } else {
        _position = _startPosition;
        widget.onNoStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      onHorizontalDragCancel: () {
        setState(() {
          _position = _startPosition;
        });
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: widget.decoration,
              width: widget.width,
              height: widget.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          baseColor: Colors.red,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: _position != _leftPosition
                              ? widget.leftLabel
                              : SizedBox()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Shimmer.fromColors(
                          baseColor: Colors.green,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: _position != _rightPosition
                              ? widget.rightLabel
                              : SizedBox()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: _position,
            top: widget.height * 0.39,
            child: Container(
              width: widget.width * 0.2,
              height: widget.height * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: (_position == _rightPosition)
                      ? Lottie.asset("assets/lottie/success.json",
                          repeat: false)
                      : (_position == _leftPosition)
                          ? Lottie.asset("assets/lottie/error2.json",
                              repeat: false)
                          : widget.icon),
            ),
          ),
        ],
      ),
    );
  }
}

enum Position { left, middle, right }
