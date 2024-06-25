import 'dart:ui';

import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomDetector extends StatefulWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  CustomDetector({super.key, required this.model, this.generalParts});

  @override
  State<CustomDetector> createState() => _CustomDetectorState();
}

class _CustomDetectorState extends State<CustomDetector> {
  late List<GeneralBodyPart> generalParts;

  @override
  void initState() {
    super.initState();
    getGeneralParts();
  }

  Future<void> getGeneralParts() async {
    generalParts = await loadSvgImage(svgImage: 'assets/images/image.svg');
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    if (isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return GestureDetector(
      onPanStart: (details) => print(details.globalPosition),
      onTapDown: (details) => print(" on tap down${details.globalPosition}"),
      onTap: () {
        print("On tapped");
        widget.model.setInteraction(false);
      },
      onLongPress: () {
        print("long press");
      },
      behavior: HitTestBehavior.translucent,
      child: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: EdgeInsets.all(80),
        onInteractionStart: (details) {
          widget.model.setInteraction(true);
        },
        onInteractionEnd: (details) {
          widget.model.setInteraction(false);
        },
        minScale: 0.5,
        maxScale: 4,
        child: Transform.scale(
          scale: 1.3,
          child: Scaffold(
            // body: Viewer(),
            body: Center(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(145, 145, 145, 100),
                    child: BodyCanvas(
                      generalParts: widget.generalParts,
                    ),
                  ),
                  Consumer<BodySelectorViewModel>(
                      builder: (context, value, child) {
                    print(value.isTapped);
                    if (value.isTapped) {
                      return Positioned(
                          top: 100,
                          // bottom: MediaQuery.of(context).size.height * 0.5,
                          left: MediaQuery.of(context).size.width * 0.5,
                          child: CommentsView(
                              bodyPartName: value.selectedGeneralBodyPart)
                          // Container(
                          //   height: MediaQuery.of(context).size.height * 0.2,
                          //   width: MediaQuery.of(context).size.width * 0.3,
                          //   color: Colors.white,
                          //   child: Column(
                          //     children: [
                          //       Text(value.selectedGeneralBodyPart),
                          //       TextButton(
                          //         onPressed: () {
                          //           value.isTapped = false;
                          //         },
                          //         child: Text("back"),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          );
                    } else {
                      return Positioned(bottom: 0, child: SizedBox());
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
