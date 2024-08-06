import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsView extends StatefulWidget {
  VehiclePartMedia vehiclePartMedia;
  CommentsView({super.key, required this.vehiclePartMedia});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView>
    with SingleTickerProviderStateMixin, ConnectivityMixin {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    widget.vehiclePartMedia.comments ??= "";
    widget.vehiclePartMedia.images ??= [];
    animationController.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("images ${widget.vehiclePartMedia.images}");
    widget.vehiclePartMedia.images ??= [];
    commentsController.text = widget.vehiclePartMedia.comments ?? "";
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  commentsFocus.unfocus();
                },
                child: SizedBox(
                  width: isMobile ? size.width * 0.74 : size.width * 0.4,
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.vehiclePartMedia.name
                              .replaceAll("_", " ")
                              .replaceFirst(
                                  widget.vehiclePartMedia.name[0],
                                  widget.vehiclePartMedia.name[0]
                                      .toUpperCase()),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          height: size.height * 0.1,
                          child: Stack(
                            children: [
                              TextFormField(
                                key: _formKey,
                                focusNode: commentsFocus,
                                controller: commentsController,
                                maxLines: 10,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.only(left: 14, top: 14),
                                    hintText: "Comments",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                                onChanged: (value) {
                                  context
                                      .read<VehiclePartsInteractionBloc>()
                                      .add(AddCommentsEvent(
                                          name: widget.vehiclePartMedia.name,
                                          comments: value));
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      commentsFocus.unfocus();
                                      if (widget
                                              .vehiclePartMedia.images!.length <
                                          3) {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? image =
                                            await imagePicker.pickImage(
                                                source: ImageSource.camera,
                                                preferredCameraDevice:
                                                    CameraDevice.rear);
                                        if (image != null) {
                                          context
                                              .read<
                                                  VehiclePartsInteractionBloc>()
                                              .add(AddImageEvent(
                                                  name: widget
                                                      .vehiclePartMedia.name,
                                                  image: image));
                                        }
                                      }
                                    },
                                    icon: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_rounded),
                                        Lottie.asset(
                                            "assets/lottie/highlight.json",
                                            width: 50,
                                            controller: animationController)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Gap(4),
                        BlocConsumer<VehiclePartsInteractionBloc,
                            VehiclePartsInteractionBlocState>(
                          listener: (context, state) {
                            if (widget.vehiclePartMedia.images!.length == 3) {
                              animationController.reset();
                              animationController.stop();
                            } else {
                              animationController.repeat();
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                                height:
                                    widget.vehiclePartMedia.images == null ||
                                            widget.vehiclePartMedia.images!
                                                    .length ==
                                                0
                                        ? 0
                                        : size.height * 0.1,
                                width: size.width * 0.65,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: isMobile ? 3 : 5,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              File(widget.vehiclePartMedia
                                                  .images![index].path),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          Positioned(
                                              top: -14,
                                              right: -14.0,
                                              child: IconButton(
                                                  onPressed: () {
                                                    if (context
                                                            .read<
                                                                VehiclePartsInteractionBloc>()
                                                            .state
                                                            .mapMedia[widget
                                                                .vehiclePartMedia
                                                                .name]!
                                                            .images !=
                                                        null) {
                                                      context
                                                          .read<
                                                              VehiclePartsInteractionBloc>()
                                                          .add(RemoveImageEvent(
                                                              name: widget
                                                                  .vehiclePartMedia
                                                                  .name,
                                                              index: index));
                                                    }
                                                  },
                                                  icon: const CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons
                                                          .remove_circle_rounded,
                                                      color: Color.fromARGB(
                                                          255, 167, 38, 38),
                                                      size: 16,
                                                    ),
                                                  )))
                                        ]);
                                  },
                                  itemCount: widget.vehiclePartMedia.images ==
                                          null
                                      ? 0
                                      : widget.vehiclePartMedia.images!.length,
                                ));
                          },
                        ),
                        Gap(8),
                        if (widget.vehiclePartMedia.images != null &&
                            widget.vehiclePartMedia.images!.isNotEmpty)
                          InkWell(
                            radius: size.width * 0.06,
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (!isConnected()) {
                                DMSCustomWidgets.DMSFlushbar(size, context,
                                    message:
                                        'Please check the internet connectivity',
                                    icon: Icon(Icons.error));
                                return;
                              }
                              commentsFocus.unfocus();
                              if (commentsController.text.trim().isEmpty) {
                                commentsFocus.requestFocus();
                                DMSCustomWidgets.DMSFlushbar(
                                  size,
                                  context,
                                  message: "Please add comments",
                                  icon: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                //use service/jobcard number
                                context.read<VehiclePartsInteractionBloc>().add(
                                    SubmitBodyPartVehicleMediaEvent(
                                        bodyPartName:
                                            widget.vehiclePartMedia.name,
                                        jobCardNo: context
                                            .read<ServiceBloc>()
                                            .state
                                            .jobCardNo!
                                        // 'JC-${context.read<ServiceBloc>().state.service!.location!.substring(0, 3).toUpperCase()}-${context.read<ServiceBloc>().state.service!.kms.toString().substring(0, 2)}'
                                        ) as VehiclePartsInteractionBlocEvent);
                              }
                            },
                            child: CircleAvatar(
                              maxRadius: size.width * 0.045,
                              backgroundColor:
                                  const Color.fromARGB(255, 145, 19, 19),
                              child: Center(
                                  child: Icon(
                                Icons.cloud_upload_rounded,
                                color: Colors.white,
                                size: size.width * 0.055,
                              )),
                            ),
                          ),
                        if (widget.vehiclePartMedia.images != null &&
                            widget.vehiclePartMedia.images!.isNotEmpty)
                          Text(
                            "Upload",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        Gap(2)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: -8.0,
              right: -6.0,
              child: IconButton(
                  onPressed: () {
                    if (context
                                .read<VehiclePartsInteractionBloc>()
                                .state
                                .mapMedia[widget.vehiclePartMedia.name] ==
                            null ||
                        (context
                                .read<VehiclePartsInteractionBloc>()
                                .state
                                .mapMedia[widget.vehiclePartMedia.name]!
                                .comments!
                                .isEmpty &&
                            context
                                .read<VehiclePartsInteractionBloc>()
                                .state
                                .mapMedia[widget.vehiclePartMedia.name]!
                                .images!
                                .isEmpty) ||
                        context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .isUploaded) {
                      Provider.of<BodySelectorViewModel>(context, listen: false)
                          .isTapped = false;
                      Provider.of<BodySelectorViewModel>(context, listen: false)
                          .selectedGeneralBodyPart = "";
                      return;
                    }
                    String message = "";
                    if (context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .comments!
                            .isNotEmpty &&
                        context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .images!
                            .isEmpty) {
                      message = 'Please add atleat one image';
                    } else if (context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .comments!
                            .isEmpty &&
                        context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .images!
                            .isNotEmpty) {
                      message = 'Please add comments';
                    } else if (context
                            .read<VehiclePartsInteractionBloc>()
                            .state
                            .mapMedia[widget.vehiclePartMedia.name]!
                            .isUploaded ==
                        false) {
                      message = 'Upload your files before closing';
                    }
                    // else if(widget.vehiclePartMedia.comments!.isNotEmpty &&
                    //     widget.vehiclePartMedia.images!.isNotEmpty){
                    //      message = '';
                    //     }
                    if (message.isNotEmpty) {
                      animationController.repeat();
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
                    // Provider.of<BodySelectorViewModel>(context, listen: false)
                    //     .isTapped = false;
                    // Provider.of<BodySelectorViewModel>(context, listen: false)
                    //     .selectedGeneralBodyPart = "";
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: size.width * 0.06,
                  )))
        ],
      ),
    );
  }
}
