import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/comments.dart';
import 'package:dms/views/dashboard.dart';
import 'package:flutter/material.dart';
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

class _CustomDetectorState extends State<CustomDetector> {
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceBloc = BlocProvider.of<ServiceBloc>(context);
    widget.generalParts!.forEach((value) {
      if (!value.name.startsWith('text')) {
        context
            .read<VehiclePartsInteractionBloc>()
            .add(AddCommentsEvent(name: value.name));
      }
    });
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
                        await Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Colors.green,
                          message: "Successfully uploaded",
                          duration: const Duration(seconds: 1),
                          borderRadius: BorderRadius.circular(12),
                          margin: EdgeInsets.only(
                              top: size.height * 0.01,
                              left: isMobile ? 10 : size.width * 0.8,
                              right: size.width * 0.03),
                        ).show(context);
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
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 230, 119, 119),
                          Color.fromARGB(255, 214, 207, 207),
                          Color.fromARGB(255, 230, 119, 119)
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
                      left: isMobile ? size.width * 0.129 : size.width * 0.365,
                      // right: size.width * 0.1,
                      top: isMobile ? 150 : 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocConsumer<VehiclePartsInteractionBloc,
                              VehiclePartsInteractionBlocState>(
                            listener: (context, state) {
                              state.media.forEach((value) {
                                print(
                                    "listening ${value.name} ${value.images}");
                              });
                            },
                            builder: (context, state) {
                              return CommentsView(
                                vehiclePartMedia: state.media.firstWhere(
                                    (e) =>
                                        e.name ==
                                        Provider.of<BodySelectorViewModel>(
                                                context,
                                                listen: true)
                                            .selectedGeneralBodyPart,
                                    orElse: () => VehiclePartMedia(
                                        name:
                                            Provider.of<BodySelectorViewModel>(
                                                    context,
                                                    listen: true)
                                                .selectedGeneralBodyPart,
                                        comments: "")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    bottom: 100,
                    left: 155,
                    child: ElevatedButton(
                        onPressed: () {
                             Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DashboardView()));
                          // context
                          //     .read<VehiclePartsInteractionBloc>()
                          //     .add(SubmitVehicleMediaEvent());
                        },
                        style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(35.0, 35.0),
                            // padding: const EdgeInsets.all(8),
                            backgroundColor:
                                const Color.fromARGB(255, 145, 19, 19),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))),
                        child: const Text(  
                          'Save',
                          style: TextStyle(color: Colors.white),
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
