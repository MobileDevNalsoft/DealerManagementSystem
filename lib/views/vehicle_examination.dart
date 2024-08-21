import 'dart:ui' as ui;
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/comments.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class VehicleExamination extends StatefulWidget {
  final List<GeneralBodyPart>? generalParts;
  VehicleExamination({super.key, this.generalParts});

  @override
  State<VehicleExamination> createState() => _VehicleExaminationState();
}

class _VehicleExaminationState extends State<VehicleExamination> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    //initaializing empty object
    context.read<VehiclePartsInteractionBloc>().state.mapMedia = {};
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.black45,
        leadingWidth: size.width * 0.14,
        leading: Container(
          margin: EdgeInsets.only(left: size.width * 0.045, top: isMobile ? 0 : size.height * 0.008, bottom: isMobile ? 0 : size.height * 0.008),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
          child: Transform(
            transform: Matrix4.translationValues(-3, 0, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.settings.name == '/');
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          ),
        ),
        title: Container(
            alignment: Alignment.center,
            height: size.height * 0.05,
            width: isMobile ? size.width * 0.45 : size.width * 0.32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                'Parts Examination',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              ),
            )),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Stack(
            children: [
              BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(listener: (context, state) {
                if (state.status == VehiclePartsInteractionStatus.success) {
                  DMSCustomWidgets.DMSFlushbar(size, context,
                      message: "Successfully uploaded",
                      icon: const Icon(
                        Icons.cloud_upload_rounded,
                        color: Colors.white,
                      ));
                  // Updating with initial parameters
                  context.read<MultiBloc>().add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                }
              }, builder: (context, state) {
                return Container(
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
                    child: BodyCanvas(
                      generalParts: widget.generalParts,
                    ),
                  ),
                );
              }),
    
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
              if (context.watch<MultiBloc>().state.isTapped)
                Positioned(
                    left: isMobile ? size.width * 0.04 : null,
                    right: isMobile ? null : size.width * 0.16,
                    top: isMobile ? 150 : size.width * 0.08,
                    child: CommentsView(
                      vehiclePartMedia: context.read<VehiclePartsInteractionBloc>().state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart] ??
                          VehiclePartMedia(name: context.read<MultiBloc>().state.selectedGeneralBodyPart, isUploaded: false),
                    )),
              Positioned(
                bottom: isMobile ? 100 : size.height * 0.040,
                left: isMobile ? 155 : size.width * 0.455,
                child: GestureDetector(
                  onTap: () {
                    // After vehicle examination navigation user from home page to list of jobcards.
                    if (!context.read<MultiBloc>().state.isTapped) {
                      Navigator.of(context).popUntil((route) => route.settings.name == '/');
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListOfJobcards()));
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.045,
                      width: isMobile ? size.width * 0.2 : size.width * 0.08,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                        BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
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
              child: Center(child: Lottie.asset('assets/lottie/car_loading.json', height: size.height * 0.4, width: size.width * 0.4)),
            )
        ],
      ),
    );
  }
}
