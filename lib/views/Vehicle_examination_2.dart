import 'dart:convert';
import 'dart:io';

import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media2.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class VehicleExamination2 extends StatefulWidget {
  const VehicleExamination2({super.key});

  @override
  State<VehicleExamination2> createState() => _VehicleExamination2State();
}

class _VehicleExamination2State extends State<VehicleExamination2> with SingleTickerProviderStateMixin,ConnectivityMixin {
  DraggableScrollableController draggableScrollableController = DraggableScrollableController();
  late VehiclePartsInteractionBloc _interactionBloc;
  late AnimationController bottomSheetController;
  final PageController _pageController = PageController(initialPage: 0);
  final AutoScrollController _autoScrollController = AutoScrollController();
  FocusNode commentsFocus = FocusNode();
  TextEditingController commentsController = TextEditingController();
  late MultiBloc _multiBloc;
  Future loadJs() async {
    return await rootBundle.loadString('assets/index.js');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomSheetController = AnimationController(vsync: this);
    _interactionBloc = context.read<VehiclePartsInteractionBloc>();
    _multiBloc = context.read<MultiBloc>();
    _interactionBloc.state.mapMedia = {};
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final _javascriptChannel = JavascriptChannel(
      'flutterChannel',
      onMessageReceived: (message) {
        print('Received message from JavaScript: ${message.message.runtimeType}');

        Map<String, dynamic> data = jsonDecode(message.message);
         if(data["type"]=="hotspot-create"){
        _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
        context.read<VehiclePartsInteractionBloc>().add(AddCommentsEvent(name: data["name"]!));
        }
        else if(data["type"]=="hotspot-click"){
          print("inside hotspot click");
          _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
          print(data["name"]);
          print(_interactionBloc.state.mapMedia.entries.toList().indexWhere((element)=>element.key==data["name"]).toDouble()  );
          int index= _interactionBloc.state.mapMedia.entries.toList().indexWhere((element)=>element.key==data["name"]);
          _pageController.jumpToPage(index);
          _autoScrollController.scrollToIndex(index);
        }
        // showModalBottomSheet(

        //       // animationController: bottomSheetController,
        //       // enableDrag: true,
        //       // backgroundColor: Colors.green,
        //       // showDragHandle: true,
        //       // onDragStart: (details) {
        //       //   print(details);
        //       //   bottomSheetController.animateTo(details.localPosition.dy,duration: Duration.zero);
        //       // },
        //       isDismissible: true,
        //       backgroundColor: Colors.transparent,
        //       isScrollControlled: true,
        //       builder: (context) {
        //         return  DraggableScrollableSheet(
        //                     controller: draggableScrollableController,
        //                     snap: true,
        //                     snapAnimationDuration: const Duration(milliseconds: 500),
        //                     shouldCloseOnMinExtent: true,
        //                     minChildSize: 0.25,
        //                     // Bottom sheet sizes
        //                      initialChildSize: 0.5,
        //                       maxChildSize: 1.0,
        //                     builder: (BuildContext context, ScrollController scrollController) {
        //                       return Align(
        //                         alignment: Alignment.center,
        //                         child: Container(
        //                           // width: isMobile ? size.width : size.width * 0.5,
        //                           decoration: const BoxDecoration(
        //                               color: Color.fromRGBO(26, 26, 27, 1),
        //                               borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        //                           child: Container(
        //           padding: EdgeInsets.zero,
        //           margin: EdgeInsets.zero,
        //           // width: isMobile ? size.width * 0.9 : size.width * 0.32,
        //           decoration: BoxDecoration(color: const Color.fromRGBO(26, 26, 27, 1), borderRadius: BorderRadius.circular(24), boxShadow: [
        //             BoxShadow(
        //               blurRadius: 6,
        //               blurStyle: BlurStyle.normal,
        //               spreadRadius: 4,
        //               color: Colors.orange.shade200,
        //             )
        //           ]),

        //           // elevation: 10,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               const Gap(8),
        //               Text(
        //                 _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name
        //                     .replaceAll("_", " ")
        //                     .replaceFirst(_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name[0], _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name[0].toUpperCase()),
        //                 style: TextStyle(
        //                     fontFamily: 'Roboto',
        //                     fontWeight: FontWeight.w400,
        //                     color: Colors.white,
        //                     fontSize: 20,
        //                     shadows: [
        //                       BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
        //                     ],
        //                     letterSpacing: 0.4),
        //               ),
        //               const Gap(8),
        //               Container(
        //                 padding: const EdgeInsets.symmetric(horizontal: 16),
        //                 height: size.height * 0.15,
        //                 //  width: size.width * 0.65,
        //                 child: Stack(
        //                   children: [
        //                     TextFormField(
        //                       // key: _formKey,
        //                       // focusNode: commentsFocus,
        //                       // controller: commentsController,
        //                       maxLines: 10,
        //                       cursorColor: Colors.white,
        //                       style: TextStyle(color: Colors.white),
        //                       decoration: InputDecoration(
        //                           hintStyle: const TextStyle(fontSize: 16, color: Colors.white60),
        //                           fillColor: const Color.fromRGBO(38, 38, 40, 1),
        //                           filled: true,
        //                           contentPadding: EdgeInsets.only(left: 16, top: 16),
        //                           hintText: "Comments",
        //                           focusedBorder: OutlineInputBorder(
        //                             borderRadius: BorderRadius.circular(16.0),
        //                             borderSide: const BorderSide(
        //                               color: Color.fromARGB(255, 145, 95, 22),
        //                             ),
        //                           ),
        //                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        //                       onChanged: (value) {
        //                         context.read<VehiclePartsInteractionBloc>().add(AddCommentsEvent(name: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, comments: value));
        //                       },
        //                     ),
        //                     Align(
        //                       alignment: Alignment.bottomRight,
        //                       child: IconButton(
        //                           padding: EdgeInsets.zero,
        //                           onPressed: () async {
        //                             // commentsFocus.unfocus();
        //                             // if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length < 3) {
        //                             //   ImagePicker imagePicker = ImagePicker();
        //                             //   XFile? image = await imagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
        //                             //   if (image != null) {
        //                             //     context.read<VehiclePartsInteractionBloc>().add(AddImageEvent(name: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, image: image));
        //                             //   }
        //                             // }
        //                           },
        //                           icon: Stack(
        //                             alignment: Alignment.center,
        //                             children: [
        //                               const Icon(
        //                                 Icons.add_photo_alternate_rounded,
        //                                 color: Colors.white60,
        //                               ),
        //                               // ColorFiltered(
        //                               //   colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.srcATop),
        //                               //   child: Lottie.asset(
        //                               //     "assets/lottie/highlight.json",
        //                               //     width: 50,
        //                               //     controller: animationController,
        //                               //   ),
        //                               // )
        //                             ],
        //                           )),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               const Gap(8),
        //               // BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
        //               //   listener: (context, state) {
        //               //     if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length == 3) {
        //               //       // animationController.reset();
        //               //       // animationController.stop();
        //               //     } else {
        //               //       // animationController.repeat();
        //               //     }
        //               //   },
        //               //   builder: (context, state) {
        //               //     return Container(
        //               //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //               //         height: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images == null || _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.isEmpty
        //               //             ? 0
        //               //             : isMobile
        //               //                 ? size.height * 0.14
        //               //                 : size.height * 0.18,
        //               //         child:
        //               //          GridView.builder(
        //               //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
        //               //           itemBuilder: (context, index) {
        //               //             return Stack(fit: StackFit.expand, children: [
        //               //               ClipRRect(
        //               //                 borderRadius: BorderRadius.circular(12),
        //               //                 child: Image.file(
        //               //                   // File(_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images![index].path),
        //               //                   fit: BoxFit.fitWidth,
        //               //                 ),
        //               //               ),
        //               //               Positioned(
        //               //                   top: -14,
        //               //                   right: -14.0,
        //               //                   child: IconButton(
        //               //                       onPressed: () {
        //               //                         if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name]!.images != null) {
        //               //                           context
        //               //                               .read<VehiclePartsInteractionBloc>()
        //               //                               .add(RemoveImageEvent(name: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, index: index));
        //               //                         }
        //               //                       },
        //               //                       icon: const CircleAvatar(
        //               //                         radius: 8,
        //               //                         backgroundColor: Colors.white,
        //               //                         child: Icon(
        //               //                           Icons.remove_circle_rounded,
        //               //                           color: Color.fromARGB(255, 167, 38, 38),
        //               //                           size: 16,
        //               //                         ),
        //               //                       )))
        //               //             ]);
        //               //           },
        //               //           itemCount: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images == null ? 0 : _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length,
        //               //         ));

        //               //   },
        //               // ),

        //               // if (_interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images != null && _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.isNotEmpty)
        //               //   InkWell(
        //               //     radius: isMobile ? size.width * 0.06 : size.width * 0.024,
        //               //     borderRadius: BorderRadius.circular(20),
        //               //     onTap: () {
        //               //       if (!isConnected()) {
        //               //         DMSCustomWidgets.DMSFlushbar(size, context,
        //               //             message: 'Looks like you'
        //               //                 're offline. Please check your connection and try again',
        //               //             icon: const Icon(
        //               //               Icons.error,
        //               //               color: Colors.white,
        //               //             ));
        //               //         return;
        //               //       }
        //               //       commentsFocus.unfocus();
        //               //       if (commentsController.text.trim().isEmpty) {
        //               //         commentsFocus.requestFocus();
        //               //         DMSCustomWidgets.DMSFlushbar(
        //               //           size,
        //               //           context,
        //               //           message: "Please add comments",
        //               //           icon: const Icon(
        //               //             Icons.error,
        //               //             color: Colors.white,
        //               //           ),
        //               //         );
        //               //       } else {
        //               //         //use service/jobcard number
        //               //         print(context.read<ServiceBloc>().state.jobCardNo);
        //               //         context.read<VehiclePartsInteractionBloc>().add(SubmitBodyPartVehicleMediaEvent(
        //               //             bodyPartName: _interactionBloc.state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, jobCardNo: context.read<ServiceBloc>().state.jobCardNo!
        //               //             // 'JC-${context.read<ServiceBloc>().state.service!.location!.substring(0, 3).toUpperCase()}-${context.read<ServiceBloc>().state.service!.kms.toString().substring(0, 2)}'
        //               //             ) as VehiclePartsInteractionBlocEvent);
        //               //       }
        //               //     },
        //               //     child: Container(
        //               //         alignment: Alignment.center,
        //               //         height: size.height * 0.04,
        //               //         width: isMobile ? size.width * 0.2 : size.width * 0.08,
        //               //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
        //               //           const BoxShadow(
        //               //               blurRadius: 8, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Color.fromRGBO(255, 204, 128, 1), offset: Offset(0, 0))
        //               //         ]),
        //               //         child: const Text(
        //               //           textAlign: TextAlign.center,
        //               //           'Upload',
        //               //           style: TextStyle(color: Colors.white, fontSize: 14),
        //               //         )),
        //               //   ),
        //               // const Gap(16)
        //             ],
        //           ),
        //         ),
        //       ),
        //                       );
        //                     },
        //                   );
        //       },
        //   context: context,

        // );
      },
    );
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    // Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.black45,
          leadingWidth: size.width * 0.14,
          leading: Container(
            margin: EdgeInsets.only(left: size.width * 0.045, top: isMobile ? 0 : size.height * 0.008, bottom: isMobile ? 0 : size.height * 0.008),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
            child: Transform(
              transform: Matrix4.translationValues(-3, 0, 0),
              child: IconButton(
                  onPressed: () {
                    // navigator.pop();
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
                  'Vehicle Examination',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                ),
              )),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black45, Color.fromARGB(40, 104, 103, 103), Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.5, 1])),
          child: Stack(
            children: [
              FutureBuilder(
                future: loadJs(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          height: size.height * 0.4,
                          width: size.width * 0.98,
                          child: ModelViewer(
                            src: "assets/3d_models/sedan.glb",
                            id: "model",
                            relatedJs: snapshot.data,
                            disableZoom: true,
                            disableTap: true,
                            javascriptChannels: {_javascriptChannel},
                                          
                            onWebViewCreated: (value) {
                              print("value $value");
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
              if (context.watch<MultiBloc>().state.isTapped)
                Positioned(
                  bottom: 0,
                    child: Container(
                      height: size.height*0.44,
                      width: size.width,
                  color: Color.fromRGBO(26, 26, 27, 1),
                  child: BlocBuilder<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.064,
                            width: size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: _autoScrollController,
                                itemBuilder: (context, index) {
                                  return AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: _autoScrollController,
                                    index: index,
                                    child: InkWell(
                                      onTap: () {
                                        _multiBloc.add(ModifyVehicleInteractionStatus(
                                            selectedBodyPart: state.mapMedia.entries.elementAt(index).key, isTapped: _multiBloc.state.isTapped));
                                        _pageController.jumpToPage(index);
                                        _pageController.jumpToPage(index);
                                        state.vehicleExaminationPageIndex = index;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: state.vehicleExaminationPageIndex == index ? Colors.orange.shade200 : Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: state.vehicleExaminationPageIndex == index ? 0 : 5,
                                                  blurStyle: BlurStyle.outer,
                                                  spreadRadius: 0,
                                                  color: Colors.orange.shade200,
                                                  offset: const Offset(0, 0))
                                            ]),
                                        margin: EdgeInsets.all(size.width * 0.02),
                                        child: Center(
                                            child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Gap(size.width * 0.024),
                                            Text(
                                              state.mapMedia.entries.elementAt(index).key,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.cancel,
                                              ),
                                              padding: EdgeInsets.zero,
                                              visualDensity: VisualDensity.compact,
                                            )
                                          ],
                                        )),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.mapMedia.length),
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: ScrollPhysics(),
                              onPageChanged: (value) {
                                _multiBloc.add(ModifyVehicleInteractionStatus(
                                    selectedBodyPart: state.mapMedia.entries.elementAt(value).key, isTapped: _multiBloc.state.isTapped));
                                _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: value));
                                _autoScrollController.scrollToIndex(value,
                                    duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: state.mapMedia.length,
                              itemBuilder: (context, pageIndex) {
                                // GlobalKey _formKey = GlobalKey();
                                return Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  width: isMobile ? size.width * 0.9 : size.width * 0.32,
                                  // decoration: BoxDecoration(color: const Color.fromRGBO(26, 26, 27, 1), borderRadius: BorderRadius.circular(24), boxShadow: [
                                  //   BoxShadow(
                                  //     blurRadius: 6,
                                  //     blurStyle: BlurStyle.normal,
                                  //     spreadRadius: 4,
                                  //     color: Colors.orange.shade200,
                                  //   )
                                  // ]),

                                  // elevation: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Gap(8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        height: size.height * 0.15,
                                        //  width: size.width * 0.65,
                                        child: Stack(
                                          children: [
                                            TextFormField(
                                              // key: _formKey,
                                              // focusNode: commentsFocus,
                                              // controller: commentsController,
                                              initialValue: state.mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!.comments,
                                              maxLines: 10,
                                              cursorColor: Colors.white,
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                
                                                  hintStyle: const TextStyle(fontSize: 16, color: Colors.white60),
                                                  fillColor: const Color.fromRGBO(38, 38, 40, 1),
                                                  filled: true,
                                                  contentPadding: EdgeInsets.only(left: 16, top: 16),
                                                  hintText: "Comments",
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    borderSide: const BorderSide(
                                                      color: Color.fromARGB(255, 145, 95, 22),
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                                              onChanged: (value) {
                                                context.read<VehiclePartsInteractionBloc>().add(
                                                    AddCommentsEvent(name: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, comments: value));
                                              },
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    // commentsFocus.unfocus();
                                                    if (state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length < 3) {
                                                      ImagePicker imagePicker = ImagePicker();
                                                      XFile? image =
                                                          await imagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
                                                      if (image != null) {
                                                        context.read<VehiclePartsInteractionBloc>().add(
                                                            AddImageEvent(name: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, image: image));
                                                      }
                                                    }
                                                  },
                                                  icon: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      const Icon(
                                                        Icons.add_photo_alternate_rounded,
                                                        color: Colors.white60,
                                                      ),
                                                      ColorFiltered(
                                                        colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.srcATop),
                                                        child: Lottie.asset(
                                                          "assets/lottie/highlight.json",
                                                          width: 50,
                                                          // controller: animationController,
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(8),
                                      Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          height: state.mapMedia.entries.elementAt(pageIndex).value.images == null ||
                                                  state.mapMedia.entries.elementAt(pageIndex).value.images!.isEmpty
                                              ? 0
                                              : isMobile
                                                  ? size.height * 0.14
                                                  : size.height * 0.18,
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
                                            itemBuilder: (context, index) {
                                              return Stack(fit: StackFit.expand, children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.file(
                                                    File(state.mapMedia.entries.elementAt(pageIndex).value.images![index].path),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: -14,
                                                    right: -14.0,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          if (context
                                                                  .read<VehiclePartsInteractionBloc>()
                                                                  .state
                                                                  .mapMedia[state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name]!
                                                                  .images !=
                                                              null) {
                                                            context.read<VehiclePartsInteractionBloc>().add(RemoveImageEvent(
                                                                name: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, index: index));
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
                                            itemCount: state.mapMedia.entries.elementAt(pageIndex).value.images == null
                                                ? 0
                                                : state.mapMedia.entries.elementAt(pageIndex).value.images!.length,
                                          )),
                                      // BlocConsumer<VehiclePartsInteractionBloc, VehiclePartsInteractionBlocState>(
                                      //   listener: (context, state) {
                                      //     // if (state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length == 3) {
                                      //     //   animationController.reset();
                                      //     //   animationController.stop();
                                      //     // } else {
                                      //     //   animationController.repeat();
                                      //     // }
                                      //   },
                                      //   builder: (context, state) {
                                      //     return IntrinsicWidth(
                                      //       child: Container(
                                      //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      //           height: 50,
                                      //           // state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images == null || state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.isEmpty
                                      //           //     ? 0
                                      //           //     : isMobile
                                      //           //         ? size.height * 0.14
                                      //           //         : size.height * 0.18,
                                      //           child: GridView.builder(
                                      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
                                      //             itemBuilder: (context, index) {
                                      //               return Stack(fit: StackFit.expand, children: [
                                      //                 ClipRRect(
                                      //                   borderRadius: BorderRadius.circular(12),
                                      //                   child: Image.file(
                                      //                     File(state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images![index].path),
                                      //                     fit: BoxFit.fitWidth,
                                      //                   ),
                                      //                 ),
                                      //                 Positioned(
                                      //                     top: -14,
                                      //                     right: -14.0,
                                      //                     child: IconButton(
                                      //                         onPressed: () {
                                      //                           if (context.read<VehiclePartsInteractionBloc>().state.mapMedia[state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name]!.images != null) {
                                      //                             context
                                      //                                 .read<VehiclePartsInteractionBloc>()
                                      //                                 .add(RemoveImageEvent(name: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, index: index));
                                      //                           }
                                      //                         },
                                      //                         icon: const CircleAvatar(
                                      //                           radius: 8,
                                      //                           backgroundColor: Colors.white,
                                      //                           child: Icon(
                                      //                             Icons.remove_circle_rounded,
                                      //                             color: Color.fromARGB(255, 167, 38, 38),
                                      //                             size: 16,
                                      //                           ),
                                      //                         )))
                                      //               ]);
                                      //             },
                                      //             itemCount: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images == null ? 0 : state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.length,
                                      //           )),
                                      //     );
                                      //   },
                                      // ),
                                      if (state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images != null && state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.isNotEmpty)
                                        InkWell(
                                          radius: isMobile ? size.width * 0.06 : size.width * 0.024,
                                          borderRadius: BorderRadius.circular(20),
                                          onTap: () {
                                            if (!isConnected()) {
                                              DMSCustomWidgets.DMSFlushbar(size, context,
                                                  message: 'Looks like you'
                                                      're offline. Please check your connection and try again',
                                                  icon: const Icon(
                                                    Icons.error,
                                                    color: Colors.white,
                                                  ));
                                              return;
                                            }
                                            // commentsFocus.unfocus();
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
                                                  bodyPartName: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, jobCardNo: context.read<ServiceBloc>().state.jobCardNo!
                                                  // 'JC-${context.read<ServiceBloc>().state.service!.location!.substring(0, 3).toUpperCase()}-${context.read<ServiceBloc>().state.service!.kms.toString().substring(0, 2)}'
                                                  ) as VehiclePartsInteractionBlocEvent);
                                            }
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: size.height * 0.04,
                                              width: isMobile ? size.width * 0.2 : size.width * 0.08,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                                const BoxShadow(
                                                    blurRadius: 8, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Color.fromRGBO(255, 204, 128, 1), offset: Offset(0, 0))
                                              ]),
                                              child: const Text(
                                                textAlign: TextAlign.center,
                                                'Upload',
                                                style: TextStyle(color: Colors.white, fontSize: 14),
                                              )),
                                        ),
                                      // const Gap(16)
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ))
            ],
          ),
        ));
  }
}
