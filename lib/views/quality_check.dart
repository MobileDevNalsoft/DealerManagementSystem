import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/inspection_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../bloc/service/service_bloc.dart';

class QualityCheck extends StatefulWidget {
  BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  final List<GeneralBodyPart>? rejectedParts;
  final List<GeneralBodyPart>? pendingParts;
  final String jobCardNo;
  QualityCheck(
      {super.key,
      required this.model,
      this.generalParts,
      this.acceptedParts,
      this.rejectedParts,
      this.pendingParts,
      this.jobCardNo = "JC-LOC-12"});
  @override
  State<QualityCheck> createState() => _QualityCheckState();
}

class _QualityCheckState extends State<QualityCheck>
    with SingleTickerProviderStateMixin, ConnectivityMixin {
  TextEditingController rejectionController = TextEditingController();
  FocusNode rejectionFocus = FocusNode();
  late DraggableScrollableController draggableScrollableController;
  @override
  void initState() {
    super.initState();
    context.read<VehiclePartsInteractionBloc>().state.mapMedia = {};
    context.read<VehiclePartsInteractionBloc>().add(FetchVehicleMediaEvent(
        jobCardNo: context.read<ServiceBloc>().state.jobCardNo!));
    draggableScrollableController = DraggableScrollableController();
    draggableScrollableController.addListener(removeSheetOnBelowMin);
  }

  void removeSheetOnBelowMin() {
    print(draggableScrollableController.pixels);
    if (draggableScrollableController.pixels < 190) {
      Provider.of<BodySelectorViewModel>(context, listen: false)
          .selectedGeneralBodyPart = "";
      Provider.of<BodySelectorViewModel>(context, listen: false).isTapped =
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Quality Check',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                ),
              )),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTapDown: (details) {
                    print("inside gd");
                    // Provider.of<BodySelectorViewModel>(context, listen: false).isTapped = false;
                    // Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart = "";
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black45,
                              Color.fromARGB(40, 104, 103, 103),
                              Colors.black45
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.5, 1])),
                    child: Transform.scale(
                      scale:
                          context.watch<MultiBloc>().state.scaleFactor ?? 1.3,
                      child: GestureDetector(
                        onScaleUpdate: (details) {
                          context
                              .read<MultiBloc>()
                              .add(ScaleVehicle(factor: details.scale));
                        },
                        child: BodyCanvas(
                            displayAcceptedStatus: true,
                            generalParts: widget.generalParts,
                            acceptedParts: widget.acceptedParts,
                            rejectedParts: widget.rejectedParts,
                            pendingParts: widget.pendingParts),
                      ),
                    ),
                  ),
                ),
                if (!Provider.of<BodySelectorViewModel>(context, listen: false)
                    .isTapped)
                  Positioned(
                    bottom: size.height * 0.1,
                    left: size.width * 0.38,
                    child: SizedBox(
                      height: size.height * 0.04,
                      child: GestureDetector(
                        onTap: () {
                          if (!isConnected()) {
                            DMSCustomWidgets.DMSFlushbar(size, context,
                                message:
                                    'Please check the internet connectivity',
                                icon: Icon(Icons.error));
                            return;
                          }
                          String message = "";
                          for (var entry in context
                              .read<VehiclePartsInteractionBloc>()
                              .state
                              .mapMedia
                              .entries) {
                            if (entry.value.isAccepted == null) {
                              message = "Please complete the quality check";
                            } else if (entry.value.isAccepted == false &&
                                entry.value.reasonForRejection!.isEmpty) {
                              message =
                                  'Please add rejection reasons for ${entry.key.toUpperCase()}';
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
                          context.read<VehiclePartsInteractionBloc>().add(
                              SubmitQualityCheckStatusEvent(
                                  jobCardNo: widget.jobCardNo));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.045,
                            width: size.width * 0.2,
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
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                Positioned(
                  top: size.height * 0.35,
                  right: size.width * 0.05,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 0,
                              color: Colors.orange.shade200,
                              offset: const Offset(0, 0))
                        ]),
                    height: size.height * 0.12,
                    width: size.width * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (context.read<MultiBloc>().state.scaleFactor ==
                                  null) {
                                context.read<MultiBloc>().state.scaleFactor =
                                    1.4;
                                context.read<MultiBloc>().add(ScaleVehicle(
                                    factor: context
                                        .read<MultiBloc>()
                                        .state
                                        .scaleFactor!));
                              } else {
                                if (context
                                        .read<MultiBloc>()
                                        .state
                                        .scaleFactor! <=
                                    1.8) {
                                  context.read<MultiBloc>().state.scaleFactor =
                                      context
                                              .read<MultiBloc>()
                                              .state
                                              .scaleFactor! +
                                          0.1;
                                  context.read<MultiBloc>().add(ScaleVehicle(
                                      factor: context
                                          .read<MultiBloc>()
                                          .state
                                          .scaleFactor!));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.zoom_in_rounded,
                              color: Colors.white,
                            ),
                            visualDensity: VisualDensity.compact),
                        IconButton(
                          onPressed: () {
                            if (context.read<MultiBloc>().state.scaleFactor ==
                                null) {
                              context.read<MultiBloc>().state.scaleFactor = 1.3;
                              context.read<MultiBloc>().add(ScaleVehicle(
                                  factor: context
                                      .read<MultiBloc>()
                                      .state
                                      .scaleFactor!));
                            } else {
                              if (context
                                      .read<MultiBloc>()
                                      .state
                                      .scaleFactor! >=
                                  1.3) {
                                context.read<MultiBloc>().state.scaleFactor =
                                    context
                                            .read<MultiBloc>()
                                            .state
                                            .scaleFactor! -
                                        0.1;
                                context.read<MultiBloc>().add(ScaleVehicle(
                                    factor: context
                                        .read<MultiBloc>()
                                        .state
                                        .scaleFactor!));
                              }
                            }
                            print(context.read<MultiBloc>().state.scaleFactor);
                          },
                          icon: Icon(
                            Icons.zoom_out_rounded,
                            color: Colors.white,
                          ),
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  ),
                ),
                if (Provider.of<BodySelectorViewModel>(context, listen: true)
                        .isTapped
                    // &&
                    // context
                    //     .read<VehiclePartsInteractionBloc>()
                    //     .state
                    //     .mapMedia
                    //     .containsKey(Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart)
                    )
                  Center(
                    child: DraggableScrollableSheet(
                      controller: draggableScrollableController,
                      snap: true,
                      snapAnimationDuration: Duration(milliseconds: 500),
                      shouldCloseOnMinExtent: true,
                      minChildSize: 0.25,
                      maxChildSize: !context
                              .read<VehiclePartsInteractionBloc>()
                              .state
                              .mapMedia
                              .containsKey(Provider.of<BodySelectorViewModel>(
                                      context,
                                      listen: true)
                                  .selectedGeneralBodyPart)
                          ? 0.25
                          : context
                                          .watch<VehiclePartsInteractionBloc>()
                                          .state
                                          .mapMedia[
                                              Provider.of<BodySelectorViewModel>(
                                                      context,
                                                      listen: false)
                                                  .selectedGeneralBodyPart]!
                                          .isAccepted ==
                                      null ||
                                  context
                                          .watch<VehiclePartsInteractionBloc>()
                                          .state
                                          .mapMedia[
                                              Provider.of<BodySelectorViewModel>(
                                                      context,
                                                      listen: false)
                                                  .selectedGeneralBodyPart]!
                                          .isAccepted ==
                                      true
                              ? 0.5
                              : 0.9,
                      initialChildSize: !context
                              .read<VehiclePartsInteractionBloc>()
                              .state
                              .mapMedia
                              .containsKey(Provider.of<BodySelectorViewModel>(
                                      context,
                                      listen: true)
                                  .selectedGeneralBodyPart)
                          ? 0.25
                          : context
                                          .watch<VehiclePartsInteractionBloc>()
                                          .state
                                          .mapMedia[
                                              Provider.of<BodySelectorViewModel>(
                                                      context,
                                                      listen: false)
                                                  .selectedGeneralBodyPart]!
                                          .isAccepted ==
                                      null ||
                                  context
                                          .watch<VehiclePartsInteractionBloc>()
                                          .state
                                          .mapMedia[
                                              Provider.of<BodySelectorViewModel>(
                                                      context,
                                                      listen: false)
                                                  .selectedGeneralBodyPart]!
                                          .isAccepted ==
                                      true
                              ? 0.5
                              : 0.7,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(26, 26, 27, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))),
                            child: LayoutBuilder(builder: (context, size) {
                              return CustomScrollView(
                                controller: scrollController,
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Gap(size.maxWidth * 0.455),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                              ),
                                              height: 4,
                                              width: size.maxWidth * 0.1,
                                              padding: EdgeInsets.zero,
                                            ),
                                            Spacer(),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Provider.of<BodySelectorViewModel>(
                                                            context,
                                                            listen: false)
                                                        .selectedGeneralBodyPart = "";
                                                    Provider.of<BodySelectorViewModel>(
                                                            context,
                                                            listen: false)
                                                        .isTapped = false;
                                                  },
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    size: 28,
                                                  ),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ))
                                          ],
                                        ),
                                        Text(
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
                                  !context
                                          .read<VehiclePartsInteractionBloc>()
                                          .state
                                          .mapMedia
                                          .containsKey(Provider.of<
                                                      BodySelectorViewModel>(
                                                  context,
                                                  listen: true)
                                              .selectedGeneralBodyPart)
                                      ? SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "No data found",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                          ),
                                        )
                                      : SliverList.list(
                                          addRepaintBoundaries: true,
                                          children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Gap(16),
                                                    Row(
                                                      children: [
                                                        Gap(8),
                                                        Text(
                                                          Provider.of<BodySelectorViewModel>(
                                                                  context,
                                                                  listen: true)
                                                              .selectedGeneralBodyPart
                                                              .replaceAll(
                                                                  '_', ' ')
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  size.maxWidth *
                                                                      0.042),
                                                        ),
                                                      ],
                                                    ),
                                                    // Gap(8),
                                                    Row(
                                                      children: [
                                                        Gap(8),
                                                        CircleAvatar(
                                                          radius: 6,
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  145,
                                                                  19,
                                                                  19,
                                                                  1),
                                                        ),
                                                        Gap(8),
                                                        Text(
                                                            context
                                                                        .watch<
                                                                            VehiclePartsInteractionBloc>()
                                                                        .state
                                                                        .mapMedia[Provider.of<BodySelectorViewModel>(context,
                                                                            listen:
                                                                                false)
                                                                        .selectedGeneralBodyPart] ==
                                                                    null
                                                                ? "No data"
                                                                : context
                                                                    .watch<
                                                                        VehiclePartsInteractionBloc>()
                                                                    .state
                                                                    .mapMedia[
                                                                        Provider.of<BodySelectorViewModel>(context, listen: false)
                                                                            .selectedGeneralBodyPart]!
                                                                    .comments!,
                                                            style: TextStyle(
                                                                color:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        223,
                                                                        220,
                                                                        220),
                                                                fontSize:
                                                                    size.maxWidth *
                                                                        0.040)),
                                                      ],
                                                    ),
                                                    Gap(8.0),
                                                    SizedBox(
                                                      width:
                                                          size.maxWidth * 0.8,
                                                      height: 128,
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    isMobile
                                                                        ? 3
                                                                        : 5,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            child: InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    useSafeArea:
                                                                        true,
                                                                    builder:
                                                                        (context) {
                                                                      return Stack(
                                                                        children: [
                                                                          PhotoViewGallery
                                                                              .builder(
                                                                            allowImplicitScrolling:
                                                                                true,
                                                                            pageController:
                                                                                PageController(initialPage: index),
                                                                            backgroundDecoration:
                                                                                BoxDecoration(
                                                                              color: Colors.transparent,
                                                                            ),
                                                                            pageSnapping:
                                                                                true,
                                                                            itemCount: context.watch<VehiclePartsInteractionBloc>().state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!.images == null
                                                                                ? 0
                                                                                : context.watch<VehiclePartsInteractionBloc>().state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!.images!.length,
                                                                            builder:
                                                                                (BuildContext context, int index) {
                                                                              return PhotoViewGalleryPageOptions(
                                                                                disableGestures: false,
                                                                                maxScale: 1.5,
                                                                                filterQuality: FilterQuality.high,
                                                                                basePosition: Alignment.center,
                                                                                imageProvider: FileImage(
                                                                                  File(context.watch<VehiclePartsInteractionBloc>().state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!.images![index].path),
                                                                                ),
                                                                                initialScale: PhotoViewComputedScale.contained * 0.8,
                                                                                heroAttributes: PhotoViewHeroAttributes(tag: context.watch<VehiclePartsInteractionBloc>().state.mapMedia[Provider.of<BodySelectorViewModel>(context, listen: true).selectedGeneralBodyPart]!.images![index].path),
                                                                              );
                                                                            },
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                10,
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                icon: Icon(
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
                                                                    .watch<
                                                                        VehiclePartsInteractionBloc>()
                                                                    .state
                                                                    .mapMedia[Provider.of<BodySelectorViewModel>(
                                                                            context,
                                                                            listen:
                                                                                true)
                                                                        .selectedGeneralBodyPart]!
                                                                    .images![
                                                                        index]
                                                                    .path),
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        itemCount: context
                                                                    .watch<
                                                                        VehiclePartsInteractionBloc>()
                                                                    .state
                                                                    .mapMedia[Provider.of<BodySelectorViewModel>(
                                                                            context,
                                                                            listen:
                                                                                true)
                                                                        .selectedGeneralBodyPart]!
                                                                    .images ==
                                                                null
                                                            ? 0
                                                            : context
                                                                .watch<
                                                                    VehiclePartsInteractionBloc>()
                                                                .state
                                                                .mapMedia[Provider.of<
                                                                            BodySelectorViewModel>(
                                                                        context,
                                                                        listen:
                                                                            true)
                                                                    .selectedGeneralBodyPart]!
                                                                .images!
                                                                .length,
                                                      ),
                                                    ),
                                                    // Gap(16),
                                                    CustomSliderButton1(
                                                        size: Size(
                                                            size.maxWidth,
                                                            size.maxHeight),
                                                        context: context,
                                                        rightLabel: Text(
                                                          "Accept",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        leftLabel: Text(
                                                          "Reject",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        icon: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          38,
                                                                          38,
                                                                          40,
                                                                          1),
                                                            ),
                                                            Positioned(
                                                                top: 8,
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_left_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  shadows: [],
                                                                )),
                                                            Positioned(
                                                                top: 8,
                                                                right: 1,
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_right_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                ))
                                                          ],
                                                        ),
                                                        onDismissed: () {
                                                          draggableScrollableController.animateTo(
                                                              0,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      800),
                                                              curve: Easing
                                                                  .emphasizedDecelerate);
                                                        }),
                                                    Gap(8),
                                                    if (context
                                                            .read<
                                                                VehiclePartsInteractionBloc>()
                                                            .state
                                                            .mapMedia[Provider.of<
                                                                    BodySelectorViewModel>(
                                                                context,
                                                                listen: false)
                                                            .selectedGeneralBodyPart] !=
                                                        null)
                                                      BlocConsumer<
                                                          VehiclePartsInteractionBloc,
                                                          VehiclePartsInteractionBlocState>(
                                                        listener:
                                                            (context, state) {},
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                                  .mapMedia[Provider.of<
                                                                              BodySelectorViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .selectedGeneralBodyPart]!
                                                                  .isAccepted ==
                                                              false) {
                                                            rejectionController = TextEditingController(
                                                                text: context
                                                                        .read<
                                                                            VehiclePartsInteractionBloc>()
                                                                        .state
                                                                        .mapMedia[Provider.of<BodySelectorViewModel>(context,
                                                                                listen: false)
                                                                            .selectedGeneralBodyPart]!
                                                                        .reasonForRejection ??
                                                                    "");

                                                            return TextFormField(
                                                              controller:
                                                                  rejectionController,
                                                              // autofocus:
                                                              //     rejectionController
                                                              //         .text.isEmpty,
                                                              maxLines: 5,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              onTap: () async {
                                                                await Future.delayed(
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                scrollController.animateTo(
                                                                    150,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .decelerate);
                                                              },
                                                              cursorColor:
                                                                  Colors.white,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .white60),
                                                                      fillColor:
                                                                          Color.fromRGBO(
                                                                              38,
                                                                              38,
                                                                              40,
                                                                              1),
                                                                      filled:
                                                                          true,
                                                                      contentPadding: EdgeInsets.only(
                                                                          left:
                                                                              16,
                                                                          top:
                                                                              16),
                                                                      hintText:
                                                                          "Reasons for rejection",
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              145,
                                                                              95,
                                                                              22),
                                                                        ),
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16))),
                                                              onChanged:
                                                                  (value) {
                                                                state
                                                                    .mapMedia[Provider.of<BodySelectorViewModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .selectedGeneralBodyPart]!
                                                                    .reasonForRejection = value;
                                                              },
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        },
                                                      ),
                                                    if (context
                                                            .read<
                                                                VehiclePartsInteractionBloc>()
                                                            .state
                                                            .mapMedia[Provider.of<
                                                                    BodySelectorViewModel>(
                                                                context,
                                                                listen: false)
                                                            .selectedGeneralBodyPart] !=
                                                        null)
                                                      SizedBox(
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
                BlocListener<VehiclePartsInteractionBloc,
                    VehiclePartsInteractionBlocState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case VehiclePartsInteractionStatus.success:
                        context.read<ServiceBloc>().add(
                            GetInspectionDetails(jobCardNo: widget.jobCardNo));
                        context.read<ServiceBloc>().add(GetJobCards());
                        Navigator.popUntil(
                          context,
                          (route) => route.settings.name == '/listOfJobCards',
                        );
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => InspectionOut()));
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
                  child: SizedBox(),
                )
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

