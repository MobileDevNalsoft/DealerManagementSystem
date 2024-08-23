import 'dart:io';
import 'dart:ui';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/sample/service_main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin, ConnectivityMixin {
  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        DMSCustomWidgets.showDMSDialog(
            context: context,
            text: 'Are you sure you want to exit the app ?',
            acceptLable: 'yes',
            rejectLable: 'no',
            onAccept: () {
              exit(0);
            },
            onReject: () {
              navigator.pop();
            });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black45, Colors.black26, Colors.black45], stops: [0.1, 0.5, 1])),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                      if (isConnected()) {
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
                            colors: [Colors.black45, Colors.black87, Colors.black],
                            stops: [0.05, 0.5, 1]),
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
                      child: const Icon(
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
                          clipper: ButtonClipper(),
                          image: 'add_vehicle_icon.png',
                          imageHeight: size.height * 0.1,
                          imageWidth: size.width * 0.1,
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceMainSample()));
                      },
                      child: Hero(
                        tag: 'myJobCards',
                        transitionOnUserGestures: true,
                        child: ClippedButton(
                          flipButtonX: true,
                          clipper: ButtonClipper(),
                          image: 'person_icon.png',
                          imageHeight: size.height * 0.07,
                          imageWidth: size.width * 0.07,
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
                            clipper: ButtonClipperMid(), image: 'vehicle_search_icon.png', imageHeight: size.height * 0.095, imageWidth: size.width * 0.095),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigator.push('/dashboard');
                      },
                      child: Hero(
                        tag: 'dashboard',
                        transitionOnUserGestures: true,
                        child: ClippedButton(
                          flipButtonX: true,
                          clipper: ButtonClipperMid(),
                          image: 'home_icon.png',
                          imageHeight: size.height * 0.08,
                          imageWidth: size.width * 0.08,
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
                        child: ClippedButton(
                          flipButtonY: true,
                          flipImageY: true,
                          clipper: ButtonClipper(),
                          image: 'job_cards_icon.png',
                          imageHeight: size.height * 0.085,
                          imageWidth: size.width * 0.085,
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
                        child: ClippedButton(
                          flipButtonYY: true,
                          flipButtonX: true,
                          flipImageY: true,
                          clipper: ButtonClipper(),
                          image: 'history_icon.png',
                          imageHeight: size.height * 0.08,
                          imageWidth: size.width * 0.08,
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
    );
  }
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 33.5, 20);
    path.quadraticBezierTo(size.width - 18, 28, size.width - 13.4, 40.2);
    path.lineTo(size.width - 5, size.height - 70);
    path.quadraticBezierTo(size.width + 3.35, size.height - 30.15, size.width - 20.1, size.height - 20.1);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;
}

class ButtonClipperMid extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 25);
    path.lineTo(size.width - 40, 5);
    path.quadraticBezierTo(size.width - 10, -5, size.width - 5, 20);
    path.cubicTo(size.width, size.height * 0.4, size.width, size.height * 0.6, size.width - 5, size.height - 20);
    path.quadraticBezierTo(size.width - 10, size.height + 5, size.width - 40, size.height - 5);
    path.lineTo(0, size.height - 25);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;
}
