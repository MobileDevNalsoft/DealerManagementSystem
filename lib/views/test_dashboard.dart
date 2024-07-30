import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/dashboard.dart';
import 'package:dms/views/sample/service_main.dart';
import 'package:dms/views/service_history.dart';
import 'package:dms/views/service_main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DribbleUI extends StatefulWidget {
  const DribbleUI({super.key});

  @override
  State<DribbleUI> createState() => _DribbleUIState();
}

class _DribbleUIState extends State<DribbleUI> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black45, Colors.black26, Colors.black45],
                stops: [0.1, 0.5, 1])),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(size.height * 0.18),
                Image.asset(
                  'assets/images/dashboard_car.png',
                  height: 200,
                  width: 200,
                ),
                Gap(size.height * 0.3),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ServiceMain()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.15,
                    height: size.height * 0.08,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black45,
                            Colors.black87,
                            Colors.black
                          ],
                          stops: [
                            0.05,
                            0.5,
                            1
                          ]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black87,
                          blurRadius: 30,
                          offset: Offset(1, 10),
                        ),
                        BoxShadow(
                          color: Colors.orange.shade100,
                          blurRadius: 30,
                          offset: const Offset(-1, -10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.orange.shade200,
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: -size.height * 0.4,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddVehicleView()));
                    },
                    child: ClippedButton(
                      size: Size(size.width * 0.2, size.height * 0.2),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black45,
                              Colors.black87,
                              Colors.black
                            ],
                            stops: [
                              0.05,
                              0.5,
                              1
                            ]),
                      ),
                      shadow: BoxShadow(
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 25,
                          color: Colors.orange.shade200,
                          offset: Offset(0, 0)),
                      clipper: ButtonClipper(),
                      child: Image.asset(
                        'assets/images/add_vehicle_icon.png',
                        color: Colors.orange.shade200,
                        opacity: AnimationController(
                          vsync: this,
                          value: 0.7,
                        ),
                        alignment: Alignment.center,
                        height: size.height * 0.1,
                        width: size.width * 0.1,
                      ),
                    ),
                  ),
                  Transform.flip(
                    flipX: true,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ServiceMainSample()));
                      },
                      child: ClippedButton(
                        size: Size(size.width * 0.2, size.height * 0.2),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.black45,
                                Colors.black87,
                                Colors.black
                              ],
                              stops: [
                                0.05,
                                0.5,
                                1
                              ]),
                        ),
                        shadow: BoxShadow(
                            blurRadius: 20,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 25,
                            color: Colors.orange.shade200,
                            offset: Offset(0, 0)),
                        clipper: ButtonClipper(),
                        child: Image.asset(
                          'assets/images/person_icon.png',
                          color: Colors.orange.shade200,
                          opacity: AnimationController(
                            vsync: this,
                            value: 0.7,
                          ),
                          alignment: Alignment.center,
                          height: size.height * 0.07,
                          width: size.width * 0.07,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.01,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClippedButton(
                    size: Size(size.width * 0.23, size.height * 0.2),
                    decoration: const BoxDecoration(color: Colors.black),
                    shadow: BoxShadow(
                        blurRadius: 20,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 25,
                        color: Colors.orange.shade200,
                        offset: Offset(0, 0)),
                    clipper: ButtonClipperMid(),
                    child: Image.asset(
                      'assets/images/vehicle_search_icon.png',
                      color: Colors.orange.shade200,
                      opacity: AnimationController(
                        vsync: this,
                        value: 0.7,
                      ),
                      alignment: Alignment.center,
                      height: size.height * 0.095,
                      width: size.width * 0.095,
                    ),
                  ),
                  Transform.flip(
                      flipX: true,
                      child: ClippedButton(
                        size: Size(size.width * 0.23, size.height * 0.2),
                        decoration: const BoxDecoration(color: Colors.black),
                        shadow: BoxShadow(
                            blurRadius: 20,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 25,
                            color: Colors.orange.shade200,
                            offset: Offset(0, 0)),
                        clipper: ButtonClipperMid(),
                        child: Image.asset(
                          'assets/images/home_icon.png',
                          color: Colors.orange.shade200,
                          opacity: AnimationController(
                            vsync: this,
                            value: 0.7,
                          ),
                          alignment: Alignment.center,
                          height: size.height * 0.08,
                          width: size.width * 0.08,
                        ),
                      )),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.423,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.flip(
                      flipY: true,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DashboardView()));
                        },
                        child: ClippedButton(
                          size: Size(size.width * 0.2, size.height * 0.2),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black45,
                                  Colors.black87,
                                  Colors.black
                                ],
                                stops: [
                                  0.05,
                                  0.5,
                                  1
                                ]),
                          ),
                          shadow: BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 25,
                              color: Colors.orange.shade200,
                              offset: Offset(0, 0)),
                          clipper: ButtonClipper(),
                          child: Transform.flip(
                            flipY: true,
                            child: Image.asset(
                              'assets/images/job_cards_icon.png',
                              color: Colors.orange.shade200,
                              opacity: AnimationController(
                                vsync: this,
                                value: 0.7,
                              ),
                              alignment: Alignment.center,
                              height: size.height * 0.085,
                              width: size.width * 0.085,
                            ),
                          ),
                        ),
                      )),
                  Transform.flip(
                    flipY: true,
                    child: Transform.flip(
                        flipX: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ServiceHistoryView()));
                          },
                          child: ClippedButton(
                              size: Size(size.width * 0.2, size.height * 0.2),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.black45,
                                      Colors.black87,
                                      Colors.black
                                    ],
                                    stops: [
                                      0.05,
                                      0.5,
                                      1
                                    ]),
                              ),
                              shadow: BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 25,
                                  color: Colors.orange.shade200,
                                  offset: Offset(0, 0)),
                              clipper: ButtonClipper(),
                              child: Transform.flip(
                                flipY: true,
                                child: Image.asset(
                                  'assets/images/history_icon.png',
                                  color: Colors.orange.shade200,
                                  opacity: AnimationController(
                                    vsync: this,
                                    value: 0.7,
                                  ),
                                  alignment: Alignment.center,
                                  height: size.height * 0.08,
                                  width: size.width * 0.08,
                                ),
                              )),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('height ${size.height} width ${size.width}');
    Path path = Path();
    path.lineTo(size.width - 33.5, 20);
    path.quadraticBezierTo(size.width - 18, 28, size.width - 13.4, 40.2);
    path.lineTo(size.width - 5, size.height - 70);
    path.quadraticBezierTo(size.width + 3.35, size.height - 30.15,
        size.width - 20.1, size.height - 20.1);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

class ButtonClipperMid extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('height ${size.height} width ${size.width}');
    Path path = Path();
    path.lineTo(0, 25);
    path.lineTo(size.width - 40, 5);
    path.quadraticBezierTo(size.width - 10, -5, size.width - 5, 20);
    path.cubicTo(size.width, size.height * 0.4, size.width, size.height * 0.6,
        size.width - 5, size.height - 20);
    path.quadraticBezierTo(
        size.width - 10, size.height + 5, size.width - 40, size.height - 5);
    path.lineTo(0, size.height - 25);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}
