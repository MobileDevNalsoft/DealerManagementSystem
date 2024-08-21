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
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:o3d/o3d.dart';
import 'dashboard.dart';
import 'service_booking.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin, ConnectivityMixin {
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
  
    return Scaffold(
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
                  height:isMobile?200:size.height*0.32,
                  width: isMobile?200:size.width*0.32,
                ),
                Gap(size.height * 0.24),
                InkWell(
                  onTap: () {
                    if (isConnected()) {
                      

                      Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceMain()));
                    } else {
                      DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.15,
                    height: size.height * 0.08,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black45, Colors.black87, Colors.black], stops: [0.05, 0.5, 1]),
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
                        
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVehicleView()));
                      } else {
                        DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                      }
                    },
                    child: ClippedButton(
                      size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.black45, Colors.black87, Colors.black],
                            stops: [0.05, 0.5, 1]),
                      ),
                      shadow:
                          BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
                      clipper: ButtonClipper(),
                      child: Image.asset(
                        'assets/images/add_vehicle_icon.png',
                        color: Colors.white,
                        opacity: AnimationController(
                          vsync: this,
                          value: 0.7,
                        ),
                        alignment: Alignment.center,
                        height: isMobile ? size.height * 0.1 : size.height * 0.08,
                        width: isMobile ? size.width * 0.1 : size.width * 0.08,
                      ),
                    ),
                  ),
                  Transform.flip(
                    flipX: true,
                    child: GestureDetector(
                      onTap: () {
                        if (isConnected()) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MyJobcards()));
                        } else {
                          DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                        }
                      },
                      onDoubleTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceMainSample()));
                      },
                      child: ClippedButton(
                        size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.black45, Colors.black87, Colors.black],
                              stops: [0.05, 0.5, 1]),
                        ),
                        shadow:
                            BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
                        clipper: ButtonClipper(),
                        child: Image.asset(
                          'assets/images/person_icon.png',
                          color: Colors.white,
                          opacity: AnimationController(
                            vsync: this,
                            value: 0.7,
                          ),
                          alignment: Alignment.center,
                          height: isMobile ? size.height * 0.1 : size.height * 0.06,
                          width: isMobile ? size.width * 0.1 : size.width * 0.06,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VehicleInfo(),
                            ));
                      } else {
                        DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                      }
                    },
                    child: ClippedButton(
                      size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                      decoration: const BoxDecoration(color: Colors.black),
                      shadow:
                          BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
                      clipper: ButtonClipperMid(),
                      child: Image.asset(
                        'assets/images/vehicle_search_icon.png',
                        color: Colors.white,
                        opacity: AnimationController(
                          vsync: this,
                          value: 0.7,
                        ),
                        alignment: Alignment.center,
                        height: isMobile ? size.height * 0.1 : size.height * 0.06,
                        width: isMobile ? size.width * 0.1 : size.width * 0.06,
                      ),
                    ),
                  ),
                  Transform.flip(
                      flipX: true,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DashBoard()));
                        },
                        child: ClippedButton(
                          size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                          decoration: const BoxDecoration(color: Colors.black),
                          shadow: BoxShadow(
                              blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
                          clipper: ButtonClipperMid(),
                          child: Image.asset(
                            'assets/images/home_icon.png',
                            color: Colors.white,
                            opacity: AnimationController(
                              vsync: this,
                              value: 0.7,
                            ),
                            alignment: Alignment.center,
                            height: isMobile ? size.height * 0.1 : size.height * 0.06,
                            width: isMobile ? size.width * 0.1 : size.width * 0.06,
                          ),
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
                          if (isConnected()) {
                            
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ListOfJobcards()));
                          } else {
                            DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                          }
                        },
                        child: ClippedButton(
                          size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.black45, Colors.black87, Colors.black],
                                stops: [0.05, 0.5, 1]),
                          ),
                          shadow: BoxShadow(
                              blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
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
                              height: isMobile ? size.height * 0.1 : size.height * 0.06,
                              width: isMobile ? size.width * 0.1 : size.width * 0.06,
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
                            if (isConnected()) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceHistoryView()));
                            } else {
                              DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                            }
                          },
                          child: ClippedButton(
                              size: Size(isMobile ? size.width * 0.2 : size.width * 0.08, size.height * 0.2),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.black45, Colors.black87, Colors.black],
                                    stops: [0.05, 0.5, 1]),
                              ),
                              shadow: BoxShadow(
                                  blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.orange.shade200, offset: const Offset(0, 0)),
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
                                  height: isMobile ? size.height * 0.1 : size.height * 0.06,
                                  width: isMobile ? size.width * 0.1 : size.width * 0.06,
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
    print('height ${size.height} width ${size.width}');
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
