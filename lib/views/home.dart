import 'dart:io';

import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/sample/service_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, ConnectivityMixin {
  // Service to handle navigation within the app
  final NavigatorService navigator = getIt<NavigatorService>();

  // shared preferences
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Check if the screen is considered mobile based on shortest side
    bool isMobile = size.shortestSide < 500;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    sharedPreferences.setBool('isMobile', isMobile);

    return PopScope(
      // Disable default back button behavior
      canPop: false,
      onPopInvoked: (didPop) {
        // Show confirmation dialog when exiting the app
        DMSCustomWidgets.showDMSDialog(
            context: context,
            text: 'Are you sure you want to exit the app ?',
            acceptLable: 'yes',
            rejectLable: 'no',
            onAccept: () {
              exit(0);
            },
            onReject: () {
              // Go back one screen if user cancels exit
              navigator.pop();
            });
      },
      child: Scaffold(
        // Prevent keyboard from resizing content
        resizeToAvoidBottomInset: false,
        body: Container(
          // Fill the entire screen
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
                  Gap(size.height * (isMobile ? 0.1 : 0)),
                  Image.asset(
                    'assets/images/dashboard_car.png',
                    height: size.height * (isMobile ? 0.25 : 0.5),
                    width: size.width * (isMobile ? 0.6 : 0.5),
                  ),
                  Gap(size.height * (isMobile ? 0.45 : 0.3)),
                  InkWell(
                    onTap: () {
                      // Check internet connection
                      if (isConnected()) {
                        navigator.push('/serviceBooking');
                      } else {
                        // Show an error message if offline
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
                      width: size.width * (isMobile ? 0.15 : 0.1),
                      height: size.height * (isMobile ? 0.08 : 0.06),
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
                        size: size.height * 0.03,
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: -size.height * 0.4, // moves child widget to top
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // check the internet connection
                        if (isConnected()) {
                          navigator.push('/addVehicle');
                        } else {
                          // Show an error message if offline
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
                          // creates a custom button shape according to the path in the clipper
                          clipper: ButtonClipper(isMobile: isMobile),
                          image: 'add_vehicle_icon.png',
                          imageHeight: size.height * (isMobile ? 0.1 : 0.08),
                          imageWidth: size.width * (isMobile ? 0.1 : 0.08),
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
                        child: ClippedButton(
                          flipButtonX: true,
                          clipper: ButtonClipper(isMobile: isMobile),
                          image: 'person_icon.png',
                          imageHeight: size.height * (isMobile ? 0.07 : 0.05),
                          imageWidth: size.width * (isMobile ? 0.07 : 0.05),
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
                            clipper: ButtonClipperMid(isMobile: isMobile),
                            image: 'vehicle_search_icon.png',
                            imageHeight:
                                size.height * (isMobile ? 0.095 : 0.07),
                            imageWidth: size.width * (isMobile ? 0.095 : 0.07)),
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
                          clipper: ButtonClipperMid(isMobile: isMobile),
                          image: 'home_icon.png',
                          imageHeight: size.height * (isMobile ? 0.08 : 0.06),
                          imageWidth: size.width * (isMobile ? 0.08 : 0.06),
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
                          clipper: ButtonClipper(isMobile: isMobile),
                          image: 'job_cards_icon.png',
                          imageHeight: size.height * (isMobile ? 0.085 : 0.06),
                          imageWidth: size.width * (isMobile ? 0.085 : 0.06),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onDoubleTap: () {
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
                      onTap: () {
                        if (isConnected()) {
                          navigator.push('/serviceHistory1');
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
                          clipper: ButtonClipper(isMobile: isMobile),
                          image: 'history_icon.png',
                          imageHeight: size.height * (isMobile ? 0.08 : 0.06),
                          imageWidth: size.width * (isMobile ? 0.08 : 0.06),
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
