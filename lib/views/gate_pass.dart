import 'dart:io';
import 'dart:typed_data';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../navigations/navigator_service.dart';

class GatePass extends StatefulWidget {
  const GatePass({super.key});

  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  // WidgetsToImageController to access widget
  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  late Uint8List? bytes;
  late ServiceBloc _serviceBloc;

  NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
    _serviceBloc = context.read<ServiceBloc>();
    _serviceBloc.state.gatePassno = "";
    // fetching job card number
    _serviceBloc
        .add(GetGatePass(jobCardNo: _serviceBloc.state.service!.jobCardNo!));
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return PopScope(
      onPopInvoked: (didPop) {
        if (_serviceBloc.state.service!.status != 'Completed') {
          _serviceBloc.add(GetJobCards(
              query: getIt<SharedPreferences>()
                  .getStringList('locations')!
                  .first));
          _serviceBloc.add(MoveStepperTo(step: 'Completed'));
        }
      },
      child: Scaffold(
          extendBody: false,
          appBar: DMSCustomWidgets.appBar(
              size: size, isMobile: isMobile, title: 'Gate Pass'),
          body: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,

                  // Takes the image of the widget(gate pass)
                  child: WidgetsToImage(
                    controller: widgetsToImageController,
                    child: Column(
                      children: [
                        Gap(size.height * 0.15),
                        ClipShadowPath(
                          clipper: RoundedEdgeClipper(
                            points: 8,
                            depth: 20,
                            edge: Edge.vertical,
                          ),
                          shadow: const Shadow(
                              color: Colors.black, blurRadius: 2.5),
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * (isMobile ? 0.42 : 0.5),
                            width: size.width * (isMobile ? 0.8 : 0.72),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                Gap(size.height * (isMobile ? 0.02 : 0.03)),
                                Row(
                                  children: [
                                    Gap(size.width * (isMobile ? 0.26 : 0.1)),
                                    if (!isMobile) Spacer(),
                                    Text(
                                      "Gate Pass",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width *
                                              (isMobile ? 0.06 : 0.05)),
                                    ),
                                    const Spacer(),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () async {
                                            await Future.delayed(const Duration(
                                                milliseconds: 20));
                                            _serviceBloc.add(
                                                ModifyGatePassStatus(
                                                    status: GatePassStatus
                                                        .loading));

                                            // Storing the image and sharing
                                            final bytes =
                                                await widgetsToImageController
                                                    .capture();
                                            final dir =
                                                await getTemporaryDirectory();
                                            final path =
                                                '${dir.path}/gatepass_${_serviceBloc.state.gatePassno}.png';
                                            final File file = File(path);
                                            await file.writeAsBytes(
                                                bytes as List<int>);
                                            await Share.shareXFiles(
                                              [XFile(path)],
                                              text:
                                                  " gatepass_${_serviceBloc.state.gatePassno}",
                                            );
                                            _serviceBloc.add(
                                                ModifyGatePassStatus(
                                                    status: GatePassStatus
                                                        .initial));
                                          },
                                          icon: Icon(
                                            Icons.ios_share_rounded,
                                            color: Colors.black,
                                            size: size.height * 0.03,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        )),
                                    Gap(size.height *
                                        (isMobile ? 0.008 : 0.02)),
                                  ],
                                ),
                                Gap(size.height * (isMobile ? 0.01 : 0.01)),
                                Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.005,
                                        horizontal: size.width * 0.02),
                                    child: Text(
                                        _serviceBloc.state.gatePassno ?? "",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: (isMobile ? 14 : 18)))),
                                Gap(size.height * 0.02),
                                const DottedLine(),
                                Gap(size.height * 0.02),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: QrImageView(
                                    backgroundColor: Colors.white,
                                    data: _serviceBloc.state.gatePassno ?? "",
                                    version: QrVersions.auto,
                                    size: size.width * 0.4,
                                    gapless: true,
                                    embeddedImageStyle:
                                        const QrEmbeddedImageStyle(
                                      size: Size(80, 80),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (context.watch<ServiceBloc>().state.gatePassStatus ==
                  GatePassStatus.loading)
                Container(
                  color: Colors.blueGrey.withOpacity(0.25),
                  child: Center(
                      child: Lottie.asset('assets/lottie/car_loading.json',
                          height:
                              isMobile ? size.height * 0.5 : size.height * 0.32,
                          width:
                              isMobile ? size.width * 0.6 : size.width * 0.32)),
                )
            ],
          )),
    );
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
    path.moveTo(0, 30);
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
    path.lineTo(0, size.height * 0.26);
    path.quadraticBezierTo(
        25, (size.height * 0.26) + 20, 0, size.height * 0.26 + 40);
    path.lineTo(0, h - 30);
    path.arcToPoint(Offset(30, h),
        radius: const Radius.circular(-30), clockwise: false);
    path.lineTo(40, h);

    x = 40;
    y = h;
    c = h - depth;
    i = w / points;

    if (edge == Edge.bottom || edge == Edge.vertical || edge == Edge.all) {
      while (x < w * 0.85) {
        path.lineTo(x + 8, y);
        x = x + 8;
        path.quadraticBezierTo(x + i / 2, c, x + i, y);
        x += i;
      }
      path.lineTo(w - 30, y);
      path.arcToPoint(Offset(w, h - 30),
          radius: const Radius.circular(30), clockwise: false);
    }

    path.lineTo(w, size.height * 0.26 + 40);
    path.quadraticBezierTo(
        w - 25, (size.height * 0.26) + 20, w, size.height * 0.26);
    // Top or Vertical
    path.lineTo(w, 30);
    path.arcToPoint(Offset(w - 30, 0),
        radius: const Radius.circular(30), clockwise: false);

    // path.lineTo(w / 2, 0);
    x = w - 30;
    y = 0;
    c = h - depth;
    i = w / points;

    if (edge == Edge.top || edge == Edge.vertical || edge == Edge.all) {
      while (x > w * 0.25) {
        path.lineTo(x - 8, y);
        x = x - 8;
        path.quadraticBezierTo(x - i / 2, depth, x - i, 0);
        x -= i;
      }
      path.lineTo(30, 0);
    }
    path.arcToPoint(const Offset(0, 30),
        radius: const Radius.circular(30), clockwise: false);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
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
