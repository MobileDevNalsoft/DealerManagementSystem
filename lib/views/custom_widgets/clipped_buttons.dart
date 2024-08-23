import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/multi/multi_bloc.dart';

// ignore: must_be_immutable
class ClippedButton extends StatefulWidget {
  ClippedButton(
      {super.key,
      required this.clipper,
      required this.image,
      required this.imageHeight,
      required this.imageWidth,
      this.flipButtonX = false,
      this.flipButtonY = false,
      this.flipButtonYY = false,
      this.flipImageY = false,
      this.shadow});
  CustomClipper<Path> clipper;
  Shadow? shadow;
  String image;
  double imageHeight;
  double imageWidth;
  bool flipButtonX;
  bool flipButtonY;
  bool flipButtonYY;
  bool flipImageY;

  @override
  State<ClippedButton> createState() => _ClippedButtonState();
}

class _ClippedButtonState extends State<ClippedButton> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;
    return Transform.flip(
      flipY: widget.flipButtonYY,
      child: Transform.flip(
        flipX: widget.flipButtonX,
        flipY: widget.flipButtonY,
        child: ClipShadowPath(
          shadow: widget.shadow ??
              BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
          clipper: widget.clipper,
          child: Container(
            alignment: Alignment.center,
            color: Colors.black,
            height: size.height * 0.2,
            width: isMobile ? size.width * 0.2 : size.width * 0.08,
            child: Transform.flip(
              flipY: widget.flipImageY,
              child: Image.asset(
                'assets/images/${widget.image}',
                color: Colors.white,
                opacity: AnimationController(
                  vsync: this,
                  value: 0.7,
                ),
                alignment: Alignment.center,
                height: widget.imageHeight,
                width: widget.imageWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleInfoClippedButton extends StatelessWidget {
  bool flipX;
  Widget child;
  Color? decorationColor;
  Color shadowColor;
  VehicleInfoClippedButton({this.flipX = false, this.decorationColor, required this.child, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return Transform.flip(
      flipX: flipX,
      child: ClipShadowPath(
        shadow: Shadow(offset: const Offset(0, 0), color: shadowColor),
        clipper: VehicleInfoClipper(),
        child: Container(
          height: size.height * (isMobile ? 0.5 : 0.58),
          width: size.width * (isMobile ? 0.95 : 0.4),
          decoration: BoxDecoration(color: !context.watch<MultiBloc>().state.reverseClippedWidgets! ? decorationColor : null),
          child: child,
        ),
      ),
    );
  }
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class VehicleInfoClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    print(size.height);
    double x1 = 0;
    double y1 = 30;
    double x = size.width;
    double y = size.height;

    Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x1, y - 20);
    path.arcToPoint(Offset(x1 + 20, y), radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x - 20, y);
    path.arcToPoint(Offset(x, y - 20), radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x, y1 + 80);
    path.arcToPoint(Offset(x - 20, y1 + 60), radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x - (size.width * 0.45), y1 + 60);
    path.arcToPoint(Offset(x - (size.width * 0.45 + 20), y1 + 40), radius: const Radius.circular(20), clockwise: true);
    path.lineTo(x - (size.width * 0.45 + 20), y1 + 20);
    path.arcToPoint(Offset(x - (size.width * 0.45 + 40), y1), radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x1 + 20, y1);
    path.arcToPoint(Offset(x1, y1 + 20), radius: const Radius.circular(20), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
