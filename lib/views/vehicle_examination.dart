import 'dart:ui' as ui;
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class VehicleExamination extends StatefulWidget {
  //  List<GeneralBodyPart>? generalParts;
  VehicleExamination({
    super.key,
  });

  @override
  State<VehicleExamination> createState() => _VehicleExaminationState();
}

class _VehicleExaminationState extends State<VehicleExamination> with SingleTickerProviderStateMixin {
  NavigatorService navigator = getIt<NavigatorService>();
  @override
  void initState() {
    super.initState();

    //initaializing empty object
    context.read<VehiclePartsInteractionBloc>().state.mapMedia = {};
    context.read<VehiclePartsInteractionBloc>().state.selectedBodyPart = "";
  }

  Future loadSvg() async {
    return await loadSvgImage(svgImage: 'assets/images/image.svg');
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Parts Examination', actions: [
        Container(
          margin: EdgeInsets.only(right: size.width * 0.024),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -5, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
          child: Switch(
            value: false,
            onChanged: (value) {
              navigator.pushReplacement('/vehicleExamination2');
            },
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.black),
          ),
        )
      ]),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: loadSvg(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.black45, ui.Color.fromARGB(40, 104, 103, 103), Colors.black45],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.1, 0.5, 1])),
                        child: Transform.scale(
                          scale: context.watch<MultiBloc>().state.scaleFactor ?? 1.3,
                          child: BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                            listener: (context, state) {
                              if (state.status == VehiclePartsInteractionStatus.success) {
                                DMSCustomWidgets.DMSFlushbar(size, context,
                                    message: "Successfully uploaded",
                                    icon: const Icon(
                                      Icons.cloud_upload_rounded,
                                      color: Colors.white,
                                    ));
                                // Updating with initial parameters
                                context.read<VehiclePartsInteractionBloc>().add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                              }
                            },
                            builder: (context, state) {
                              return BodyCanvas(
                                generalParts: snapshot.data,
                              );
                            },
                          ),
                        ),
                      ),

                      //zoom in zoom out buttons
                      Positioned(
                        top: size.height * 0.35,
                        right: isMobile ? size.width * 0.05 : null,
                        left: isMobile ? null : size.width * 0.032,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16), boxShadow: [
                            BoxShadow(blurRadius: 16, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                          ]),
                          height: size.height * 0.12,
                          width: isMobile ? size.width * 0.1 : size.width * 0.032,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // Upper limit for zoom is 1.8
                                    if (context.read<MultiBloc>().state.scaleFactor == null) {
                                      context.read<MultiBloc>().state.scaleFactor = 1.4;
                                      context.read<MultiBloc>().add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                                    } else {
                                      if (context.read<MultiBloc>().state.scaleFactor! <= 1.8) {
                                        context.read<MultiBloc>().state.scaleFactor = context.read<MultiBloc>().state.scaleFactor! + 0.1;
                                        context.read<MultiBloc>().add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.zoom_in_rounded,
                                    color: Colors.white,
                                  ),
                                  visualDensity: VisualDensity.compact),
                              IconButton(
                                onPressed: () {
                                  // Lower limit for zoom is 1.3
                                  if (context.read<MultiBloc>().state.scaleFactor == null) {
                                    context.read<MultiBloc>().state.scaleFactor = 1.3;
                                    context.read<MultiBloc>().add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                                  } else {
                                    if (context.read<MultiBloc>().state.scaleFactor! >= 1.3) {
                                      context.read<MultiBloc>().state.scaleFactor = context.read<MultiBloc>().state.scaleFactor! - 0.1;
                                      context.read<MultiBloc>().add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.zoom_out_rounded,
                                  color: Colors.white,
                                ),
                                visualDensity: VisualDensity.compact,
                              )
                            ],
                          ),
                        ),
                      ),

                      if (context.read<VehiclePartsInteractionBloc>().state.isTapped)
                        Positioned(
                            left: isMobile ? size.width * 0.04 : null,
                            right: isMobile ? null : size.width * 0.16,
                            top: isMobile ? 150 : size.width * 0.08,
                            child: Comments(
                              vehiclePartMedia: context
                                      .read<VehiclePartsInteractionBloc>()
                                      .state
                                      .mapMedia[context.read<VehiclePartsInteractionBloc>().state.selectedBodyPart] ??
                                  VehiclePartMedia(name: context.read<VehiclePartsInteractionBloc>().state.selectedBodyPart!, isUploaded: false),
                            )),
                      Positioned(
                        bottom: isMobile ? size.height * 0.12 : size.height * 0.040,
                        left: isMobile ? size.width * 0.4 : size.width * 0.455,
                        child: GestureDetector(
                          onTap: () {
                            // After vehicle examination navigation user from home page to list of jobcards.
                            if (!context.read<VehiclePartsInteractionBloc>().state.isTapped!) {
                              navigator.pushAndRemoveUntil('/listOfJobCards', '/home');
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: size.height * 0.045,
                              width: isMobile ? size.width * 0.2 : size.width * 0.08,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                BoxShadow(
                                    blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                              ]),
                              child: const Text(
                                textAlign: TextAlign.center,
                                'Save',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              )),
                        ),
                      ),
                    ],
                  ),
                  if (context.watch<VehiclePartsInteractionBloc>().state.status == VehiclePartsInteractionStatus.loading)
                    Container(
                      color: Colors.blueGrey.withOpacity(0.25),
                      child: Center(
                          child: Lottie.asset('assets/lottie/car_loading.json',
                              height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
                    )
                ],
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
