import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/comments.dart';
import 'package:dms/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:image/image.dart' as img;
import '../bloc/service/service_bloc.dart';

class QualityCheck extends StatefulWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  final List<GeneralBodyPart>? rejectedParts;
  final List<GeneralBodyPart>? pendingParts;
  QualityCheck({super.key, required this.model, this.generalParts, this.acceptedParts, this.rejectedParts, this.pendingParts});
  @override
  State<QualityCheck> createState() => _QualityCheckState();
}

class _QualityCheckState extends State<QualityCheck> with SingleTickerProviderStateMixin {
  TextEditingController rejectionController = TextEditingController();
  FocusNode rejectionFocus = FocusNode();
 

  @override
  void initState() {
    super.initState();
    context.read<VehiclePartsInteractionBloc>().add(FetchVehicleMediaEvent(jobCardNo: "JC-LOC-12"));
   
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Transform.scale(
        scale: 1.3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      print("inside gd");
                      Provider.of<BodySelectorViewModel>(context, listen: false).isTapped = false;
                      Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart = "";
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 230, 119, 119), Color.fromARGB(255, 214, 207, 207), Color.fromARGB(255, 230, 119, 119)])),
                      child: BodyCanvas(
                        displayAcceptedStatus: true,
                          generalParts: widget.generalParts,
                          acceptedParts: widget.acceptedParts,
                          rejectedParts: widget.rejectedParts,
                          pendingParts: widget.pendingParts),
                    ),
                  ),
                  if(!Provider.of<BodySelectorViewModel>(context, listen: false).isTapped)Positioned(
                    bottom: 108,
                    left: 155,
                    child: SizedBox(
                      height: size.height * 0.04,
                      // width: size.width*0.2,
                      child: ElevatedButton(
                          onPressed: () {
                            String message="";
                               for(var entry in context.read<VehiclePartsInteractionBloc>().state.mapMedia.entries) {
                                if(entry.value.isAccepted==null){
                                  message = "Please complete the quality check";
                                }
                                  else if(entry.value.isAccepted==false && entry.value.reasonForRejection!.isEmpty){
                                   message = 'Please add rejection reasons for ${entry.key.toUpperCase()}';
                                  }
                                  if(message.isNotEmpty){
                                   Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        backgroundColor: Colors.red,
                                        message: message,
                                        duration: const Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10))
                                    .show(context);}
                                   
                               }
                                context
                          .read<VehiclePartsInteractionBloc>().add(SubmitQualityCheckStatusEvent(jobCardNo: "JC-LOC-12"));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 145, 19, 19), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  if (Provider.of<BodySelectorViewModel>(context, listen: true).isTapped &&
                      context
                          .read<VehiclePartsInteractionBloc>()
                          .state
                          .mapMedia
                          .containsKey(Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart))
                    Center(
                      child: DraggableScrollableSheet(
                        snap: true,
                        shouldCloseOnMinExtent: true,
                        minChildSize: 0.25,
                        maxChildSize: context
                                        .watch<VehiclePartsInteractionBloc>()
                                        .state
                                        .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                        .isAccepted ==
                                    null ||
                                context
                                        .watch<VehiclePartsInteractionBloc>()
                                        .state
                                        .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                        .isAccepted ==
                                    true
                            ? 0.5
                            : 0.7,
                        initialChildSize: context
                                        .watch<VehiclePartsInteractionBloc>()
                                        .state
                                        .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                        .isAccepted ==
                                    null ||
                                context
                                        .watch<VehiclePartsInteractionBloc>()
                                        .state
                                        .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                        .isAccepted ==
                                    true
                            ? 0.5
                            : 0.7,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: size.width * 0.776,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ], color: Colors.white, borderRadius: BorderRadius.circular(25)),
                              child: CustomScrollView(
                                controller: scrollController,
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        height: 4,
                                        width: 40,
                                        margin: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                  SliverList.list(addRepaintBoundaries: true, children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Gap(4),
                                              Text(
                                                Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart.toUpperCase(),
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          // Gap(8),
                                          Row(
                                            children: [
                                              Gap(8),
                                              CircleAvatar(
                                                radius: 4,
                                                backgroundColor: Color.fromRGBO(145, 19, 19, 1),
                                              ),
                                              Gap(6),
                                              Text(context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart] ==
                                                      null
                                                  ? "No data"
                                                  : context
                                                      .watch<VehiclePartsInteractionBloc>()
                                                      .state
                                                      .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                                      .comments!),
                                            ],
                                          ),
                                          Gap(8.0),
                                          SizedBox(
                                            width: size.width * 0.8,
                                            height: size.height * 0.12,
                                            child: GridView.builder(
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: isMobile ? 3 : 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
                                              itemBuilder: (context, index) {
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          useSafeArea: true,
                                                          builder: (context) {
                                                            return PhotoViewGallery.builder(itemCount: context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                          .images ==
                                                      null
                                                  ? 0
                                                  : context
                                                      .watch<VehiclePartsInteractionBloc>()
                                                      .state
                                                      .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                      .images!
                                                      .length, builder:( BuildContext context, int index) {
                                                        return PhotoViewGalleryPageOptions(
                                                          disableGestures: false,
                                                          maxScale:1.5,
                                                          filterQuality: FilterQuality.high,
                                                          basePosition: Alignment.center,
                                                          imageProvider: FileImage(   File(context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                          .images![index]
                                                          .path),) ,
                                                          initialScale: PhotoViewComputedScale.contained * 0.8,
                                                          heroAttributes: PhotoViewHeroAttributes(tag: context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                          .images![index]),
                                                        );
                                                      },);
                                                          });
                                                    },
                                                    child: Image.file(
                                                      File(context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                          .images![index]
                                                          .path),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: context
                                                          .watch<VehiclePartsInteractionBloc>()
                                                          .state
                                                          .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                          .images ==
                                                      null
                                                  ? 0
                                                  : context
                                                      .watch<VehiclePartsInteractionBloc>()
                                                      .state
                                                      .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!
                                                      .images!
                                                      .length,
                                            ),
                                          ),
                                          Gap(8),
                                          CustomSliderButton(
                                              size: size,
                                              context: context,
                                              rightLabel: Text("Accept"),
                                              leftLabel: Text("Reject"),
                                              icon: Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: Color.fromARGB(255, 230, 119, 119),
                                                  ),
                                                  Positioned(
                                                      top: 8,
                                                      child: Icon(
                                                        Icons.chevron_left_rounded,
                                                      )),
                                                  Positioned(top: 8, right: 1, child: Icon(Icons.chevron_right_rounded))
                                                ],
                                              ),
                                              onDismissed: () {}),
                                          Gap(8),
                                          if (context
                                                  .read<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart] !=
                                              null)
                                            BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                                              listener: (context, state) {
                                                print("listening");
                                              },
                                              builder: (context, state) {
                                                if (state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                                        .isAccepted ==
                                                    false) {
                                                  rejectionController = TextEditingController(
                                                      text: context
                                                              .read<VehiclePartsInteractionBloc>()
                                                              .state
                                                              .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                                              .reasonForRejection ??
                                                          "");

                                                  return TextFormField(
                                                    controller: rejectionController,
                                                    // autofocus:
                                                    //     rejectionController
                                                    //         .text.isEmpty,
                                                    maxLines: 5,
                                                    onTap: () {
                                                      context
                                                          .read<MultiBloc>()
                                                          .add(OnFocusChange(focusNode: rejectionFocus, scrollController: scrollController, context: context));
                                                    },
                                                    decoration: InputDecoration(
                                                        hintStyle: TextStyle(fontSize: 14),
                                                        filled: true,
                                                        contentPadding: EdgeInsets.only(left: 14, top: 14),
                                                        hintText: "Reasons for rejection",
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                                                    onChanged: (value) {
                                                      state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
                                                          .reasonForRejection = value;
                                                    },
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                            ),
                                          if (context
                                                  .read<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart] !=
                                              null)
                                            SizedBox(
                                              height: 40,
                                            )
                                        ],
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          );
                        },
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
        ),
      ),
    );
  }
}

