import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliderButton extends StatefulWidget {
  final double height;
  final double width;
  final SliderButtonController? controller;
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
      this.controller,
      this.decoration = const BoxDecoration(),
      required this.onLeftLabelReached,
      required this.onRightLabelReached,
      required this.onNoStatus,
      required this.leftLabel,
      required this.rightLabel,
      required this.icon})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;

  late SliderButtonController _sliderButtonController;
  @override
  void initState() {
    super.initState();
    _initController();

    _leftPosition = widget.width * 0.35;
    _startPosition = widget.width * 0.735;
    _rightPosition = widget.width * 1.12;

    if (_sliderButtonController.position == Position.middle) {
      _sliderButtonController.setCurrentPosition = _startPosition;
    } else if (_sliderButtonController.position == Position.right) {
      _sliderButtonController.setCurrentPosition = _rightPosition;
    } else if (_sliderButtonController.position == Position.left) {
      _sliderButtonController.setCurrentPosition = _leftPosition;
    }
  }

  void _initController() {
    _sliderButtonController = widget.controller ?? SliderButtonController();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _sliderButtonController.setCurrentPosition = details.localPosition.dx;
      if (_sliderButtonController.currentPosition >= _rightPosition * 0.9) {
        _sliderButtonController.setPosition = Position.right;
        _sliderButtonController.setCurrentPosition = _rightPosition;
      } else if (_sliderButtonController.currentPosition <=
          _leftPosition * 1.3) {
        _sliderButtonController.setPosition = Position.left;
        _sliderButtonController.setCurrentPosition = _leftPosition;
      } else {
        _sliderButtonController.setPosition = Position.moving;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (_sliderButtonController.currentPosition == _rightPosition) {
        widget.onRightLabelReached();
        return;
      } else if (_sliderButtonController.currentPosition == _leftPosition) {
        widget.onLeftLabelReached();
        return;
      } else {
        _sliderButtonController.setCurrentPosition = _startPosition;
        _sliderButtonController.setPosition = Position.middle;
        widget.onNoStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_sliderButtonController.position != Position.moving) {
      if (_sliderButtonController.position == Position.middle) {
        _sliderButtonController.setCurrentPosition = _startPosition;
      } else if (_sliderButtonController.position == Position.right) {
        _sliderButtonController.setCurrentPosition = _rightPosition;
      } else if (_sliderButtonController.position == Position.left) {
        _sliderButtonController.setCurrentPosition = _leftPosition;
      }
    }

    return GestureDetector(
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
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
                          child: _sliderButtonController.currentPosition !=
                                  _leftPosition
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
                          child: _sliderButtonController.currentPosition !=
                                  _rightPosition
                              ? widget.rightLabel
                              : SizedBox()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: _sliderButtonController.currentPosition,
            top: widget.height * 0.055,
            child: Container(
              width: widget.width * 0.2,
              height: widget.height * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: (_sliderButtonController.currentPosition ==
                          _rightPosition)
                      ? Lottie.asset("assets/lottie/success.json",
                          repeat: false)
                      : (_sliderButtonController.currentPosition ==
                              _leftPosition)
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

class SliderButtonController extends ChangeNotifier {
  Position position;
  double currentPosition;

  SliderButtonController(
      {this.position = Position.middle, this.currentPosition = 0});

  set setPosition(newPosition) {
    position = newPosition;
    notifyListeners();
  }

  set setCurrentPosition(newCurrentPosition) {
    currentPosition = newCurrentPosition;
    notifyListeners();
  }
}

enum Position { left, middle, right, moving }
