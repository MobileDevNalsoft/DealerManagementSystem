import 'package:flutter/material.dart';

class ClippedButton extends StatelessWidget {
  ClippedButton(
      {super.key,
      this.shadow,
      required this.clipper,
      required this.size,
      this.child,
      this.decoration});

  Shadow? shadow;
  CustomClipper<Path> clipper;
  Size size;
  Widget? child;
  Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      shadow: shadow ?? const Shadow(),
      clipper: clipper,
      child: Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        decoration: decoration,
        child: child,
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
