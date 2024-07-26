import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliderButton extends StatefulWidget {
  final Size size;
  final BuildContext context;
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget icon;
  final onDismissed;
  CustomSliderButton(
      {Key? key,
      required this.size,
      required this.context,
      required this.leftLabel,
      required this.rightLabel,
      required this.icon,
      required this.onDismissed})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _position;
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;
  late double _initialPosition;
  @override
  void initState() {
    super.initState();

    _leftPosition = widget.size.width * 0.057;
    _startPosition = widget.size.width * 0.29;
    _rightPosition = widget.size.width * 0.518;
    if (true) {
      _initialPosition = widget.size.width * 0.28;
    } else if (false) {
      _initialPosition = _rightPosition;
    } else if (false) {
      _initialPosition = _leftPosition;
    }
    _position = _initialPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = details.localPosition.dx;
      if (_position > _rightPosition) {
        _position = _rightPosition;
      } else if (_position < _leftPosition) {
        _position = _leftPosition;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    if (_position >= _rightPosition - 20) {
      setState(() {
        _position = _rightPosition;
      });
      return;
    } else if (_position <= _leftPosition + 20) {
      setState(() {
        _position = _leftPosition;
      });
      return;
    } else {
      setState(() {
        _position = _startPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Color.fromRGBO(233, 227, 227, 1),
                // gradient: LinearGradient(colors: [
                //   Color.fromARGB(255, 230, 119, 119),
                //   Color.fromARGB(255, 235, 233, 233),
                //   Color.fromARGB(255, 230, 119, 119)
                // ]),
              ),
              width: widget.size.width * 0.58,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          baseColor: Colors.black,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: widget.leftLabel),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: widget.rightLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: _position,
            top: 1.5,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: Stack(
                children: [
                  Center(
                      child: (_position == _rightPosition)
                          ? Lottie.asset("assets/lottie/success.json",
                              repeat: false)
                          : (_position == _leftPosition)
                              ? Lottie.asset("assets/lottie/error2.json",
                                  repeat: false)
                              : widget.icon),
                  if (context.watch<ServiceBloc>().state.serviceUploadStatus ==
                      ServiceUploadStatus.loading)
                    Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: widget.size.width * 0.008,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
