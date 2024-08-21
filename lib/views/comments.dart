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

class _CommentsViewState extends State<CommentsView> with SingleTickerProviderStateMixin, ConnectivityMixin {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
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
                child: Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  width: isMobile ? size.width * 0.9 : size.width * 0.32,
                  decoration: BoxDecoration(color: Color.fromRGBO(26, 26, 27, 1), borderRadius: BorderRadius.circular(24), boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 4,
                      color: Colors.orange.shade200,
                    )
                  ]),

                  // elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(8),
                      Text(
                        widget.vehiclePartMedia.name
                            .replaceAll("_", " ")
                            .replaceFirst(widget.vehiclePartMedia.name[0], widget.vehiclePartMedia.name[0].toUpperCase()),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 20,
                            shadows: [
                              BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                            ],
                            letterSpacing: 0.4),
                      ),
                      Gap(8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: size.height * 0.15,
                        //  width: size.width * 0.65,
                        child: Stack(
                          children: [
                            TextFormField(
                              key: _formKey,
                              focusNode: commentsFocus,
                              controller: commentsController,
                              maxLines: 10,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.white60),
                                  fillColor: Color.fromRGBO(38, 38, 40, 1),
                                  filled: true,
                                  
                                  contentPadding: EdgeInsets.only(left: 16, top: 16),
                                  hintText: "Comments",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 145, 95, 22),
                                    ),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                              onChanged: (value) {
                                context.read<VehiclePartsInteractionBloc>().add(AddCommentsEvent(name: widget.vehiclePartMedia.name, comments: value));
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    commentsFocus.unfocus();
                                    if (widget.vehiclePartMedia.images!.length < 3) {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? image = await imagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
                                      if (image != null) {
                                        context.read<VehiclePartsInteractionBloc>().add(AddImageEvent(name: widget.vehiclePartMedia.name, image: image));
                                      }
                                    }
                                  },
                                  icon: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_rounded,
                                        color: Colors.white60,
                                      ),
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.srcATop),
                                        child: Lottie.asset(
                                          "assets/lottie/highlight.json",
                                          width: 50,
                                          controller: animationController,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Gap(8),
                      BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                        listener: (context, state) {
                          if (widget.vehiclePartMedia.images!.length == 3) {
                            animationController.reset();
                            animationController.stop();
                          } else {
                            animationController.repeat();
                          }
                        },
                        builder: (context, state) {
                          return Container(
                              padding:  EdgeInsets.symmetric(horizontal: 16.0),
                              height: widget.vehiclePartMedia.images == null || widget.vehiclePartMedia.images!.length == 0
                                  ? 0
                                  : isMobile
                                      ? size.height * 0.14
                                      : size.height * 0.18,
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
                                itemBuilder: (context, index) {
                                  return Stack(fit: StackFit.expand, children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(widget.vehiclePartMedia.images![index].path),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    Positioned(
                                        top: -14,
                                        right: -14.0,
                                        child: IconButton(
                                            onPressed: () {
                                              if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.images != null) {
                                                context
                                                    .read<VehiclePartsInteractionBloc>()
                                                    .add(RemoveImageEvent(name: widget.vehiclePartMedia.name, index: index));
                                              }
                                            },
                                            icon: const CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.remove_circle_rounded,
                                                color: Color.fromARGB(255, 167, 38, 38),
                                                size: 16,
                                              ),
                                            )))
                                  ]);
                                },
                                itemCount: widget.vehiclePartMedia.images == null ? 0 : widget.vehiclePartMedia.images!.length,
                              ));
                        },
                      ),
                      if (widget.vehiclePartMedia.images != null && widget.vehiclePartMedia.images!.isNotEmpty)
                        InkWell(
                          radius: isMobile ? size.width * 0.06 : size.width * 0.024,
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (!isConnected()) {
                              DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
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
                              print(context.read<ServiceBloc>().state.jobCardNo);
                              context.read<VehiclePartsInteractionBloc>().add(SubmitBodyPartVehicleMediaEvent(
                                  bodyPartName: widget.vehiclePartMedia.name, jobCardNo: context.read<ServiceBloc>().state.jobCardNo!
                                  // 'JC-${context.read<ServiceBloc>().state.service!.location!.substring(0, 3).toUpperCase()}-${context.read<ServiceBloc>().state.service!.kms.toString().substring(0, 2)}'
                                  ) as VehiclePartsInteractionBlocEvent);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: size.height * 0.04,
                              width: isMobile ? size.width * 0.2 : size.width * 0.08,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    blurStyle: BlurStyle.outer,
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(255, 204, 128, 1),
                                    offset: const Offset(0, 0))
                              ]),
                              child: const Text(
                                textAlign: TextAlign.center,
                                'Upload',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              )),
                        ),
                      Gap(16)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                onPressed: () {
                  print("asdfasdfsdf");
                  if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name] == null ||
                      (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.comments!.isEmpty &&
                          context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.images!.isEmpty) ||
                      context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.isUploaded) {
                    context.read<MultiBloc>().add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
                  
                    print("git herer");
                    return;
                  }
                  String message = "";
                  if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.comments!.isNotEmpty &&
                      context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.images!.isEmpty) {
                    message = 'Please add atleat one image';
                    print("git herer 1");
                  } else if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.comments!.isEmpty &&
                      context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.images!.isNotEmpty) {
                    message = 'Please add comments';
                    print("git herer 2 ");
                  } else if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[widget.vehiclePartMedia.name]!.isUploaded == false) {
                    message = 'Upload your files before closing';
                    print("git herer 3 ");
                  }
                  print("git herer 4");
                  // else if(widget.vehiclePartMedia.comments!.isNotEmpty &&
                  //     widget.vehiclePartMedia.images!.isNotEmpty){
                  //      message = '';
                  //     }
                  if (message.isNotEmpty) {
                    print("git herer");
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

                    // return;
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
                  // color: Colors.red,
                  size: 32,
                ),
                visualDensity: VisualDensity.compact,
              ))
        ],
      ),
    );
  }
}
