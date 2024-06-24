import 'dart:io';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CommentsView extends StatefulWidget {

  VehiclePartMedia vehiclePartMedia;
  CommentsView({ super.key,required this.vehiclePartMedia});

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
    commentsController.text = widget.vehiclePartMedia.comments??"";
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    Size size = MediaQuery.sizeOf(context);
    return Center(
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), color: Colors.black12),
          child: Column(
            children: [
              Text(
                widget.vehiclePartMedia.name,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white),
                padding: EdgeInsets.all(8.0),
                width: size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Comments",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(
                      height: size.height * 0.1,
                      child: TextFormField(
                        focusNode: commentsFocus,
                        controller: commentsController,
                        maxLines: 10,
                        onChanged: (value) {
                          context.read<VehiclePartsInteractionBloc>().add(
                              AddCommentsEvent(
                                  name:widget.vehiclePartMedia.name, comments: value));
                        },
                      ),
                    ),
                    Center(
                        child: IconButton(
                            onPressed: () async {
                              commentsFocus.unfocus();
                              ImagePicker imagePicker = ImagePicker();
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.camera,);
                              if (image != null) {
                                context
                                    .read<VehiclePartsInteractionBloc>()
                                    .add(AddImageEvent(
                                        name: widget.vehiclePartMedia.name,
                                        image: image));
                              }
                            },
                            icon: Icon(Icons.add_photo_alternate_rounded))),
                    BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        return SizedBox(
                            height: widget.vehiclePartMedia.images==null?0:widget.vehiclePartMedia.images!.length == 0
                                ? size.height*0.1
                                : 
                                 size.height * 0.2,
                            width: size.width * 0.5,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return Stack(fit: StackFit.expand, children: [
                                  Image.file(
                                    File(widget.vehiclePartMedia.images![index].path),
                                    
                                    fit: BoxFit.fill,
                                  ),
                                  Positioned(
                                      top: -10,
                                      right: -10.0,
                                      child: IconButton(
                                          onPressed: () {
                                            if(widget.vehiclePartMedia.images!=null){
                                          context
                                    .read<VehiclePartsInteractionBloc>()
                                    .add(RemoveImageEvent(name: widget.vehiclePartMedia.name, index: index));
                                          }},
                                          icon: Icon(
                                            Icons.cancel_rounded,
                                            color: Colors.red,
                                          )))
                                ]);
                              },
                              itemCount:widget.vehiclePartMedia.images==null?0:widget.vehiclePartMedia.images!.length, 
                            )
                            );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
