import 'dart:ui';

import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CustomDetector extends StatelessWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  CustomDetector({super.key, required this.model, this.generalParts});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onPanStart: (details) => print(details.globalPosition),
      onTapDown: (details) => print(" on tap down${details.globalPosition}"),
      onTap: () {
        print("On tapped");
        model.setInteraction(false);
      },
      onLongPress: () {
        print("long press");
      },
      behavior: HitTestBehavior.translucent,
      child: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: EdgeInsets.all(80),
        onInteractionStart: (details) {
          model.setInteraction(true);
        },
        onInteractionEnd: (details) {
          model.setInteraction(false);
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
                      generalParts: generalParts,
                    ),
                  ),
                  Consumer<BodySelectorViewModel>(
                      builder: (context, value, child) {
                        print(value.isTapped);
                    if (value.isTapped) {
                      return Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.5,
                        left: MediaQuery.of(context).size.width * 0.5,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(value.selectedGeneralBodyPart),
                              TextButton(
                                onPressed: () {
                                  value.isTapped = false;
                                },
                                child: Text("back"),
                              )
                            ],
                          ),
                        ),
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
