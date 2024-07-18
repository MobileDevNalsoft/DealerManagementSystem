import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gap/gap.dart';

class DribbleUI extends StatefulWidget {
  const DribbleUI({super.key});

  @override
  State<DribbleUI> createState() => _DribbleUIState();
}

class _DribbleUIState extends State<DribbleUI> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black26, Colors.black12, Colors.black26],
                stops: [0.25, 0.5, 1])),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(size.height * 0.1),
                Text(
                  'DMS',
                  style: TextStyle(fontSize: 25),
                ),
                Gap(size.height * 0.15),
                Image.asset(
                  'assets/images/dashboard_car.png',
                  height: 300,
                  width: 300,
                )
              ],
            ),
            ClipPath(
              clipper: ButtonClipper(),
              child: Container(
                height: size.height * 0.2,
                width: size.width * 0.2,
                decoration: BoxDecoration(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('height ${size.height} width ${size.width}');
    Path path = Path();
    path.lineTo(size.width - 16, 0);
    path.arcTo(
        Rect.fromPoints(
            Offset(size.width - 16, 0), Offset(size.width - 16, 30)),
        0.5 * math.pi,
        1.5 * math.pi,
        true);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}
