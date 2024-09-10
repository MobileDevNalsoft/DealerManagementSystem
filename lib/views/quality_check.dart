import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/custom_slider_button.dart';
import 'package:dms/views/inspection_out.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../bloc/service/service_bloc.dart';
import '../navigations/navigator_service.dart';

class QualityCheck extends StatefulWidget {
  final String jobCardNo;
  const QualityCheck({super.key, required this.jobCardNo});
  @override
  State<QualityCheck> createState() => _QualityCheckState();
}

class _QualityCheckState extends State<QualityCheck> with SingleTickerProviderStateMixin, ConnectivityMixin {
  TextEditingController rejectionController = TextEditingController();
  FocusNode rejectionFocus = FocusNode();
  late DraggableScrollableController draggableScrollableController;
  final NavigatorService navigator = getIt<NavigatorService>();
  SliderButtonController sliderButtonController = SliderButtonController();
  late VehiclePartsInteractionBloc _interactionBloc;
  late MultiBloc _multiBloc;
  late Future _resources;
  @override
  void initState() {
    super.initState();
    _resources = loadSvgs();
    _interactionBloc = context.read<VehiclePartsInteractionBloc>();
    _multiBloc = context.read<MultiBloc>();
    _interactionBloc.state.mapMedia = {};
    // fetching images and comments for the jobCard Number
    // remove widget.jobCardNo for release version.
    _interactionBloc.add(FetchVehicleMediaEvent(jobCardNo: context.read<ServiceBloc>().state.service!.jobCardNo ?? widget.jobCardNo
        ));
    draggableScrollableController = DraggableScrollableController();
    draggableScrollableController.addListener(removeSheetOnBelowMin);
  }

  //Closing the bottom sheet on moving it below the min pixels
  void removeSheetOnBelowMin() {
    if (draggableScrollableController.pixels < 190) {
      _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
    }
  }

