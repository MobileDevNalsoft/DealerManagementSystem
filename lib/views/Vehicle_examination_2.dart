import 'dart:convert';
import 'dart:io';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc_2/vehicle_parts_interaction_bloc2.dart';
import 'package:dms/models/services.dart';
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

  late WebViewController webViewController;

  // bloc variables
  late VehiclePartsInteractionBloc2 _interactionBloc;
  late MultiBloc _multiBloc;
  late ServiceBloc _serviceBloc;
  late int index;
  List hotSpots = [];

  // method to load java script file
  Future<List<String>> loadJS() async {
    List<String> resources = [];
    resources.add(await rootBundle.loadString('assets/index.js'));
    resources.add(await rootBundle.loadString('assets/styles.css'));
    return resources;
  }

  @override
  void initState()  {
    super.initState();
    _interactionBloc = context.read<VehiclePartsInteractionBloc2>();
    _multiBloc = context.read<MultiBloc>();
    _serviceBloc = context.read<ServiceBloc>();
    _serviceBloc.state.service = Service(jobCardNo: "JC-LOC-99");
    _interactionBloc.state.mapMedia = {};
    
  }

  void _changeButtonColors(String name) async {
    await webViewController.runJavaScript('changeHotSpotColors("$name",true)');
  }

  void _removeButton(String name) async {
    await webViewController.runJavaScript('removeButton("$name")');
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
          _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
          _interactionBloc.add(AddHotspotEvent(name: data["name"]!, position: data["position"], normal: data["normal"]));
        } else if (data["type"] == "hotspot-click") {
           Haptics.vibrate(HapticsType.light);
          _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: data["name"]!, isTapped: true));
        }
        // bottom sheet for diaplying hotspots, comments and images
        showModalBottomSheet(
            context: context,
            elevation: 0,
            barrierColor: Colors.black.withOpacity(0.2),
            isDismissible: true,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(26, 26, 27, 1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                            width: size.width,
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
                                        _multiBloc.add(ModifyVehicleInteractionStatus(
                                            selectedBodyPart: hotSpots.elementAt(hotspotIndex).key, isTapped: _multiBloc.state.isTapped));
                                        _pageController.jumpToPage(hotspotIndex);
                                        _changeButtonColors(hotSpots.elementAt(hotspotIndex).key);
                                        state.vehicleExaminationPageIndex = hotspotIndex;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: state.vehicleExaminationPageIndex == hotspotIndex ? Colors.orange.shade200 : Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: state.vehicleExaminationPageIndex == hotspotIndex ? 0 : 5,
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
                                              hotSpots.elementAt(hotspotIndex).key.toString().replaceAll('-', ' '),
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
                                                          _multiBloc.add(ModifyRenamingStatus(renameStatus: HotspotRenamingStatus.initial));
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
                                                                            context.watch<MultiBloc>().state.renamingStatus == HotspotRenamingStatus.initial
                                                                                ? Text(
                                                                                    hotSpots.elementAt(hotspotIndex).key,
                                                                                    style: TextStyle(fontSize: isMobile ? 16 : 18),
                                                                                  )
                                                                                : Expanded(
                                                                                    child: TextFormField(
                                                                                      selectionControls: MaterialTextSelectionControls(),
                                                                                      controller:
                                                                                          TextEditingController(text: hotSpots.elementAt(hotspotIndex).key),
                                                                                      showCursor: true,
                                                                                      autofocus: true,
                                                                                      cursorColor: Colors.black,
                                                                                      style: TextStyle(fontSize: isMobile ? 16 : 18),
                                                                                      maxLines: 1,
                                                                                      decoration: InputDecoration(border: InputBorder.none),
                                                                                      onChanged: (value) async {
                                                                                        _multiBloc.state.renamedValue = value;
                                                                                        _multiBloc.state.renamingStatus = HotspotRenamingStatus.hotspotRenamed;
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                            Spacer(),
                                                                            if (context.watch<MultiBloc>().state.renamingStatus ==
                                                                                HotspotRenamingStatus.initial)
                                                                              Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      _multiBloc.add(ModifyRenamingStatus(
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
                                                                      borderRadius:
                                                                          BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            _removeButton(hotSpots.elementAt(hotspotIndex).key);
                                                                            int nextIndex=0;
                                                                            _interactionBloc
                                                                                .add(RemoveHotspotEvent(name: hotSpots.elementAt(hotspotIndex).key));
                                                                              if(hotspotIndex==0 && state.mapMedia.length > 1){
                                                                                  nextIndex = 1;
                                                                            }
                                                                            if (state.mapMedia.length >= 1) {
                                                                              _pageController.jumpToPage(nextIndex);
                                                                              _autoScrollController.scrollToIndex(nextIndex);
                                                                              state.vehicleExaminationPageIndex = hotspotIndex;
                                                                              _changeButtonColors(hotSpots.elementAt(nextIndex).key);
                                                                              _multiBloc.add(ModifyVehicleInteractionStatus(
                                                                                  selectedBodyPart: hotSpots.elementAt(nextIndex).key, isTapped: true));
                                                                              _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: nextIndex));
                                                                              Navigator.pop(context);
                                                                              if(hotspotIndex==0){
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
                                                                            if (_multiBloc.state.renamingStatus == HotspotRenamingStatus.hotspotRenamed) {
                                                                              var value = hotSpots.elementAt(hotspotIndex).value;
                                                                              _multiBloc.state.renamedValue =
                                                                                  _multiBloc.state.renamedValue!.trim().replaceAll(' ', '-');
                                                                              await webViewController
                                                                                  .runJavaScript(
                                                                                      'renameHotspot("${hotSpots.elementAt(hotspotIndex).key}","${_multiBloc.state.renamedValue}")')
                                                                                  .catchError((e) {
                                                                                print(e);
                                                                              });
                                                                              _interactionBloc.state.mapMedia.putIfAbsent(_multiBloc.state.renamedValue ?? "",
                                                                                  () {
                                                                                return value;
                                                                              });

                                                                              _interactionBloc.state.mapMedia[_multiBloc.state.renamedValue]!.name =
                                                                                  _multiBloc.state.renamedValue!;
                                                                              _interactionBloc.state.mapMedia.remove(hotSpots.elementAt(hotspotIndex).key);
                                                                              _multiBloc.state.selectedGeneralBodyPart = _multiBloc.state.renamedValue!;
                                                                              _pageController.jumpToPage(hotspotIndex);
                                                                              _autoScrollController.scrollToIndex(hotspotIndex);
                                                                              _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: hotspotIndex));
                                                                              _changeButtonColors(
                                                                                  _interactionBloc.state.mapMedia.entries.elementAt(hotspotIndex).key);
                                                                              _multiBloc.add(ModifyRenamingStatus(renameStatus: HotspotRenamingStatus.initial));
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
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const ScrollPhysics(),
                              onPageChanged: (value) {
                                _multiBloc
                                    .add(ModifyVehicleInteractionStatus(selectedBodyPart: hotSpots.elementAt(value).key, isTapped: _multiBloc.state.isTapped));
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
                                            Skeletonizer(
                                              enabled: context.watch<MultiBloc>().state.selectedGeneralBodyPart.isEmpty ||
                                                  !context.watch<MultiBloc>().state.isTapped,
                                              child: TextFormField(
                                                // key: _formKey,
                                                // focusNode: commentsFocus,
                                                controller: TextEditingController(
                                                    text: state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!.comments),
                                                // initialValue: state.mapMedia[context.watch<MultiBloc>().state.selectedGeneralBodyPart]!.comments,
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
                                                  _interactionBloc.add(
                                                      AddCommentsEvent(name: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name, comments: value));
                                                },
                                              ),
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
                                                        _interactionBloc.add(
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
                                          height: hotSpots.elementAt(pageIndex).value.images == null || hotSpots.elementAt(pageIndex).value.images!.isEmpty
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
                                                    File(hotSpots.elementAt(pageIndex).value.images![index].path),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: -14,
                                                    right: -14.0,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          if (context
                                                                  .read<VehiclePartsInteractionBloc2>()
                                                                  .state
                                                                  .mapMedia[state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name]!
                                                                  .images !=
                                                              null) {
                                                            _interactionBloc.add(RemoveImageEvent(
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
                                            itemCount:
                                                hotSpots.elementAt(pageIndex).value.images == null ? 0 : hotSpots.elementAt(pageIndex).value.images!.length,
                                          )),
                                      if (state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images != null &&
                                          state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.images!.isNotEmpty)
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
                                            if (state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.comments!.trim().isEmpty) {
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
                                              //use service.jobcard number
                                              _interactionBloc.add(SubmitBodyPartVehicleMediaEvent(
                                                  bodyPartName: state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name,
                                                  jobCardNo: _serviceBloc.state.service!.jobCardNo!
                                                  // 'JC-${_serviceBloc.state.service!.location!.substring(0, 3).toUpperCase()}-${_serviceBloc.state.service!.kms.toString().substring(0, 2)}'
                                                  ) as VehiclePartsInteractionBlocEvent2);
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
                                                  (hotSpots.last.key != state.mapMedia[_multiBloc.state.selectedGeneralBodyPart]!.name)
                                                      ? 'Upload'
                                                      : " Upload & Save",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                                )),
                                          ),
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
                ),
              );
            }).then(
          (value) async {
            _changeButtonColors("");
            //     _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: _multiBloc.state.selectedGeneralBodyPart, isTapped: false));
            //   await Future.delayed(Duration(milliseconds: 800));
            //  _multiBloc.add(ModifyVehicleInteractionStatus(selectedBodyPart: "", isTapped: false));
          },
        );
        await Future.delayed(Duration(milliseconds: 300));
        index = _interactionBloc.state.mapMedia.entries.toList().indexWhere((element) => element.key == data["name"]);
        _pageController.jumpToPage(index);
        _autoScrollController.scrollToIndex(index);
        _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: index));
      },
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Vehicle Examination'),
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
                  future: loadJS(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? SizedBox(
                            height: size.height * (0.4),
                            width: size.width * 0.98,
                            child: ModelViewer(
                              src: 'assets/3d_models/sedan.glb',
                              iosSrc: 'assets/3d_models/sedan.glb',
                              relatedJs: snapshot.data![0],
                              relatedCss: snapshot.data![1],
                              disableZoom: false,
                              autoRotate: false,
                              minCameraOrbit: '3m 3m auto', // Set minimum zoom (close)
                              maxCameraOrbit: 'auto 5m auto', // Set maximum zoom (far)

                              // scale: "1",
                              disableTap: true,
                              id: 'model',
                              onWebViewCreated: (value) {
                                webViewController = value;
                              },
                              javascriptChannels: {javascriptChannel},
                            ),
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
