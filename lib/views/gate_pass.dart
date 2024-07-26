
import 'dart:math';
import 'dart:typed_data';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_clippers/ticket_clippers.dart' hide RoundedEdgeClipper;
import 'package:ticket_widget/ticket_widget.dart' hide TicketClipper;
import 'package:widgets_to_image/widgets_to_image.dart' ;
class GatePass extends StatefulWidget {
  const GatePass({super.key});
  
  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  // WidgetsToImageController to access widget
  WidgetsToImageController widgetsToImageController = WidgetsToImageController();
  late Uint8List? bytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ServiceBloc>().add(GetGatePass(jobCardNo: "JC-MWC-420"));
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pop(context);
      },
      child: Scaffold(
          extendBody: false,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: Colors.black45,
            leadingWidth: size.width * 0.14,
            leading: Container(
              margin: EdgeInsets.only(left: size.width * 0.045),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, boxShadow: [
                BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
              ]),
              child: Transform(
                transform: Matrix4.translationValues(-3, 0, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
              ),
            ),
            title: Container(
                alignment: Alignment.center,
                height: size.height * 0.05,
                width: size.width * 0.45,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                  BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                ]),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Gate Pass',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                )),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center, // Align the child container in the center
                  child: WidgetsToImage(
                                    controller: widgetsToImageController,

                    child: TicketWidget(
                      width: size.width * 0.8, // Ensure this width matches the inner child width
                      height: size.height * 0.55,
                      // decoration: BoxDecoration(color: Color.fromARGB(255, 247, 245, 243), borderRadius: BorderRadius.circular(16)),
                      isCornerRounded: true,
                      shadow: [],                                    

                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(size.height*0.04),
                          TicketClipper(
                            clipper: RoundedEdgeClipper(
                              points: 8,
                              depth: 16,
                              edge: Edge.all,
                            ),
                            shadow: const BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 2.5),
                            child: Container(
                              alignment: Alignment.center,
                              height: size.height * 0.2,
                              width: size.width * 0.7,
                              decoration: BoxDecoration(color: Colors.orange.shade200),
                              child: Text(context.read<ServiceBloc>().state.gatePassno??"",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18)),
                            ),
                          ),
                          Gap(size.height*0.035),
                          DottedLine(dashLength: 10,alignment: WrapAlignment.center,),
                          Gap(size.height*0.025),
                          Container(
                            decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.black),horizontal: BorderSide(color: Colors.black,),),borderRadius: BorderRadius.circular(16)),
                            child: QrImageView(
                              data: context.read<ServiceBloc>().state.gatePassno??"",
                              version: QrVersions.auto,
                              size: size.width * 0.4,
                              // embeddedImage: ,
                              eyeStyle: QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.circle ),
                              gapless: true,
                              // embeddedImage: AssetImage('assets/images/dashboard_car.png'),
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(80, 80),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
               if (context.watch<ServiceBloc>().state.gatePassStatus == GatePassStatus.loading)
                Container(
                  color: Colors.blueGrey.withOpacity(0.25),
                  child: Center(child: Lottie.asset('assets/lottie/car_loading.json', height: size.height * 0.4, width: size.width * 0.4)),
                )
            ],
          )),
    ));
  }
}

enum Edge { vertical, horizontal, top, bottom, left, right, all }

class RoundedEdgeClipper extends CustomClipper<Path> {
  RoundedEdgeClipper({
    this.edge = Edge.bottom,
    this.points = 20,
    this.depth = 10,
  });

  /// Number of rounded edges
  final int points;

  /// Depth of rounded edge
  final double depth;

  /// Clipper sides: Edge.horizontal, Edge.vertical, Edge.top, Edge.bottom, Edge.left, Edge.right, Edge.all
  final Edge edge;

  @override
  Path getClip(Size size) {
    var h = size.height;
    var w = size.width;
    Path path = Path();

    // Left or Horizontal
    path.moveTo(0, 0);
    path.lineTo(0, h / 3);
    double x = 0;
    double y = h / 3;
    double c = w - depth;
    double i = h / (points - 1);

    if (edge == Edge.left || edge == Edge.horizontal || edge == Edge.all) {
      while (y < h) {
        path.lineTo(x, y + 8);
        y = y + 8;
        path.quadraticBezierTo(depth, y + i / 2, 0, y + i);
        y += i;
      }
    }

    // Bottom or Vertical
    path.lineTo(0, h);
    path.lineTo(w / 2, h);
    x = w / 2;
    y = h;
    c = h - depth;
    i = w / points;

    if (edge == Edge.bottom || edge == Edge.vertical || edge == Edge.all) {
      while (x < w) {
        path.lineTo(x + 8, y);
        x = x + 8;
        path.quadraticBezierTo(x + i / 2, c, x + i, y);
        x += i;
      }
    }
// path.lineTo(w, y);
    // Right or Horizontal
    path.lineTo(w, h / 1.5);
    x = w;
    y = h / 1.5;
    c = w - depth;
    i = h / points;

    if (edge == Edge.right || edge == Edge.horizontal || edge == Edge.all) {
      while (y > 0) {
        path.lineTo(x, y - 8);
        y = y - 8;
        path.quadraticBezierTo(c, y - i / 2, w, y - i);
        y -= i;
      }
    }

    // Top or Vertical
    path.lineTo(w, 0);
    path.lineTo(w / 2, 0);
    x = w / 2;
    y = 0;
    c = h - depth;
    i = w / points;

    if (edge == Edge.top || edge == Edge.vertical || edge == Edge.all) {
      while (x > 0) {
        path.lineTo(x - 8, y);
        x = x - 8;
        path.quadraticBezierTo(x - i / 2, depth, x - i, 0);
        x -= i;
      }
    }
    path.lineTo(0, 0);
    path.addOval(
        Rect.fromCircle(center: Offset(32.0, 32), radius: 10.0));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}