  Future loadSvgs() async {
    print("called loadsvgs");
    List<List<GeneralBodyPart>> svgResources = [];
    svgResources.add(await loadSvgImage(svgImage: 'assets/images/image.svg')); //generalParts
    svgResources.add(await loadSvgImage(svgImage: 'assets/images/image_accept.svg')); //acceptedParts
    svgResources.add(await loadSvgImage(svgImage: 'assets/images/image_reject.svg')); //rejectedParts
    svgResources.add(await loadSvgImage(svgImage: 'assets/images/image_pending.svg')); //pendingParts
    return svgResources;
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
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, boxShadow: [
                BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
              ]),
              child: Transform(
                transform: Matrix4.translationValues(-3, 0, 0),
                child: IconButton(
                    onPressed: () {
                      navigator.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
              ),
            ),
            title: Container(
                alignment: Alignment.center,
                height: size.height * 0.05,
                width: isMobile ? size.width * 0.45 : size.width * 0.32,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                  BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                ]),
                child: const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Quality Check',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                )),
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.only(right: size.width * 0.024),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -5, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
                child: Switch(
                  value: false,
                  onChanged: (value) {
                    navigator.pushReplacement('/qualityCheck2');
                  },
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.black,
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.black),
                ),
              )
            ]),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Stack(
              children: [
                FutureBuilder(
                    future: _resources,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black45, Color.fromARGB(40, 104, 103, 103), Colors.black45],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.1, 0.5, 1])),
                          child: Transform.scale(
                            scale: context.watch<MultiBloc>().state.scaleFactor ?? 1.3,
                            child: GestureDetector(
                              onScaleUpdate: (details) {
                                _multiBloc.add(ScaleVehicle(factor: details.scale));
                              },
                              // Canvas to build the car model.
                              child: BodyCanvas(
                                  displayAcceptedStatus: true,
                                  generalParts: snapshot.data[0],
                                  acceptedParts: snapshot.data[1],
                                  rejectedParts: snapshot.data[2],
                                  pendingParts: snapshot.data[3]),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),

                //Displaying the sheet only when any part is not tapped
                if (!context.watch<MultiBloc>().state.isTapped)
                  Positioned(
                    bottom: size.height * 0.1,
                    left: isMobile ? size.width * 0.38 : size.width * 0.455,
                    child: SizedBox(
                      height: size.height * 0.04,
                      child: GestureDetector(
                        onTap: () {
                          if (!isConnected()) {
                            DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: const Icon(Icons.error));
                            return;
                          }
                          String message = "";
                          for (var entry in _interactionBloc.state.mapMedia.entries) {
                            if (entry.value.isAccepted == null) {
                              message = "Please complete the quality check";
                            } else if (entry.value.isAccepted == false && entry.value.reasonForRejection!.isEmpty) {
                              message = 'Please add rejection reasons for ${entry.key.toUpperCase()}';
                            }
                            if (message.isNotEmpty) {
                              DMSCustomWidgets.DMSFlushbar(
                                size,
                                context,
                                message: message,
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              );
                              return;
                            }
                          }
                          _interactionBloc.add(SubmitQualityCheckStatusEvent(jobCardNo: widget.jobCardNo));
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
                  ),

                Positioned(
                  top: size.height * 0.35,
                  right: isMobile ? size.width * 0.05 : null,
                  left: isMobile ? null : size.width * 0.032,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16), boxShadow: [
                      BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                    ]),
                    height: size.height * 0.12,
                    width: isMobile ? size.width * 0.1 : size.width * 0.032,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // zoom in and zoom out buttons
                        // max is 1.9 and min is 1.3
                        IconButton(
                            onPressed: () {
                              if (_multiBloc.state.scaleFactor == null) {
                                _multiBloc.state.scaleFactor = 1.4;
                                _multiBloc.add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                              } else {
                                if (_multiBloc.state.scaleFactor! <= 1.8) {
                                  _multiBloc.state.scaleFactor = _multiBloc.state.scaleFactor! + 0.1;
                                  _multiBloc.add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
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
                            if (_multiBloc.state.scaleFactor == null) {
                              _multiBloc.state.scaleFactor = 1.3;
                              _multiBloc.add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
                            } else {
                              if (_multiBloc.state.scaleFactor! >= 1.3) {
                                _multiBloc.state.scaleFactor = _multiBloc.state.scaleFactor! - 0.1;
                                _multiBloc.add(ScaleVehicle(factor: context.read<MultiBloc>().state.scaleFactor!));
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
                  isMobile
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: DraggableScrollableSheet(
                              controller: draggableScrollableController,
                              snap: true,
                              snapAnimationDuration: const Duration(milliseconds: 500),
                              shouldCloseOnMinExtent: true,
                              minChildSize: 0.25,
                              // Bottom sheet sizes
                              maxChildSize: !_interactionBloc.state.mapMedia.containsKey(context.watch<MultiBloc>().state.selectedGeneralBodyPart)
                                  ? 0.25
                                  : context
                                                  .watch<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                  .isAccepted ==
                                              null ||
                                          context
                                                  .watch<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                  .isAccepted ==
                                              true
                                      ? 0.5
                                      : 0.8,
                              initialChildSize: !_interactionBloc.state.mapMedia.containsKey(context.watch<MultiBloc>().state.selectedGeneralBodyPart)
                                  ? 0.25
                                  : context
                                                  .watch<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                  .isAccepted ==
                                              null ||
                                          context
                                                  .watch<VehiclePartsInteractionBloc>()
                                                  .state
                                                  .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                  .isAccepted ==
                                              true
                                      ? 0.5
                                      : 0.7,
                              builder: (BuildContext context, ScrollController scrollController) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: isMobile ? size.width : size.width * 0.5,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(26, 26, 27, 1),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                                    child: LayoutBuilder(builder: (context, ParentSize) {
                                      return CustomScrollView(
                                        controller: scrollController,
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Gap(ParentSize.maxWidth * 0.455),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      height: 4,
                                                      width: ParentSize.maxWidth * 0.1,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    const Spacer(),
                                                    Align(
                                                        alignment: Alignment.centerRight,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                                                          },
                                                          icon: const Icon(
                                                            Icons.cancel,
                                                            size: 28,
                                                          ),
                                                          visualDensity: VisualDensity.compact,
                                                        ))
                                                  ],
                                                ),
                                                const Text(
                                                  "Quality Check",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: 1.5,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // if no images and comments are present for the vehicle part
                                          !_interactionBloc.state.mapMedia.containsKey(context.watch<MultiBloc>().state.selectedGeneralBodyPart)
                                              ? const SliverToBoxAdapter(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "No data found",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: Colors.white54),
                                                    ),
                                                  ),
                                                )
                                              : SliverList.list(addRepaintBoundaries: true, children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Gap(16),
                                                        Row(
                                                          children: [
                                                            const Gap(8),
                                                            Text(
                                                              context.watch<MultiBloc>().state.selectedGeneralBodyPart.replaceAll('_', ' ').toUpperCase(),
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600, color: Colors.white, fontSize: ParentSize.maxWidth * 0.042),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Gap(8),
                                                            const CircleAvatar(
                                                              radius: 6,
                                                              backgroundColor: Color.fromRGBO(145, 19, 19, 1),
                                                            ),
                                                            const Gap(8),
                                                            Text(
                                                                context
                                                                            .watch<VehiclePartsInteractionBloc>()
                                                                            .state
                                                                            .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart] ==
                                                                        null
                                                                    ? "No data"
                                                                    : context
                                                                        .watch<VehiclePartsInteractionBloc>()
                                                                        .state
                                                                        .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                        .comments!,
                                                                style: TextStyle(
                                                                    color: const Color.fromARGB(255, 223, 220, 220), fontSize: ParentSize.maxWidth * 0.040)),
                                                          ],
                                                        ),
                                                        const Gap(8.0),
                                                        SizedBox(
                                                          width: ParentSize.maxWidth * 0.8,
                                                          height: 128,

                                                          // Images of the vehicle part
                                                          child: GridView.builder(
                                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                                                            itemBuilder: (context, index) {
                                                              return ClipRRect(
                                                                borderRadius: BorderRadius.circular(16),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context: context,
                                                                        useSafeArea: true,
                                                                        builder: (context) {
                                                                          return Stack(
                                                                            children: [
                                                                              PhotoViewGallery.builder(
                                                                                allowImplicitScrolling: true,
                                                                                pageController: PageController(initialPage: index),
                                                                                backgroundDecoration: const BoxDecoration(
                                                                                  color: Colors.transparent,
                                                                                ),
                                                                                pageSnapping: true,
                                                                                itemCount: context
                                                                                            .watch<VehiclePartsInteractionBloc>()
                                                                                            .state
                                                                                            .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                            .images ==
                                                                                        null
                                                                                    ? 0
                                                                                    : context
                                                                                        .watch<VehiclePartsInteractionBloc>()
                                                                                        .state
                                                                                        .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                        .images!
                                                                                        .length,
                                                                                builder: (BuildContext context, int index) {
                                                                                  return PhotoViewGalleryPageOptions(
                                                                                    disableGestures: false,
                                                                                    maxScale: 1.5,
                                                                                    filterQuality: FilterQuality.high,
                                                                                    basePosition: Alignment.center,
                                                                                    imageProvider: FileImage(
                                                                                      File(context
                                                                                          .watch<VehiclePartsInteractionBloc>()
                                                                                          .state
                                                                                          .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                          .images![index]
                                                                                          .path),
                                                                                    ),
                                                                                    initialScale: PhotoViewComputedScale.contained * 0.8,
                                                                                    heroAttributes: PhotoViewHeroAttributes(
                                                                                        tag: context
                                                                                            .watch<VehiclePartsInteractionBloc>()
                                                                                            .state
                                                                                            .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                            .images![index]
                                                                                            .path),
                                                                                  );
                                                                                },
                                                                              ),
                                                                              Positioned(
                                                                                top: 10,
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      navigator.pop();
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      Icons.highlight_remove_rounded,
                                                                                      color: Colors.white,
                                                                                      size: 28,
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Image.file(
                                                                    File(context
                                                                        .watch<VehiclePartsInteractionBloc>()
                                                                        .state
                                                                        .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
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
                                                                        .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                        .images ==
                                                                    null
                                                                ? 0
                                                                : context
                                                                    .watch<VehiclePartsInteractionBloc>()
                                                                    .state
                                                                    .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                    .images!
                                                                    .length,
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Builder(
                                                            builder: (context) {
                                                              if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted ==
                                                                  null) {
                                                                sliderButtonController.position = Position.middle;
                                                              } else if (_interactionBloc
                                                                      .state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted ==
                                                                  true) {
                                                                sliderButtonController.position = Position.right;
                                                              } else if (_interactionBloc
                                                                      .state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted ==
                                                                  false) {
                                                                sliderButtonController.position = Position.left;
                                                              } else {
                                                                sliderButtonController.position = Position.left;
                                                              }
                                                              return CustomSliderButton(
                                                                leftLabel: Text("Reject"),
                                                                rightLabel: Text("Accept"),
                                                                controller: sliderButtonController,
                                                                onRightLabelReached: () {
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: true));
                                                                },
                                                                onLeftLabelReached: () {
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: false));
                                                                },
                                                                isMobile: isMobile,
                                                                onNoStatus: () {
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: null));
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        const Gap(16),
                                                        if (context
                                                                .read<VehiclePartsInteractionBloc>()
                                                                .state
                                                                .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart] !=
                                                            null)
                                                          Builder(
                                                            builder: (context) {
                                                              if (_interactionBloc
                                                                      .state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.isAccepted ==
                                                                  false) {
                                                                rejectionController.text = _interactionBloc
                                                                        .state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.reasonForRejection ??
                                                                    "";

                                                                return Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      controller: rejectionController,
                                                                      maxLines: 5,
                                                                      style: const TextStyle(color: Colors.white),
                                                                      // onTap: () async {
                                                                      // await Future.delayed(const Duration(milliseconds: 1000));
                                                                      // scrollController.animateTo(180,
                                                                      //     duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                                                                      // },
                                                                      cursorColor: Colors.white,
                                                                      decoration: InputDecoration(
                                                                          hintStyle: const TextStyle(fontSize: 14, color: Colors.white60),
                                                                          fillColor: const Color.fromRGBO(38, 38, 40, 1),
                                                                          filled: true,
                                                                          contentPadding: const EdgeInsets.only(left: 16, top: 16),
                                                                          hintText: "Reasons for rejection",
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(24.0),
                                                                            borderSide: const BorderSide(
                                                                              color: Color.fromARGB(255, 145, 95, 22),
                                                                            ),
                                                                          ),
                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                                                                      onChanged: (value) {
                                                                        _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!
                                                                            .reasonForRejection = value;
                                                                      },
                                                                    ),
                                                                    const Gap(16),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        if (context
                                                                                    .read<VehiclePartsInteractionBloc>()
                                                                                    .state
                                                                                    .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                    .reasonForRejection ==
                                                                                null ||
                                                                            context
                                                                                .read<VehiclePartsInteractionBloc>()
                                                                                .state
                                                                                .mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                .reasonForRejection!
                                                                                .isEmpty) {
                                                                          DMSCustomWidgets.DMSFlushbar(
                                                                            size,
                                                                            context,
                                                                            message: "Please add rejection reasons",
                                                                            icon: const Icon(
                                                                              Icons.error,
                                                                              color: Colors.white,
                                                                            ),
                                                                          );
                                                                          return;
                                                                        }
                                                                        //bringing to intial status when needed
                                                                        _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                                                                      },
                                                                      child: Container(
                                                                          alignment: Alignment.center,
                                                                          height: 32,
                                                                          width: ParentSize.maxWidth * 0.2,
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
                                                                          child: const Text(
                                                                            textAlign: TextAlign.center,
                                                                            'Done',
                                                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return const SizedBox();
                                                              }
                                                            },
                                                          ),
                                                        if (_interactionBloc.state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart] != null)
                                                          const SizedBox(
                                                            height: 40,
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ])
                                        ],
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      :
                      // For tab screen
                      Positioned(
                          right: size.width * 0.16,
                          top: context.watch<VehiclePartsInteractionBloc>().state.mapMedia.containsKey(context.read<MultiBloc>().state.selectedGeneralBodyPart)
                              ? size.height * 0.08
                              : size.height * 0.16,
                          child: Container(
                            width: size.width * 0.32,
                            height:
                                context.watch<VehiclePartsInteractionBloc>().state.mapMedia.containsKey(context.read<MultiBloc>().state.selectedGeneralBodyPart)
                                    ? (_interactionBloc.state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.isAccepted == null ||
                                            _interactionBloc.state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.isAccepted == true)
                                        ? size.height * 0.42
                                        : size.height * 0.68
                                    : size.height * 0.16,
                            decoration: const BoxDecoration(color: Color.fromRGBO(26, 26, 27, 1), borderRadius: BorderRadius.all(Radius.circular(24))),
                            child: ListView(children: [
                              LayoutBuilder(builder: (context, size) {
                                return Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Gap(32),
                                            const Text(
                                              "Quality Check",
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            // Spacer(),
                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    size: 28,
                                                  ),
                                                  visualDensity: VisualDensity.compact,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                    !_interactionBloc.state.mapMedia.containsKey(context.watch<MultiBloc>().state.selectedGeneralBodyPart)
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "No data found",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          )
                                        : Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Gap(16),
                                                  Row(
                                                    children: [
                                                      const Gap(8),
                                                      Text(
                                                        context.watch<MultiBloc>().state.selectedGeneralBodyPart.replaceAll('_', ' ').toUpperCase(),
                                                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: size.maxWidth * 0.042),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Gap(8),
                                                      const CircleAvatar(
                                                        radius: 6,
                                                        backgroundColor: Color.fromRGBO(145, 19, 19, 1),
                                                      ),
                                                      const Gap(8),
                                                      Text(
                                                          context
                                                                      .watch<VehiclePartsInteractionBloc>()
                                                                      .state
                                                                      .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart] ==
                                                                  null
                                                              ? "No data"
                                                              : context
                                                                  .watch<VehiclePartsInteractionBloc>()
                                                                  .state
                                                                  .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                  .comments!,
                                                          style: TextStyle(color: const Color.fromARGB(255, 223, 220, 220), fontSize: size.maxWidth * 0.040)),
                                                    ],
                                                  ),
                                                  const Gap(8.0),
                                                  SizedBox(
                                                    width: size.maxWidth * 0.8,
                                                    height: 128,
                                                    child: GridView.builder(
                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                                                      itemBuilder: (context, index) {
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(16),
                                                          child: InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context: context,
                                                                  useSafeArea: true,
                                                                  builder: (context) {
                                                                    return Stack(
                                                                      children: [
                                                                        PhotoViewGallery.builder(
                                                                          allowImplicitScrolling: true,
                                                                          pageController: PageController(initialPage: index),
                                                                          backgroundDecoration: const BoxDecoration(
                                                                            color: Colors.transparent,
                                                                          ),
                                                                          pageSnapping: true,
                                                                          itemCount: context
                                                                                      .watch<VehiclePartsInteractionBloc>()
                                                                                      .state
                                                                                      .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                      .images ==
                                                                                  null
                                                                              ? 0
                                                                              : context
                                                                                  .watch<VehiclePartsInteractionBloc>()
                                                                                  .state
                                                                                  .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                  .images!
                                                                                  .length,
                                                                          builder: (BuildContext context, int index) {
                                                                            return PhotoViewGalleryPageOptions(
                                                                              disableGestures: false,
                                                                              maxScale: 1.5,
                                                                              filterQuality: FilterQuality.high,
                                                                              basePosition: Alignment.center,
                                                                              imageProvider: FileImage(
                                                                                File(context
                                                                                    .watch<VehiclePartsInteractionBloc>()
                                                                                    .state
                                                                                    .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                    .images![index]
                                                                                    .path),
                                                                              ),
                                                                              initialScale: PhotoViewComputedScale.contained * 0.8,
                                                                              heroAttributes: PhotoViewHeroAttributes(
                                                                                  tag: context
                                                                                      .watch<VehiclePartsInteractionBloc>()
                                                                                      .state
                                                                                      .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                                      .images![index]
                                                                                      .path),
                                                                            );
                                                                          },
                                                                        ),
                                                                        Positioned(
                                                                          top: 10,
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                                navigator.pop();
                                                                              },
                                                                              icon: const Icon(
                                                                                Icons.highlight_remove_rounded,
                                                                                color: Colors.white,
                                                                                size: 28,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Image.file(
                                                              File(context
                                                                  .watch<VehiclePartsInteractionBloc>()
                                                                  .state
                                                                  .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
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
                                                                  .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                  .images ==
                                                              null
                                                          ? 0
                                                          : context
                                                              .watch<VehiclePartsInteractionBloc>()
                                                              .state
                                                              .mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!
                                                              .images!
                                                              .length,
                                                    ),
                                                  ),
                                                  BlocBuilder<MultiBloc, MultiBlocState>(
                                                    builder: (context, state) {
                                                      // slider button
                                                      return CustomSliderButton(
                                                        leftLabel: Text("Reject"),
                                                        rightLabel: Text("Accept"),
                                                        controller: sliderButtonController,
                                                        onRightLabelReached: () {
                                                          _interactionBloc.add(
                                                              ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: true));
                                                        },
                                                        onLeftLabelReached: () {
                                                          _interactionBloc.add(
                                                              ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: false));
                                                        },
                                                        isMobile: isMobile,
                                                        onNoStatus: () {
                                                          _interactionBloc.add(
                                                              ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: null));
                                                        },
                                                      );
                                                      // CustomSliderButton1(
                                                      //     interactionBloc: _interactionBloc,
                                                      //     size: Size(size.maxWidth, size.maxHeight),
                                                      //     context: context,
                                                      //     rightLabel: const Text(
                                                      //       "Accept",
                                                      //       style: TextStyle(color: Colors.green),
                                                      //     ),
                                                      //     leftLabel: const Text(
                                                      //       "Reject",
                                                      //       style: TextStyle(color: Colors.red),
                                                      //     ),
                                                      //     icon: const Stack(
                                                      //       children: [
                                                      //         CircleAvatar(
                                                      //           backgroundColor: Color.fromRGBO(38, 38, 40, 1),
                                                      //         ),
                                                      //         Positioned(
                                                      //             top: 8,
                                                      //             child: Icon(
                                                      //               Icons.chevron_left_rounded,
                                                      //               color: Colors.white,
                                                      //               shadows: [],
                                                      //             )),
                                                      //         Positioned(
                                                      //             top: 8,
                                                      //             right: 1,
                                                      //             child: Icon(
                                                      //               Icons.chevron_right_rounded,
                                                      //               color: Colors.white,
                                                      //             ))
                                                      //       ],
                                                      //     ),
                                                      //     onDismissed: () {
                                                      //       draggableScrollableController.animateTo(0,
                                                      //           duration: const Duration(milliseconds: 800), curve: Easing.emphasizedDecelerate);
                                                      //     });
                                                    },
                                                  ),
                                                  const Gap(16),
                                                  if (_interactionBloc.state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart] != null)
                                                    BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                                                      listener: (context, state) {},
                                                      builder: (context, state) {
                                                        if (state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.isAccepted == false) {
                                                          rejectionController = TextEditingController(
                                                              text: _interactionBloc.state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                      .reasonForRejection ??
                                                                  "");

                                                          return Column(
                                                            children: [
                                                              TextFormField(
                                                                controller: rejectionController,
                                                                maxLines: 5,
                                                                style: const TextStyle(color: Colors.white),
                                                                onTap: () async {
                                                                  rejectionFocus.requestFocus();
                                                                  await Future.delayed(const Duration(milliseconds: 1000));
                                                                },
                                                                cursorColor: Colors.white,
                                                                decoration: InputDecoration(
                                                                    hintStyle: const TextStyle(fontSize: 14, color: Colors.white60),
                                                                    fillColor: const Color.fromRGBO(38, 38, 40, 1),
                                                                    filled: true,
                                                                    contentPadding: const EdgeInsets.only(left: 16, top: 16),
                                                                    hintText: "Reasons for rejection",
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(24.0),
                                                                      borderSide: const BorderSide(
                                                                        color: Color.fromARGB(255, 145, 95, 22),
                                                                      ),
                                                                    ),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                                                                onChanged: (value) {
                                                                  state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.reasonForRejection =
                                                                      value;
                                                                },
                                                              ),
                                                              const Gap(16),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  context.read<MultiBloc>().state.selectedGeneralBodyPart = "";
                                                                  context.read<MultiBloc>().state.isTapped = false;
                                                                },
                                                                child: Container(
                                                                    alignment: Alignment.center,
                                                                    height: 32,
                                                                    width: size.maxWidth * 0.2,
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
                                                                    child: const Text(
                                                                      textAlign: TextAlign.center,
                                                                      'Done',
                                                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                                                    )),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                  ],
                                );
                              }),
                              if (rejectionFocus.hasPrimaryFocus)
                                SizedBox(
                                  height: size.height * 0.1,
                                )
                            ]),
                          ),
                        ),
                BlocListener<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case VehiclePartsInteractionStatus.success:
                        context.read<ServiceBloc>().add(GetInspectionDetails(jobCardNo: widget.jobCardNo));
                        context.read<ServiceBloc>().add(GetJobCards(query: 'Location27'));
                        navigator.pushAndRemoveUntil('/listOfJobCards', '/home');
                        navigator.push('/inspectionOut');
                      case VehiclePartsInteractionStatus.failure:
                        DMSCustomWidgets.DMSFlushbar(
                          size,
                          context,
                          message: "Some error has occured",
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                        );

                      default:
                    }
                  },
                  child: const SizedBox(),
                )
              ],
            ),
            if (context.watch<VehiclePartsInteractionBloc>().state.status == VehiclePartsInteractionStatus.loading)
              Container(
                color: Colors.transparent,
                child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
              )
          ],
        ));
  }
}

// class CustomSliderButton1 extends StatefulWidget {
//   final Size size;
//   final BuildContext context;
//   final Widget leftLabel;
//   final Widget rightLabel;
//   final Widget icon;
//   final interactionBloc;
//   // ignore: prefer_typing_uninitialized_variables
//   final onDismissed;
//   const CustomSliderButton1(
//       {Key? key,
//       required this.size,
//       required this.context,
//       required this.leftLabel,
//       required this.rightLabel,
//       required this.icon,
//       required this.onDismissed,
//       required this.interactionBloc})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomSliderButton1State createState() => _CustomSliderButton1State();
// }

// class _CustomSliderButton1State extends State<CustomSliderButton1> {
//   late double _position;
//   late double _startPosition;
//   late double _rightPosition;
//   late double _leftPosition;
//   late double _initialPosition;
//   late MultiBloc _multiBloc;
//   dynamic _interactionBloc;
//   @override
//   void initState() {
//     super.initState();
//     _interactionBloc = widget.interactionBloc;
//     // initial postitions of tthe slider
//     _multiBloc = context.read<MultiBloc>();
//     _leftPosition = widget.size.width * 0.168;
//     _startPosition = widget.size.width * 0.39;
//     _rightPosition = widget.size.width * 0.63;
//     if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == null) {
//       _initialPosition = _startPosition;
//     } else if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == true) {
//       _initialPosition = _rightPosition;
//     } else if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == false) {
//       _initialPosition = _leftPosition;
//     }
//     _position = _initialPosition;
//   }

//   void _onPanUpdate(DragUpdateDetails details) {
//     setState(() {
//       _position = details.localPosition.dx;
//       if (_position > _rightPosition) {
//         _position = _rightPosition;
//       } else if (_position < _leftPosition) {
//         _position = _leftPosition;
//       }
//     });
//   }

//   void _onPanEnd(DragEndDetails details) async {
//     // moving the slider to right or left if it very near to the respective positions
//     if (_position >= _rightPosition - 20) {
//       setState(() {
//         _position = _rightPosition;
//         _interactionBloc.add(ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: true));
//       });
//       await Future.delayed(Duration(seconds: 1));
//       widget.onDismissed();
//       return;
//     } else if (_position <= _leftPosition + 20) {
//       setState(() {
//         _position = _leftPosition;

//         _interactionBloc.add(ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: false));
//       });
//       return;
//     } else {
//       setState(() {
//         _position = _startPosition;
//         _interactionBloc.add(ModifyAcceptedEvent(bodyPartName: _multiBloc.state.selectedGeneralBodyPart, isAccepted: null));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     context.read<ServiceBloc>().state.index = 0;
//     return BlocListener<MultiBloc, MultiBlocState>(
//       listener: (context, state) {
//         if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == null) {
//           _initialPosition = _startPosition;
//         } else if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == true) {
//           _initialPosition = _rightPosition;
//         } else if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.isAccepted == false) {
//           _initialPosition = _leftPosition;
//         }
//         _position = _initialPosition;
//       },
//       child: GestureDetector(
//         onPanUpdate: _onPanUpdate,
//         onPanEnd: _onPanEnd,
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                     color: const Color.fromRGBO(36, 38, 40, 1),
//                     boxShadow: const [BoxShadow(color: Color.fromARGB(255, 255, 159, 69), blurRadius: 3, spreadRadius: 0.3)]),
//                 width: widget.size.width * 0.58,
//                 height: 45,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Align(
//                       child: Padding(padding: const EdgeInsets.only(left: 16.0), child: widget.leftLabel),
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Padding(padding: const EdgeInsets.only(right: 16.0), child: widget.rightLabel),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               left: _position,
//               top: 1.5,
//               child: Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                     color: const Color.fromRGBO(36, 38, 40, 1),
//                     borderRadius: BorderRadius.circular(40),
//                     boxShadow: const [BoxShadow(color: Color.fromARGB(255, 255, 159, 69), blurRadius: 0.1, spreadRadius: 0.5)]),
//                 child: Center(
//                     child: (_position == _rightPosition)
//                         ? Lottie.asset("assets/lottie/success.json", repeat: false)
//                         : (_position == _leftPosition)
//                             ? Lottie.asset("assets/lottie/error2.json", repeat: false)
//                             : const Icon(
//                                 Icons.switch_left_rounded,
//                                 color: Colors.white,
//                               )),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
