import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliderButton extends StatefulWidget {
  final double height;
  final double width;

  /// controller for managing the slider button's state
  /// (position and callbacks).
  final SliderButtonController? controller;
  final Decoration? decoration;
  bool isMobile;
  final Widget leftLabel;
  final void Function() onLeftLabelReached;
  final void Function() onRightLabelReached;
  final void Function() onNoStatus;
  final Widget rightLabel;
  CustomSliderButton(
      {super.key,
      this.height = 45,
      this.width = 190,
      this.isMobile = true,
      this.controller,
      this.decoration,
      required this.onLeftLabelReached,
      required this.onRightLabelReached,
      required this.onNoStatus,
      required this.leftLabel,
      required this.rightLabel});

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  /// Internal state variables to track slider positions.
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;

  /// The controller instance, either provided or created internally.
  late SliderButtonController _sliderButtonController;
  @override
  void initState() {
    super.initState();
    _initController();
  }

  /// Initializes the `_sliderButtonController` based on the provided
  /// controller or creates a new one.
  void _initController() {
    _sliderButtonController = widget.controller ?? SliderButtonController();
  }

  /// Handles horizontal drag updates on the slider button.
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _sliderButtonController.setCurrentPosition = details.localPosition.dx;
      if (_sliderButtonController.currentPosition >= _rightPosition * 0.85) {
        _sliderButtonController.setPosition = Position.right;
        _sliderButtonController.setCurrentPosition = _rightPosition;
      } else if (_sliderButtonController.currentPosition <= _leftPosition * 7) {
        _sliderButtonController.setPosition = Position.left;
        _sliderButtonController.setCurrentPosition = _leftPosition;
      } else {
        _sliderButtonController.setPosition = Position.moving;
      }
    });
  }

  /// Handles horizontal drag end events on the slider button.
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (_sliderButtonController.currentPosition == _rightPosition) {
        widget.onRightLabelReached();
      } else if (_sliderButtonController.currentPosition == _leftPosition) {
        widget.onLeftLabelReached();
      } else {
        _sliderButtonController.setCurrentPosition = _startPosition;
        _sliderButtonController.setPosition = Position.middle;
        widget.onNoStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// This widget creates a draggable slider with visual feedback using a
    /// [GestureDetector] and a [Stack] of UI elements.
    ///
    /// The widget listens for horizontal drag events and updates the position of
    /// a slider button based on the user's finger movement.  It also displays
    /// visual feedback based on the slider button's position.

    /// Calculate initial positions based on widget properties.
    _leftPosition = widget.width * 0.02;
    _startPosition = widget.width * 0.395;
    _rightPosition = widget.width * 0.78;

    if (_sliderButtonController.position == Position.middle) {
      _sliderButtonController.setCurrentPosition = _startPosition;
    } else if (_sliderButtonController.position == Position.right) {
      _sliderButtonController.setCurrentPosition = _rightPosition;
    } else if (_sliderButtonController.position == Position.left) {
      _sliderButtonController.setCurrentPosition = _leftPosition;
    }

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
      onHorizontalDragStart: (details) {
        _sliderButtonController.position = Position.moving;
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.width, maxHeight: widget.height),
        child: Stack(
          children: [
            Align(
              child: Container(
                decoration: widget.decoration ??
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.height),
                        color: const Color.fromRGBO(36, 38, 40, 1),
                        boxShadow: [BoxShadow(color: Colors.orange.shade200, blurRadius: 3, spreadRadius: 0.3)]),
                width: widget.width,
                height: widget.height * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: widget.width * 0.06),
                        child: Shimmer.fromColors(
                            // This defines the shimmer animation for the left label.
                            direction: ShimmerDirection.rtl,
                            baseColor: Colors.red,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: _sliderButtonController.currentPosition != _leftPosition ? widget.leftLabel : const SizedBox()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: widget.width * 0.06),
                        // This defines the shimmer animation for the right label.
                        child: Shimmer.fromColors(
                            baseColor: Colors.green,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: _sliderButtonController.currentPosition != _rightPosition ? widget.rightLabel : const SizedBox()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: _sliderButtonController.currentPosition,
              top: widget.height * 0.1,
              child: Container(
                width: widget.width * 0.2,
                height: widget.height * 0.8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(36, 38, 40, 1),
                    boxShadow: [BoxShadow(color: Colors.orange.shade200, blurRadius: 3, spreadRadius: 0.5)]),
                child: Center(
                    child: (_sliderButtonController.currentPosition == _rightPosition)
                        ? Lottie.asset("assets/lottie/success.json", repeat: false)
                        : (_sliderButtonController.currentPosition == _leftPosition)
                            ? Lottie.asset("assets/lottie/error2.json", repeat: false)
                            : const Icon(
                                Icons.switch_left_rounded,
                                color: Colors.white,
                              )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// controller that is used to controll the position of slider button.
class SliderButtonController extends ChangeNotifier {
  Position position;
  double currentPosition;

  SliderButtonController({this.position = Position.middle, this.currentPosition = 0});

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
