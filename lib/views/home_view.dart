import 'dart:io';
import 'dart:ui';

import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:dms/views/my_jobcards.dart';
import 'package:dms/views/sample/service_main.dart';
import 'package:dms/views/service_history.dart';
import 'package:dms/views/vehicle_info.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:gap/gap.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';
import 'dashboard.dart';
import 'service_booking.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, ConnectivityMixin {
  late O3DController o3dController;

  void initState() {
    // TODO: implement initState
    super.initState();
    o3dController = O3DController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    NavigatorService navigator = getIt<NavigatorService>();

    double? start;
    double end;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showConfirmationDialog(size: size, navigator: navigator);
      },
      child: GestureDetector(
        onVerticalDragStart: (details) {
          print(details.localPosition.dy);
          start = details.localPosition.dy;
        },
        onVerticalDragEnd: (details) {
          print(details.localPosition.dy);
          end = details.localPosition.dy;
          if (start! > end) {
            navigator.push('/serviceBooking');
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                  children: [
                    Gap(size.height * 0.18),
                    SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.48,
                        child: O3D.asset(
                          src: 'assets/images/cyberpunk_car.glb',
                          autoPlay: false,
                          autoRotate: false,
                          cameraControls: true,
                          autoRotateDelay: 0,
                          controller: o3dController,
                        )),
                    // Image.asset(
                    //   'assets/images/dashboard_car.png',
                    //   height: 200,
                    //   width: 200,
                    // ),
                    Gap(size.height * 0.3),
                    InkWell(
                      onTap: () {
                        if (isConnected()) {
                          o3dController.autoRotate = false;
                          navigator.push('/serviceBooking');
                        } else {
                          DMSCustomWidgets.DMSFlushbar(size, context,
                              message: 'Looks like you'
                                  're offline. Please check your connection and try again.',
                              icon: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ));
                        }
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
                          color: Colors.white,
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
                          if (isConnected()) {
                            navigator.push('/addVehicle');
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message: 'Looks like you'
                                    're offline. Please check your connection and try again.',
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ));
                          }
                        },
                        child: Hero(
                          tag: 'addVehicle',
                          transitionOnUserGestures: true,
                          child: ClippedButton(
                            size: Size(
                                isMobile ? size.width * 0.2 : size.width * 0.08,
                                size.height * 0.2),
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
                                offset: const Offset(0, 0)),
                            clipper: ButtonClipper(),
                            child: Image.asset(
                              'assets/images/add_vehicle_icon.png',
                              color: Colors.white,
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
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isConnected()) {
                            navigator.push('/myJobCards');
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message: 'Looks like you'
                                    're offline. Please check your connection and try again.',
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ));
                          }
                        },
                        onDoubleTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ServiceMainSample()));
                        },
                        child: Hero(
                          tag: 'myJobCards',
                          transitionOnUserGestures: true,
                          child: Transform.flip(
                            flipX: true,
                            child: ClippedButton(
                              size: Size(
                                  isMobile
                                      ? size.width * 0.2
                                      : size.width * 0.08,
                                  size.height * 0.2),
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
                                  offset: const Offset(0, 0)),
                              clipper: ButtonClipper(),
                              child: Image.asset(
                                'assets/images/person_icon.png',
                                color: Colors.white,
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
                      GestureDetector(
                        onTap: () {
                          if (isConnected()) {
                            navigator.push('/vehicleInfo');
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message: 'Looks like you'
                                    're offline. Please check your connection and try again.',
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ));
                          }
                        },
                        child: Hero(
                          tag: 'vehicleInfo',
                          transitionOnUserGestures: true,
                          child: ClippedButton(
                            size: Size(
                                isMobile ? size.width * 0.2 : size.width * 0.08,
                                size.height * 0.2),
                            decoration:
                                const BoxDecoration(color: Colors.black),
                            shadow: BoxShadow(
                                blurRadius: 20,
                                blurStyle: BlurStyle.outer,
                                spreadRadius: 25,
                                color: Colors.orange.shade200,
                                offset: const Offset(0, 0)),
                            clipper: ButtonClipperMid(),
                            child: Image.asset(
                              'assets/images/vehicle_search_icon.png',
                              color: Colors.white,
                              opacity: AnimationController(
                                vsync: this,
                                value: 0.7,
                              ),
                              alignment: Alignment.center,
                              height: size.height * 0.095,
                              width: size.width * 0.095,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigator.push('/dashboard');
                        },
                        child: Hero(
                          tag: 'dashboard',
                          transitionOnUserGestures: true,
                          child: Transform.flip(
                            flipX: true,
                            child: ClippedButton(
                              size: Size(
                                  isMobile
                                      ? size.width * 0.2
                                      : size.width * 0.08,
                                  size.height * 0.2),
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              shadow: BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 25,
                                  color: Colors.orange.shade200,
                                  offset: const Offset(0, 0)),
                              clipper: ButtonClipperMid(),
                              child: Image.asset(
                                'assets/images/home_icon.png',
                                color: Colors.white,
                                opacity: AnimationController(
                                  vsync: this,
                                  value: 0.7,
                                ),
                                alignment: Alignment.center,
                                height: size.height * 0.08,
                                width: size.width * 0.08,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                      GestureDetector(
                        onTap: () {
                          if (isConnected()) {
                            navigator.push('/listOfJobCards');
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message: 'Looks like you'
                                    're offline. Please check your connection and try again.',
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ));
                          }
                        },
                        child: Hero(
                          tag: 'listOfJobCards',
                          transitionOnUserGestures: true,
                          child: Transform.flip(
                            flipY: true,
                            child: ClippedButton(
                              size: Size(
                                  isMobile
                                      ? size.width * 0.2
                                      : size.width * 0.08,
                                  size.height * 0.2),
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
                                  offset: const Offset(0, 0)),
                              clipper: ButtonClipper(),
                              child: Transform.flip(
                                flipY: true,
                                child: Image.asset(
                                  'assets/images/job_cards_icon.png',
                                  color: Colors.white,
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
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isConnected()) {
                            navigator.push('/serviceHistory');
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message: 'Looks like you'
                                    're offline. Please check your connection and try again.',
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ));
                          }
                        },
                        child: Hero(
                          tag: 'serviceHistory',
                          transitionOnUserGestures: true,
                          child: Transform.flip(
                            flipY: true,
                            child: Transform.flip(
                              flipX: true,
                              child: ClippedButton(
                                  size: Size(
                                      isMobile
                                          ? size.width * 0.2
                                          : size.width * 0.08,
                                      size.height * 0.2),
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
                                      offset: const Offset(0, 0)),
                                  clipper: ButtonClipper(),
                                  child: Transform.flip(
                                    flipY: true,
                                    child: Image.asset(
                                      'assets/images/history_icon.png',
                                      color: Colors.white,
                                      opacity: AnimationController(
                                        vsync: this,
                                        value: 0.7,
                                      ),
                                      alignment: Alignment.center,
                                      height: size.height * 0.08,
                                      width: size.width * 0.08,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
      {required Size size, required NavigatorService navigator}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(top: size.height * 0.01),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: const Text(
                      'Are you sure you want to exit the app ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(size.height * 0.01),
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              navigator.pop();
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'no',
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              exit(0);
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'yes',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero);
        });
  }
}

//not used
class CustomRectTween extends RectTween {
  CustomRectTween(Rect begin, Rect end) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    // Custom logic to calculate the Rect based on the animation progress t
    // For example, you could create a custom path for the Hero to follow
    // by manipulating the rect's topLeft and bottomRight properties
    return Rect.fromLTWH(
      lerpDouble(begin!.left, end!.left, t)!,
      lerpDouble(begin!.top, end!.top, t)!,
      lerpDouble(begin!.width, end!.width, t)!,
      lerpDouble(begin!.height, end!.height, t)!,
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
