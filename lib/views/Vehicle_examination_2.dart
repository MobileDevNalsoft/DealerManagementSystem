import 'dart:convert';
import 'dart:io';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc_2/vehicle_parts_interaction_bloc2.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/services.dart';
import 'package:dms/models/vehicle_parts_media2.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VehicleExamination2 extends StatefulWidget {
  const VehicleExamination2({super.key});

  @override
  State<VehicleExamination2> createState() => _VehicleExamination2State();
}

class _VehicleExamination2State extends State<VehicleExamination2> with ConnectivityMixin {
  // related to UI when tapped on 3D model hotspot
  final PageController _pageController = PageController(initialPage: 0);
  final AutoScrollController _autoScrollController = AutoScrollController();
  Vibration vibration = Vibration();
  FocusNode commentsFocus = FocusNode();
  TextEditingController commentsController = TextEditingController();
  final NavigatorService navigator = getIt<NavigatorService>();

  late WebViewController webViewController;

  // bloc variables
  late VehiclePartsInteractionBloc2 _interactionBloc;
  // late VehiclePartsInteractionBloc2 _interactionBloc;
  late ServiceBloc _serviceBloc;
  late int index;
  late Future _resources;
  List hotSpots = [];

  // method to load java script file
  Future<List<String>> loadJS() async {
    List<String> resources = [];
    resources.add(await rootBundle.loadString('assets/index.js'));
    resources.add(await rootBundle.loadString('assets/styles.css'));
    return resources;
  }

  @override
  void initState() {
    super.initState();
    _resources = loadJS();
    _interactionBloc = context.read<VehiclePartsInteractionBloc2>();
    // _interactionBloc = context.read<VehiclePartsInteractionBloc2>();
    _serviceBloc = context.read<ServiceBloc>();
    _interactionBloc.state.mapMedia = {};
  }

  void _changeButtonColors(String name) async {
    await webViewController.runJavaScript('changeHotSpotColors("$name",true)');
  }

  void _removeButton(String name) async {
    await webViewController.runJavaScript('removeButton("$name")');
  }