class CustomSliderButton1 extends StatefulWidget {
  final Size size;
  final BuildContext context;
  final Widget leftLabel;
  final Widget rightLabel;
  final Widget icon;
  final onDismissed;
  ServiceUploadStatus sliderStatus;
  CustomSliderButton1(
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
  _CustomSliderButton1State createState() => _CustomSliderButton1State();
}

class _CustomSliderButton1State extends State<CustomSliderButton1> {
  late double _position;
  late double _startPosition;
  late double _rightPosition;
  late double _leftPosition;
  late double _initialPosition;
  @override
  void initState() {
    super.initState();
    _leftPosition = widget.size.width * 0.168;
    _startPosition = widget.size.width * 0.39;
    _rightPosition = widget.size.width * 0.63;
    if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false)
                .selectedGeneralBodyPart]!
            .isAccepted ==
        null) {
      _initialPosition = _startPosition;
    } else if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false)
                .selectedGeneralBodyPart]!
            .isAccepted ==
        true) {
      _initialPosition = _rightPosition;
    } else if (context
            .read<VehiclePartsInteractionBloc>()
            .state
            .mapMedia[Provider.of<BodySelectorViewModel>(context, listen: false)
                .selectedGeneralBodyPart]!
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
        context.read<VehiclePartsInteractionBloc>().add(ModifyAcceptedEvent(
            bodyPartName:
                Provider.of<BodySelectorViewModel>(context, listen: false)
                    .selectedGeneralBodyPart,
            isAccepted: true));

        // Provider.of<BodySelectorViewModel>(context, listen: false).selectedGeneralBodyPart = "";
        //                                             Provider.of<BodySelectorViewModel>(context, listen: false).isTapped = false;
      });
      await Future.delayed(Duration(seconds: 1));
      widget.onDismissed();
      return;
    } else if (_position <= _leftPosition + 20) {
      setState(() {
        _position = _leftPosition;

        context.read<VehiclePartsInteractionBloc>().add(ModifyAcceptedEvent(
            bodyPartName:
                Provider.of<BodySelectorViewModel>(context, listen: false)
                    .selectedGeneralBodyPart,
            isAccepted: false));
      });
      return;
    } else {
      setState(() {
        _position = _startPosition;
        context.read<VehiclePartsInteractionBloc>().add(ModifyAcceptedEvent(
            bodyPartName:
                Provider.of<BodySelectorViewModel>(context, listen: false)
                    .selectedGeneralBodyPart,
            isAccepted: null));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ServiceBloc>().state.index = 0;
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
                  color: Color.fromRGBO(36, 38, 40, 1),
                  // gradient: LinearGradient(colors: [
                  //   Color.fromARGB(255, 230, 119, 119),
                  //   Color.fromARGB(255, 235, 233, 233),
                  //   Color.fromARGB(255, 230, 119, 119)
                  // ]),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 255, 159, 69),
                        blurRadius: 3,
                        spreadRadius: 0.3)
                  ]),
              width: widget.size.width * 0.58,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: widget.leftLabel),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child:
                            // Shimmer.fromColors(
                            //     baseColor: Colors.green,
                            //     highlightColor: Color.fromARGB(255, 255, 159, 69),
                            //     enabled: true,
                            //     child:
                            widget.rightLabel
                        //  ),
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
                  color: Color.fromRGBO(36, 38, 40, 1),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 255, 159, 69),
                        blurRadius: 0.1,
                        spreadRadius: 0.5)
                  ]),
              child: Center(
                  child: (_position == _rightPosition)
                      ?
                      // Icon(Icons.switch_left_rounded)
                      Lottie.asset("assets/lottie/success.json", repeat: false)
                      : (_position == _leftPosition)
                          ? Lottie.asset("assets/lottie/error2.json",
                              repeat: false)
                          : Icon(
                              Icons.switch_left_rounded,
                              color: Colors.white,
                            )),
            ),
          ),
        ],
      ),
    );
  }
}