class CustomSliderButton extends StatefulWidget {
  final Size size;
  final BuildContext context;
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget icon;
  final onDismissed;
  ServiceUploadStatus sliderStatus;
  CustomSliderButton(
      {Key? key,
      required this.size,
      required this.context,
      required this.leftLabel,
      required this.rightLabel,
      required this.icon,
      required this.onDismissed,
      this.sliderStatus = ServiceUploadStatus.initial})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _position;
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;
  late double _initialPosition;
  @override
  void initState() {
    super.initState();
    _leftPosition = widget.size.width * 0.057;
    _startPosition = widget.size.width * 0.29;
    _rightPosition = widget.size.width * 0.518;
    if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
            .isAccepted ==
        null) {
      _initialPosition = widget.size.width * 0.28;
    } else if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
            .isAccepted ==
        true) {
      _initialPosition = _rightPosition;
    } else if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart]!
            .isAccepted ==
        false) {
      _initialPosition = _leftPosition;
    }
    _position = _initialPosition;
  }


  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = details.localPosition.dx;
      if (_position > _rightPosition) {
        _position = _rightPosition;
      } else if (_position < _leftPosition) {
        _position = _leftPosition;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    if (_position >= _rightPosition - 20) {
      setState(() {
        _position = _rightPosition;
        context
            .read<VehiclePartsInteractionBloc>()
            .add(ModifyAcceptedEvent(bodyPartName: Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart, isAccepted: true));
      });
      return;
    } else if (_position <= _leftPosition + 20) {
      setState(() {
        _position = _leftPosition;

        context
            .read<VehiclePartsInteractionBloc>()
            .add(ModifyAcceptedEvent(bodyPartName: Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart, isAccepted: false));
      });
      return;
    }
    else {
      setState(() {
        _position = _startPosition;
      context
            .read<VehiclePartsInteractionBloc>()
            .add(ModifyAcceptedEvent(bodyPartName: Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart, isAccepted: null));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("status ${widget.sliderStatus}");
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Color.fromRGBO(233, 227, 227, 1),
                // gradient: LinearGradient(colors: [
                //   Color.fromARGB(255, 230, 119, 119),
                //   Color.fromARGB(255, 235, 233, 233),
                //   Color.fromARGB(255, 230, 119, 119)
                // ]),
              ),
              width: widget.size.width * 0.58,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          baseColor: Colors.black,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: widget.leftLabel),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Shimmer.fromColors(baseColor: Colors.black, highlightColor: Colors.grey.shade100, enabled: true, child: widget.rightLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: _position,
            top: 1.5,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: Stack(
                children: [
                  Center(
                      child: (_position == _rightPosition)
                          ? Lottie.asset("assets/lottie/success.json", repeat: false)
                          : (_position == _leftPosition)
                              ? Lottie.asset("assets/lottie/error2.json", repeat: false)
                              : widget.icon),
                  if (context.watch<ServiceBloc>().state.serviceUploadStatus == ServiceUploadStatus.loading)
                    Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: widget.size.width * 0.008,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
