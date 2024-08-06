import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/comments.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../bloc/service/service_bloc.dart';

class CustomDetector extends StatefulWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  CustomDetector({super.key, required this.model, this.generalParts});

  @override
  State<CustomDetector> createState() => _CustomDetectorState();
}

class _CustomDetectorState extends State<CustomDetector>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<VehiclePartsInteractionBloc>().state.mapMedia={};
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      
      child: Scaffold(
        appBar:  AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.black45,
          leadingWidth: size.width * 0.14,
          leading: Container(
            margin: EdgeInsets.only(left: size.width * 0.045),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      color: Colors.orange.shade200,
                      offset: const Offset(0, 0))
                ]),
            child: Transform(
              transform: Matrix4.translationValues(-3, 0, 0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
            ),
          ),
          title: Container(
              alignment: Alignment.center,
              height: size.height * 0.05,
              width: size.width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 0,
                        color: Colors.orange.shade200,
                        offset: const Offset(0, 0))
                  ]),
              child: const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Parts Examination',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                ),
              )),
          centerTitle: true,
        ),
        
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Stack(
              children: [
                BlocConsumer<VehiclePartsInteractionBloc,
                    VehiclePartsInteractionBlocState>(
                  listener: (context, state)  {
                    if (state.status ==
                        VehiclePartsInteractionStatus.success) {
                      DMSCustomWidgets.DMSFlushbar(size, context,
                          message: "Successfully uploaded",
                          icon: const Icon(
                            Icons.cloud_upload_rounded,
                            color: Colors.white,
                          ));
      
                      Provider.of<BodySelectorViewModel>(context,
                              listen: false)
                          .isTapped = false;
                      Provider.of<BodySelectorViewModel>(context,
                              listen: false)
                          .selectedGeneralBodyPart = "";
                     
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                    onTapDown: (details) {
                      print("inside gd");
                      Provider.of<BodySelectorViewModel>(context,
                              listen: false)
                          .isTapped = false;
                      Provider.of<BodySelectorViewModel>(context,
                              listen: false)
                          .selectedGeneralBodyPart = "";
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.black45,
                            ui.Color.fromARGB(40, 104, 103, 103),
                            Colors.black45
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                            0.1,
                            0.5,
                            1
                          ])),
                      child: Transform.scale(
                        scale: context.watch<MultiBloc>().state.scaleFactor??1.3,
                        child: BodyCanvas(
                          generalParts: widget.generalParts,
                        ),
                      ),
                    ),
                  );
                
                  } ),
                     Positioned(
                  top: size.height*0.35,
                  right: size.width*0.05,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(16),boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
                                      height: size.height * 0.12,
                                      width: size.width * 0.1,
                                      
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    IconButton(onPressed: () {
                      if(context.read<MultiBloc>().state.scaleFactor==null){
                        context.read<MultiBloc>().state.scaleFactor=1.4;
                        context.read<MultiBloc>().add(ScaleVehicle(factor:context.read<MultiBloc>().state.scaleFactor!));
                      }
                      else{
                        if(context.read<MultiBloc>().state.scaleFactor!<=1.8){
                        context.read<MultiBloc>().state.scaleFactor=context.read<MultiBloc>().state.scaleFactor!+0.1;
                        context.read<MultiBloc>().add(ScaleVehicle(factor:context.read<MultiBloc>().state.scaleFactor!));
                        }
                      }        
                    }, icon: Icon(Icons.zoom_in_rounded,color: Colors.white,), visualDensity: VisualDensity.compact),
                    IconButton(
                      onPressed: () {
                          if(context.read<MultiBloc>().state.scaleFactor==null){
                        context.read<MultiBloc>().state.scaleFactor=1.3;
                        context.read<MultiBloc>().add(ScaleVehicle(factor:context.read<MultiBloc>().state.scaleFactor!));
                      }
                      else{
                        if(context.read<MultiBloc>().state.scaleFactor!>=1.3){
                        context.read<MultiBloc>().state.scaleFactor=context.read<MultiBloc>().state.scaleFactor!-0.1;
                      context.read<MultiBloc>().add(ScaleVehicle(factor:context.read<MultiBloc>().state.scaleFactor!));
                      }
                      }
                     print( context.read<MultiBloc>().state.scaleFactor);
                      },
                      icon: Icon(Icons.zoom_out_rounded,color: Colors.white,),
                      visualDensity: VisualDensity.compact,
                    )
                  ],
                                      ),
                                    ),
                ),
                
                if (Provider.of<BodySelectorViewModel>(context, listen: true)
                    .isTapped)
                  Positioned(
                      left:
                          isMobile ? size.width * 0.129 : size.width * 0.365,
                      // right: size.width * 0.1,
                      top: isMobile ? 150 : 200,
                      child:
                          // Card()
                          Transform.scale(
                            scale: 1.3,
                            child: CommentsView(
                                                    vehiclePartMedia: context
                                  .read<VehiclePartsInteractionBloc>()
                                  .state
                                  .mapMedia[Provider.of<BodySelectorViewModel>(
                                      context,
                                      listen: false)
                                  .selectedGeneralBodyPart] ??
                              VehiclePartMedia(
                                  name: Provider.of<BodySelectorViewModel>(
                                          context,
                                          listen: false)
                                      .selectedGeneralBodyPart,
                                  isUploaded: false),
                                                  ),
                          )),
                Positioned(
                  bottom: 100,
                  left: 155,
                  child:
                  GestureDetector(
                     onTap: () {
                        if (!Provider.of<BodySelectorViewModel>(context,
                                listen: false)
                            .isTapped) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ListOfJobcards()));
                        }
                        // context
                        //     .read<VehiclePartsInteractionBloc>()
                        //     .add(SubmitVehicleMediaEvent());
                      },
                    child: Container(
                                                alignment: Alignment.center,
                                                height: size.height * 0.045,
                                                width: size.width * 0.2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: Colors.black,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          blurStyle:
                                                              BlurStyle.outer,
                                                          spreadRadius: 0,
                                                          color: Colors
                                                              .orange.shade200,
                                                          offset:
                                                              const Offset(0, 0))
                                                    ]),
                                                child: const Text(
                                                  textAlign: TextAlign.center,
                                                  'Save',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )),
                  ),
                 
                ),
              ],
            ),
            if (context.watch<VehiclePartsInteractionBloc>().state.status ==
                VehiclePartsInteractionStatus.loading)
              Container(
                color: Colors.blueGrey.withOpacity(0.25),
                child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: size.height * 0.4, width: size.width * 0.4)),
              )
          ],
        ),
      ),
    );
  }
}
