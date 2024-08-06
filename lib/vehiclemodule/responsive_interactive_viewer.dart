import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:another_flushbar/flushbar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Transform.scale(
        scale: 1.3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Stack(
                children: [
                  BlocListener<VehiclePartsInteractionBloc,
                      VehiclePartsInteractionBlocState>(
                    listener: (context, state) async {
                      if (state.status ==
                          VehiclePartsInteractionStatus.success) {
                        await DMSCustomWidgets.DMSFlushbar(size, context,
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (_) => DashboardView()));
                      }
                    },
                    child: GestureDetector(
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
                            // image: DecorationImage(
                            //     image: AssetImage("assets/images/road.jpg"),
                            //     fit: BoxFit.fill),
                            // color:  Colors.black45,
                            gradient: LinearGradient(
                                colors: [
                              Colors.black45,
                              ui.Color.fromARGB(40, 104, 103, 103),
                              Colors.black45
                            ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                                stops: [
                              0.1,
                              0.5,
                              1
                            ])),
                        child: BodyCanvas(
                          generalParts: widget.generalParts,
                        ),
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
                            CommentsView(
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
                        )),
                  Positioned(
                    bottom: 100,
                    left: 155,
                    child: ElevatedButton(
                        onPressed: () {
                          if (!Provider.of<BodySelectorViewModel>(context,
                                  listen: false)
                              .isTapped) {
                            Navigator.popUntil(
                              context,
                              (route) => route.settings.name == '/',
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ListOfJobcards()));
                          }
                          // context
                          //     .read<VehiclePartsInteractionBloc>()
                          //     .add(SubmitVehicleMediaEvent());
                        },
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.orange.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            minimumSize: const Size(8, 24),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
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
      ),
    );
  }
}
