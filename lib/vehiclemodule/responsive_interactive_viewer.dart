import 'dart:ui';

import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class CustomDetector extends StatelessWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  CustomDetector({super.key, required this.model, this.generalParts});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    Size size = MediaQuery.sizeOf(context);
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
            resizeToAvoidBottomInset: false,
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
                        bottom: isMobile?100:size.height*0.25,
                        left: size.width * 0.365,
                        right: size.width*0.1,
                        child: BlocConsumer<VehiclePartsInteractionBlocBloc, VehiclePartsInteractionBlocState>(
                          listener: (context, state) {
                            // TODO: implement listener
                            print("listening ");
                          },
                          builder: (context, state) {
                            return CommentsView(vehiclePartMedia: state.media.firstWhere((e)=>e.name==value.selectedGeneralBodyPart, orElse:()=> VehiclePartMedia(name:value.selectedGeneralBodyPart,comments: "")),);
                          },
                        )
                       
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
