import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
                  if(Provider.of<BodySelectorViewModel>(context,listen: true).isTapped)
                  Positioned(
                      //  bottom: isMobile?100:size.height*0.25,
                            left:  size.width * 0.365,
                            right: size.width*0.1,
                            top:isMobile?100:200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                              
                           BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                              listener: (context, state) {
                                  Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: const Color.fromARGB(255, 218, 212, 212),
                                  message: 'image',
                                  messageText: state.image!=null? Image.memory(state.image!):null,
                                  duration: Duration(seconds: 2))
                              .show(context);
                                print("listening ");
                              },
                              builder: (context, state) {
                                return CommentsView(vehiclePartMedia: state.media.firstWhere((e)=>e.name==Provider.of<BodySelectorViewModel>(context,listen: true).selectedGeneralBodyPart, orElse:()=> VehiclePartMedia(name:Provider.of<BodySelectorViewModel>(context,listen: true).selectedGeneralBodyPart,comments: "")),);
                              },
                            )
                        ,
                        ElevatedButton(
                              onPressed: () {
                                context.read<VehiclePartsInteractionBloc>().add(SubmitVehicleMediaEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(70.0, 35.0),
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor:
                                      const Color.fromARGB(255, 145, 19, 19),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              )),
                              
                          if(context.watch<VehiclePartsInteractionBloc>().state.image!=null)
                              SizedBox(
                                width: size.width*0.3,
                                child: Image.memory(context.read<VehiclePartsInteractionBloc>().state.image!))
                      ],
                    ),
                  )
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