  void getBottomSheet(BuildContext context, Size size, bool isMobile) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        barrierColor: Colors.black.withOpacity(0.2),
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: context.watch<VehiclePartsInteractionBloc2>().state.status == VehiclePartsInteractionStatus.loading,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(26, 26, 27, 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(size.width * 0.064), topRight: Radius.circular(size.width * 0.064)),
                    ),
                    height: size.height * 0.48,
                    width: size.width,
                    child: BlocBuilder<VehiclePartsInteractionBloc2, VehiclePartsInteractionBlocState2>(
                      builder: (context, state) {
                        hotSpots = state.mapMedia.entries.toList();
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Drag handle at the top
                            Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                height: 4,
                                width: size.width * 0.1,
                                padding: EdgeInsets.zero,
                              ),
                            ),

                            // hotspots in horizontal list view
                            SizedBox(
                              height: size.height * 0.064,
                              width: size.width * 0.98,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(size.width * 0.14),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: _autoScrollController,
                                    itemBuilder: (context, hotspotIndex) {
                                      return AutoScrollTag(
                                        key: ValueKey(hotspotIndex),
                                        controller: _autoScrollController,
                                        index: hotspotIndex,
                                        child: InkWell(
                                          onTap: () {
                                            _interactionBloc.add(ModifyVehicleInteractionStatus(
                                                selectedBodyPart: (hotSpots.elementAt(hotspotIndex)).key, isTapped: _interactionBloc.state.isTapped));
                                            _pageController.jumpToPage(hotspotIndex);
                                            _changeButtonColors(hotSpots.elementAt(hotspotIndex).key);
                                            state.vehicleExaminationPageIndex = hotspotIndex;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(size.width * 16),
                                                color: state.vehicleExaminationPageIndex == hotspotIndex ? Colors.orange.shade200 : Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: state.vehicleExaminationPageIndex == hotspotIndex ? 0 : 5,
                                                      blurStyle: BlurStyle.outer,
                                                      spreadRadius: 0,
                                                      color: Colors.orange.shade200,
                                                      offset: const Offset(0, 0))
                                                ]),
                                            margin: EdgeInsets.only(
                                                top: size.width * 0.02,
                                                bottom: size.width * 0.02,
                                                right: size.width * 0.016,
                                                left: hotspotIndex == 0 ? size.width * 0.032 : 0),
                                            child: Center(
                                                child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Gap(size.width * 0.024),
                                                Text(
                                                  hotSpots.elementAt(hotspotIndex).value.name.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),

                                                //For renaming the hotspot
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return PopScope(
                                                            canPop: true,
                                                            onPopInvoked: (didPop) {
                                                              _interactionBloc.add(ModifyRenamingStatus(renameStatus: HotspotRenamingStatus.initial));
                                                            },
                                                            child: AlertDialog(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                contentPadding: EdgeInsets.only(top: size.height * 0.01),
                                                                content: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: size.width * (isMobile ? 0.03 : 0.02)),
                                                                        child: Theme(
                                                                          data: Theme.of(context).copyWith(),
                                                                          child: SizedBox(
                                                                            height: size.height * 0.05,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                context.watch<VehiclePartsInteractionBloc2>().state.renamingStatus ==
                                                                                        HotspotRenamingStatus.initial
                                                                                    ? Text(
                                                                                        hotSpots.elementAt(hotspotIndex).value.name,
                                                                                        style: TextStyle(fontSize: isMobile ? 16 : 18),
                                                                                      )
                                                                                    : Expanded(
                                                                                        child: TextFormField(
                                                                                          selectionControls: MaterialTextSelectionControls(),
                                                                                          controller: TextEditingController(
                                                                                              text: hotSpots.elementAt(hotspotIndex).value.name),
                                                                                          showCursor: true,
                                                                                          autofocus: true,
                                                                                          cursorColor: Colors.black,
                                                                                          style: TextStyle(fontSize: isMobile ? 16 : 18),
                                                                                          maxLines: 1,
                                                                                          decoration: InputDecoration(border: InputBorder.none),
                                                                                          onChanged: (value) async {
                                                                                            _interactionBloc.state.renamedValue = value;
                                                                                            _interactionBloc.state.renamingStatus =
                                                                                                HotspotRenamingStatus.hotspotRenamed;
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                Spacer(),
                                                                                if (context.watch<VehiclePartsInteractionBloc2>().state.renamingStatus ==
                                                                                    HotspotRenamingStatus.initial)
                                                                                  Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: IconButton(
                                                                                        onPressed: () {
                                                                                          _interactionBloc.add(ModifyRenamingStatus(
                                                                                              renameStatus: HotspotRenamingStatus.openTextField));
                                                                                        },
                                                                                        icon: Icon(Icons.edit_rounded)),
                                                                                  )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    Gap(size.height * 0.01),
                                                                    Container(
                                                                      height: size.height * 0.05,
                                                                      margin: EdgeInsets.all(size.height * 0.001),
                                                                      decoration: const BoxDecoration(
                                                                          color: Colors.black,
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: TextButton(
                                                                              onPressed: () {
                                                                                _removeButton(hotSpots.elementAt(hotspotIndex).key);
                                                                                int nextIndex = 0;
                                                                                _interactionBloc
                                                                                    .add(RemoveHotspotEvent(name: hotSpots.elementAt(hotspotIndex).key));
                                                                                if (hotspotIndex == 0 && state.mapMedia.length > 1) {
                                                                                  nextIndex = 1;
                                                                                }
                                                                                if (state.mapMedia.length >= 1) {
                                                                                  _pageController.jumpToPage(nextIndex);
                                                                                  _autoScrollController.scrollToIndex(nextIndex);
                                                                                  state.vehicleExaminationPageIndex = hotspotIndex;
                                                                                  _changeButtonColors(hotSpots.elementAt(nextIndex).key);
                                                                                  _interactionBloc.add(ModifyVehicleInteractionStatus(
                                                                                      selectedBodyPart: hotSpots.elementAt(nextIndex).key, isTapped: true));
                                                                                  _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: nextIndex));
                                                                                  Navigator.pop(context);
                                                                                  if (hotspotIndex == 0) {
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                }
                                                                              },
                                                                              style: TextButton.styleFrom(
                                                                                  fixedSize: Size(size.width * 0.3, size.height * 0.1),
                                                                                  foregroundColor: Colors.white),
                                                                              child: Text(
                                                                                'Delete',
                                                                                style: TextStyle(fontSize: isMobile ? 14 : 18),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const VerticalDivider(
                                                                            color: Colors.white,
                                                                            thickness: 0.5,
                                                                          ),
                                                                          Expanded(
                                                                            child: TextButton(
                                                                              onPressed: () async {
                                                                                if (state.vehicleExaminationPageIndex != hotspotIndex) {
                                                                                  _autoScrollController.scrollToIndex(hotspotIndex);
                                                                                  _pageController.jumpToPage(hotspotIndex);
                                                                                  state.vehicleExaminationPageIndex = hotspotIndex;
                                                                                  _changeButtonColors(hotSpots.elementAt(hotspotIndex).key);
                                                                                }
                                                                                if (_interactionBloc.state.renamingStatus ==
                                                                                    HotspotRenamingStatus.hotspotRenamed) {
                                                                                  var value = hotSpots.elementAt(hotspotIndex).value;
                                                                                  _interactionBloc.state.renamedValue =
                                                                                      _interactionBloc.state.renamedValue!.trim().replaceAll(' ', '-');
                                                                                  // await webViewController
                                                                                  //     .runJavaScript(
                                                                                  //         'renameHotspot("${hotSpots.elementAt(hotspotIndex).key}","${_interactionBloc.state.renamedValue}")')
                                                                                  //     .catchError((e) {
                                                                                  //   print(e);
                                                                                  // });
                                                                                  // _interactionBloc.state.mapMedia.putIfAbsent(_interactionBloc.state.renamedValue ?? "",
                                                                                  //     () {
                                                                                  //   return value;
                                                                                  // });

                                                                                  // _interactionBloc.state.mapMedia[_interactionBloc.state.renamedValue]!.name =
                                                                                  //     _interactionBloc.state.renamedValue!;
                                                                                  // _interactionBloc.state.mapMedia.remove(hotSpots.elementAt(hotspotIndex).key);
                                                                                  // _interactionBloc.state.selectedGeneralBodyPart = _interactionBloc.state.renamedValue!;
                                                                                  _interactionBloc.state.mapMedia[hotSpots.elementAt(hotspotIndex).key]!.name =
                                                                                      _interactionBloc.state.renamedValue!;
                                                                                  _interactionBloc.state.selectedBodyPart =
                                                                                      hotSpots.elementAt(hotspotIndex).key;
                                                                                  _pageController.jumpToPage(hotspotIndex);
                                                                                  _autoScrollController.scrollToIndex(hotspotIndex);
                                                                                  _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: hotspotIndex));
                                                                                  _changeButtonColors(
                                                                                      _interactionBloc.state.mapMedia.entries.elementAt(hotspotIndex).key);
                                                                                  _interactionBloc
                                                                                      .add(ModifyRenamingStatus(renameStatus: HotspotRenamingStatus.initial));
                                                                                  _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: hotspotIndex));
                                                                                }
                                                                                Navigator.pop(context);
                                                                              },
                                                                              style: TextButton.styleFrom(
                                                                                  fixedSize: Size(size.width * 0.3, size.height * 0.1),
                                                                                  foregroundColor: Colors.white),
                                                                              child: Text(
                                                                                'Done',
                                                                                style: TextStyle(fontSize: isMobile ? 14 : 18),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                actionsPadding: EdgeInsets.zero,
                                                                buttonPadding: EdgeInsets.zero),
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(
                                                      hotSpots.elementAt(hotspotIndex).value.isUploaded == false ? Icons.settings_rounded : Icons.done_rounded),
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
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                physics: const ScrollPhysics(),
                                onPageChanged: (value) {
                                  _interactionBloc.add(ModifyVehicleInteractionStatus(
                                      selectedBodyPart: hotSpots.elementAt(value).key, isTapped: _interactionBloc.state.isTapped));
                                  _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: value));
                                  _autoScrollController.scrollToIndex(value,
                                      duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
                                  _changeButtonColors(hotSpots.elementAt(value).key);
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
                                    child: LayoutBuilder(builder: (context, constraints) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Gap(8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            height: size.height * 0.15,
                                            //  width: size.width * 0.65,
                                            child: Stack(
                                              children: [
                                                Skeletonizer(
                                                  enabled: state.selectedBodyPart!.isEmpty || !state.isTapped!,
                                                  child: TextFormField(
                                                    // key: _formKey,
                                                    // focusNode: commentsFocus,
                                                    controller: TextEditingController(text: state.mapMedia[state.selectedBodyPart]!.comments),
                                                    // initialValue: state.mapMedia[context.watch<VehiclePartsInteractionBloc2>().state.selectedGeneralBodyPart]!.comments,
                                                    maxLines: 5,
                                                    cursorColor: Colors.white,
                                                    style: const TextStyle(color: Colors.white),
                                                    decoration: InputDecoration(
                                                        hintStyle: const TextStyle(fontSize: 16, color: Colors.white60),
                                                        fillColor: const Color.fromRGBO(38, 38, 40, 1),
                                                        filled: true,
                                                        contentPadding: const EdgeInsets.only(left: 16, top: 16),
                                                        hintText: "Comments",
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          borderSide: const BorderSide(
                                                            color: Color.fromARGB(255, 145, 95, 22),
                                                          ),
                                                        ),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                                                    onChanged: (value) {
                                                      _interactionBloc.add(AddCommentsEvent(
                                                        name: _interactionBloc.state.selectedBodyPart!,
                                                        comments: value,
                                                      ));
                                                    },
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: IconButton(
                                                      padding: isMobile ? EdgeInsets.zero : EdgeInsets.only(bottom: size.height * 0.032),
                                                      onPressed: () async {
                                                        // commentsFocus.unfocus();
                                                        if (state.mapMedia[_interactionBloc.state.selectedBodyPart]!.images!.length < 3) {
                                                          ImagePicker imagePicker = ImagePicker();

                                                          XFile? image =
                                                              await imagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
                                                          if (image != null) {
                                                            _interactionBloc.add(AddImageEvent(name: _interactionBloc.state.selectedBodyPart!, image: image));
                                                          }
                                                          print('images ${hotSpots.elementAt(pageIndex).value.images}');
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
                                          if (hotSpots.elementAt(pageIndex).value.images != null && hotSpots.elementAt(pageIndex).value.images.length != 0)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              height: hotSpots.elementAt(pageIndex).value.images == null || hotSpots.elementAt(pageIndex).value.images!.isEmpty
                                                  ? 0
                                                  : isMobile
                                                      ? size.height * 0.14
                                                      : size.height * 0.16,
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: hotSpots
                                                    .elementAt(pageIndex)
                                                    .value
                                                    .images
                                                    .map<Widget>((image) => Padding(
                                                          padding: EdgeInsets.all(constraints.maxWidth * 0.014),
                                                          child: Stack(
                                                            children: [
                                                              SizedBox(
                                                                // height: constraints.maxHeight*0.5,
                                                                width: constraints.maxWidth * 0.28,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  child: Image.file(
                                                                    File(image.path),
                                                                    fit: BoxFit.fill,
                                                                    // scale: size.width * 0.002,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: -14,
                                                                right: -14.0,
                                                                child: IconButton(
                                                                  onPressed: () {
                                                                    if (state.mapMedia[_interactionBloc.state.selectedBodyPart]!.images != null) {
                                                                      _interactionBloc
                                                                          .add(RemoveImageEvent(name: _interactionBloc.state.selectedBodyPart!, image: image));
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
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),

                                          Gap(size.height * 0.02),
                                          if (state.mapMedia[_interactionBloc.state.selectedBodyPart]!.images != null &&
                                              state.mapMedia[_interactionBloc.state.selectedBodyPart]!.images!.isNotEmpty)
                                            InkWell(
                                              radius: isMobile ? size.width * 0.06 : size.width * 0.024,
                                              borderRadius: BorderRadius.circular(20),
                                              onTap: () {
                                                commentsFocus.requestFocus();
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
                                                if (state.mapMedia[_interactionBloc.state.selectedBodyPart]!.comments!.trim().isEmpty) {
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
                                                  //use service.jobcard number
                                                  _interactionBloc.add(SubmitBodyPartVehicleMediaEvent(
                                                    bodyPartName: _interactionBloc.state.selectedBodyPart!,
                                                    serviceBookingNo: _serviceBloc.state.service!.serviceBookingNo!,
                                                  ) as VehiclePartsInteractionBlocEvent2);
                                                  if (hotSpots.last.key == _interactionBloc.state.selectedBodyPart) {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              child: IntrinsicWidth(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * 0.04,
                                                    padding: const EdgeInsets.all(8.0),
                                                    // width: isMobile ? size.width * 0.2 : size.width * 0.08,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 8,
                                                          blurStyle: BlurStyle.outer,
                                                          spreadRadius: 0,
                                                          color: Color.fromRGBO(255, 204, 128, 1),
                                                          offset: Offset(0, 0))
                                                    ]),
                                                    child: Text(
                                                      (hotSpots.last.key != _interactionBloc.state.selectedBodyPart) ? 'Upload' : " Upload & Save",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                                    )),
                                              ),
                                            ),
                                          // const Gap(16)
                                        ],
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (context.watch<VehiclePartsInteractionBloc2>().state.status == VehiclePartsInteractionStatus.loading)
                Positioned(
                  left: 200,
                  top: 200,
                  bottom: 200,
                  right: 200,
                  child: Lottie.asset(
                    'assets/lottie/car_loading.json',
                    // height: isMobile ? size.height * 0.2 : size.height * 0.32, width: isMobile ? size.width * 0.2 : size.width * 0.32
                  ),
                )
            ],
          );
        }).then(
      (value) async {
        _changeButtonColors("");
        //     _interactionBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: _interactionBloc.state.selectedGeneralBodyPart, isTapped: false));
        //   await Future.delayed(Duration(milliseconds: 800));
        //  _interactionBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // for responsive UI
    Size size = MediaQuery.sizeOf(context);
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    final javascriptChannel = JavascriptChannel(
      'flutterChannel',
      onMessageReceived: (message) async {
        Map<String, dynamic> data = jsonDecode(message.message);

        if (data["type"] == "hotspot-create") {
          _interactionBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
          _interactionBloc.add(AddHotspotEvent(name: data["name"]!, position: data["position"], normal: data["normal"]));
        } else if (data["type"] == "hotspot-click") {
          Haptics.vibrate(HapticsType.light);
          _interactionBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
        }
        // bottom sheet for diaplying hotspots, comments and images
        getBottomSheet(context, size, isMobile);
        await Future.delayed(Duration(milliseconds: 300));
        index = _interactionBloc.state.mapMedia.entries.toList().indexWhere((element) => element.key == data["name"]);
        _pageController.jumpToPage(index);
        _autoScrollController.scrollToIndex(index);
        _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: index));
      },
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Vehicle Examination', actions: [
          Container(
            margin: EdgeInsets.only(right: size.width * 0.024),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -5, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
            child: Switch(
              value: true,
              onChanged: (value) {
                _interactionBloc.state.selectedBodyPart = "";
                _interactionBloc.state.isTapped = false;
                navigator.pushReplacement('/vehicleExamination');
              },
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.black,
              trackOutlineColor: const WidgetStatePropertyAll(Colors.black),
            ),
          )
        ]),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black45, Color.fromARGB(40, 104, 103, 103), Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.5, 1])),
          child: Stack(
            children: [
              FutureBuilder(
                  future: _resources,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Column(
                            children: [
                              SizedBox(
                                height: size.height * (0.4),
                                width: size.width * 0.98,
                                child: ModelViewer(
                                  src: 'assets/3d_models/sedan.glb',
                                  iosSrc: 'assets/3d_models/sedan.glb',
                                  interactionPrompt: InteractionPrompt.none,
                                  relatedJs: snapshot.data![0],
                                  relatedCss: snapshot.data![1],
                                  disableZoom: true,
                                  autoRotate: false,
                                  disableTap: true,
                                  id: 'model',
                                  onWebViewCreated: (value) {
                                    webViewController = value;
                                  },
                                  javascriptChannels: {javascriptChannel},
                                ),
                              ),
                              Spacer(),
                              IntrinsicWidth(
                                child: InkWell(
                                  onTap: () async {
                                    List hotspotsData = _interactionBloc.state.mapMedia.entries.toList();
                                    if (hotspotsData.isEmpty) {
                                      DMSCustomWidgets.DMSFlushbar(size, context,
                                          message: "Please add atleast one hotspot",
                                          icon: Icon(
                                            Icons.error_rounded,
                                            color: Colors.white,
                                          ));
                                      return;
                                    }
                                    int elementIndex = 0;
                                    for (var e in hotspotsData) {
                                      if (e.value.isUploaded == false) {
                                        DMSCustomWidgets.DMSFlushbar(size, context,
                                            message: "Please upload ${e.value.name} data",
                                            icon: Icon(
                                              Icons.error_rounded,
                                              color: Colors.white,
                                            ));
                                        getBottomSheet(context, size, isMobile);
                                        _changeButtonColors(e.key);
                                        await Future.delayed(Duration(milliseconds: 300));
                                        _pageController.jumpToPage(elementIndex);
                                        _autoScrollController.scrollToIndex(elementIndex);
                                        _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: elementIndex));
                                        _interactionBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: e.key, isTapped: true));
                                        return;
                                      }
                                      elementIndex++;
                                    }
                                    _interactionBloc.state.mapMedia = {};
                                    navigator.pushAndRemoveUntil('/listOfJobCards', '/home');
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: size.height * 0.044,
                                      width: size.width * 0.24,
                                      margin: EdgeInsets.only(bottom: size.height * 0.16),
                                      // padding:  EdgeInsets.symmetric(horizontal: size.width*0.036),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 8,
                                            blurStyle: BlurStyle.outer,
                                            spreadRadius: 0,
                                            color: Color.fromRGBO(255, 204, 128, 1),
                                            offset: Offset(0, 0))
                                      ]),
                                      child: Text(
                                        'Save',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      )),
                                ),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator();
                  }),
              if (context.watch<VehiclePartsInteractionBloc2>().state.status == VehiclePartsInteractionStatus.loading)
                Container(
                  color: Colors.black54,
                  child: Center(
                      child: Lottie.asset('assets/lottie/car_loading.json',
                          height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
                )
            ],
          ),
        ));
  }
}
