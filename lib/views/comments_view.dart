import 'dart:io';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CommentsView extends StatefulWidget {
  VehiclePartMedia vehiclePartMedia;
  CommentsView({super.key, required this.vehiclePartMedia});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocus = FocusNode();
  var imagesCaptured = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    // _cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    print("images ${widget.vehiclePartMedia.images}");
    if (widget.vehiclePartMedia.images == null)
      widget.vehiclePartMedia.images = [];
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
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(16.0),
                    //     color: Colors.white),
                    // padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    // width: isMobile ? size.width * 0.74 : size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vehiclePartMedia.name.replaceAll("_", " ").replaceFirst(widget.vehiclePartMedia.name[0], widget.vehiclePartMedia.name[0].toUpperCase()),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        // Text("Comments",
                        //     style: TextStyle(
                        //         fontFamily: 'Montserrat',
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 18)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          height: size.height * 0.1,
                          child: TextFormField(
                            focusNode: commentsFocus,
                            controller: commentsController,
                            maxLines: 10,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                // fillColor: Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                contentPadding:
                                    EdgeInsets.only(left: 14, top: 14),
                                hintText: "Comments",
                                // alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16))
                                    ),
                            onChanged: (value) {
                              context.read<VehiclePartsInteractionBloc>().add(
                                  AddCommentsEvent(
                                      name: widget.vehiclePartMedia.name,
                                      comments: value));
                            },
                          ),
                        ),
                        Center(
                            child: IconButton(
                                onPressed: () async {
                                  commentsFocus.unfocus();
                                  if (widget.vehiclePartMedia.images!.length <
                                      3) {
                                    ImagePicker imagePicker = ImagePicker();
                                    XFile? image = await imagePicker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (image != null) {
                                      context
                                          .read<VehiclePartsInteractionBloc>()
                                          .add(AddImageEvent(
                                              name:
                                                  widget.vehiclePartMedia.name,
                                              image: image));
                                    }
                                  }
                                },
                                icon: Icon(Icons.add_photo_alternate_rounded))),
                        BlocConsumer<VehiclePartsInteractionBloc,
                            VehiclePartsInteractionBlocState>(
                          listener: (context, state) {
                            // TODO: implement listener
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
                                                    if (widget.vehiclePartMedia
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
                                                  icon: CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor: Colors.white,

                                                    child: Icon(
                                                      Icons.remove_circle_rounded,
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
                        // if (widget.vehiclePartMedia.images != null &&
                        //     widget.vehiclePartMedia.images!.isNotEmpty)
                        //   InkWell(
                        //     onTapDown: (details) {},
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(Icons.cloud_upload_rounded,
                        //             color: Color.fromARGB(255, 145, 19, 19)),
                        //         Text(
                        //           "Upload",
                        //           style: TextStyle(
                        //               color: Color.fromARGB(255, 145, 19, 19)),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                      Gap(8)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: -10.0,
              right: -10.0,
              child: IconButton(
                  onPressed: () {
                    Provider.of<BodySelectorViewModel>(context, listen: false)
                        .isTapped = false;
                    Provider.of<BodySelectorViewModel>(context, listen: false)
                        .selectedGeneralBodyPart = "";
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: size.width * 0.05,
                  )))
        ],
      ),
    );
  }
}
