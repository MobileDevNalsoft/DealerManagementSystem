import 'dart:convert';
import 'dart:io';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc_2/vehicle_parts_interaction_bloc2.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/custom_slider_button.dart';
import 'package:dms/views/quality_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QualityCheck2 extends StatefulWidget {
  const QualityCheck2({super.key});

  @override
  State<QualityCheck2> createState() => _QualityCheck2State();
}

class _QualityCheck2State extends State<QualityCheck2> with ConnectivityMixin, TickerProviderStateMixin {
  // related to UI when tapped on 3D model hotspot
  final ScrollController _listController = ScrollController();
  final AutoScrollController _autoScrollController = AutoScrollController();

  final SliderButtonController _sliderButtonController = SliderButtonController();

  List<TextEditingController>? textControllers;

  DraggableScrollableController draggableScrollableController = DraggableScrollableController();

  FocusNode commentsFocus = FocusNode();
  TextEditingController commentsController = TextEditingController();

  late WebViewController webViewController;

  List hotSpots = [];

  // bloc variables
  late VehiclePartsInteractionBloc2 _interactionBloc;
  late MultiBloc _multiBloc;
  late ServiceBloc _serviceBloc;

  Size size = const Size(0, 0);

  double dragStart = 0;
  double dragEnd = 0;

  // navigator service
  NavigatorService navigator = getIt<NavigatorService>();

  // method to load java script file
  Future<String> loadJS() async {
    return await rootBundle.loadString('assets/quality.js');
  }

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // for animation
  late AnimationController animationController;
  late Animation<double> animation;
  late Tween<double> tween;

  @override
  void initState() {
    super.initState();
    _interactionBloc = context.read<VehiclePartsInteractionBloc2>();
    _multiBloc = context.read<MultiBloc>();
    _serviceBloc = context.read<ServiceBloc>();
    _interactionBloc.add(FetchVehicleMediaEvent(jobCardNo: _serviceBloc.state.service!.jobCardNo!));
    tween = Tween(begin: 0.0, end: (sharedPreferences.getBool('isMobile') ?? true ? 0.8 : 1));
    animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn).drive(tween);
    animationController.forward();
  }

  // dispose controller to avoid data leaks
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void updateButtonsList(int index) {
    if (index >= 0 && index < hotSpots.length) {
      _interactionBloc.add(BodyPartSelected(selectedBodyPart: hotSpots.elementAt(index).key));
      _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: index));
      _autoScrollController.scrollToIndex(index, duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
      _changeButtonColors(hotSpots.elementAt(index).key, true);
    }
  }

  void _changeButtonColors(String name, bool rotate) async {
    await webViewController.runJavaScript('changeHotSpotColors("$name", $rotate)');
  }

  @override
  Widget build(BuildContext context) {
    // for responsive UI
    size = MediaQuery.sizeOf(context);
    print('width ${size.width}');
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    final JavascriptChannel qualityChannel = JavascriptChannel(
      'qualityChannel',
      onMessageReceived: (message) {
        Map<String, dynamic> data = jsonDecode(message.message);

        if (data["type"] == "hotspot-create") {
          // _interactionBloc.add(AddHotspotEvent(name: data["name"]!, position: data["position"], normal: data["normal"]));

          // if (_pageController.hasClients) {
          //   int index = _interactionBloc.state.mapMedia.length + 1;
          //   _pageController.jumpToPage(index);
          //   _autoScrollController.scrollToIndex(index);
          // }
        } else if (data["type"] == "hotspot-click") {
          _interactionBloc.add(BodyPartSelected(selectedBodyPart: data["name"]!));
          int index = _interactionBloc.state.mapMedia.entries.toList().indexWhere((element) => element.key == data["name"]);
          _interactionBloc.add(ModifyVehicleExaminationPageIndex(index: index));
          _autoScrollController.scrollToIndex(index);
          if (index > _interactionBloc.state.vehicleExaminationPageIndex) {
            _listController.animateTo(_listController.offset + (index - _interactionBloc.state.vehicleExaminationPageIndex) * size.width,
                duration: const Duration(milliseconds: 500), curve: Curves.ease);
          } else {
            _listController.animateTo(_listController.offset - (-index + _interactionBloc.state.vehicleExaminationPageIndex) * size.width,
                duration: const Duration(milliseconds: 500), curve: Curves.ease);
          }
        }
      },
    );

    return PopScope(
      onPopInvoked: (didPop) => animationController.stop(),
      child: Scaffold(
          appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Quality Check'),
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
                          ? BlocListener<VehiclePartsInteractionBloc2, VehiclePartsInteractionBlocState2>(
                              listenWhen: (previous, current) => previous.status != current.status,
                              listener: (context, state) {
                                if (state.mediaJsonStatus == MediaJsonStatus.success) {
                                  state.mapMedia
                                      .forEach((e, v) => webViewController.runJavaScript('receiveHotspots("$e","${v.dataPosition}", "${v.normalPosition}")'));
                                  _changeButtonColors(state.mapMedia.entries.first.key, false);
                                }
                              },
                              child: SizedBox(
                                height: size.height * 0.4,
                                width: size.width * 0.98,
                                child: ModelViewer(
                                  src: 'assets/3d_models/sedan.glb',
                                  iosSrc: 'assets/3d_models/sedan.glb',
                                  relatedJs: snapshot.data,
                                  disableTap: true,
                                  interactionPrompt: InteractionPrompt.none,
                                  disableZoom: true,
                                  id: 'quality',
                                  onWebViewCreated: (value) async {
                                    webViewController = value;
                                  },
                                  javascriptChannels: {qualityChannel},
                                ),
                              ),
                            )
                          : Center(
                              child: Lottie.asset('assets/lottie/car_loading.json',
                                  height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                            );
                    }),
                BlocBuilder<VehiclePartsInteractionBloc2, VehiclePartsInteractionBlocState2>(
                  builder: (context, state) {
                    switch (state.mediaJsonStatus) {
                      case MediaJsonStatus.success:
                        hotSpots = state.mapMedia.entries.toList();

                        return DraggableScrollableSheet(
                          controller: draggableScrollableController,

                          // snap: true,
                          // snapAnimationDuration: const Duration(milliseconds: 500),
                          // shouldCloseOnMinExtent: true,
                          minChildSize: 0.48,
                          // Bottom sheet sizes
                          maxChildSize: 1,
                          initialChildSize: 0.48,
                          // snapSizes: [],
                          builder: (context, scrollController) {
                            return Container(
                              height: size.height * 0.2,
                              width: size.width,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(26, 26, 27, 1),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                              child: CustomScrollView(
                                controller: scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Gap(size.width * 0.455),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          height: size.height * 0.006,
                                          width: size.width * 0.1,
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.symmetric(vertical: size.height * 0.006),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: size.height * 0.06,
                                      width: size.width * 0.98,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1000),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            controller: _autoScrollController,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return AutoScrollTag(
                                                key: ValueKey(index),
                                                controller: _autoScrollController,
                                                index: index,
                                                child: InkWell(
                                                  onTap: () {
                                                    _interactionBloc.add(BodyPartSelected(selectedBodyPart: hotSpots.elementAt(index).key));
                                                    _changeButtonColors(hotSpots.elementAt(index).key, true);
                                                    _autoScrollController.scrollToIndex(index);
                                                    if (index > state.vehicleExaminationPageIndex) {
                                                      _listController.animateTo(
                                                          _listController.offset + (index - state.vehicleExaminationPageIndex) * size.width,
                                                          duration: const Duration(milliseconds: 500),
                                                          curve: Curves.ease);
                                                    } else {
                                                      _listController.animateTo(
                                                          _listController.offset - (-index + state.vehicleExaminationPageIndex) * size.width,
                                                          duration: const Duration(milliseconds: 500),
                                                          curve: Curves.ease);
                                                    }
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
                                                    margin: EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.height * 0.005),
                                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      hotSpots.elementAt(index).key,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: state.mapMedia.length),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: size.height * 0.78,
                                      width: size.width * 0.9,
                                      child: ListView(
                                        controller: _listController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: state.mapMedia.entries.map((e) {
                                          if (e.value.isAccepted == null) {
                                            _sliderButtonController.position = Position.middle;
                                          } else if (e.value.isAccepted != null && e.value.isAccepted! == true) {
                                            _sliderButtonController.position = Position.right;
                                          } else {
                                            _sliderButtonController.position = Position.left;
                                          }
                                          return !state.mapMedia.containsKey(context.watch<VehiclePartsInteractionBloc2>().state.selectedGeneralBodyPart)
                                              ? const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "No data found",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.white54),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                                  onHorizontalDragStart: (details) {
                                                    dragStart = details.localPosition.dx;
                                                  },
                                                  onHorizontalDragEnd: (details) {
                                                    dragEnd = details.localPosition.dx;
                                                    if (dragStart > dragEnd + 50) {
                                                      updateButtonsList(((_listController.offset / size.width) + 1).toInt());
                                                      _listController.animateTo(_listController.offset + size.width,
                                                          duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                    } else if (dragStart < dragEnd - 50) {
                                                      updateButtonsList(((_listController.offset / size.width) - 1).toInt());
                                                      _listController.animateTo(_listController.offset - size.width,
                                                          duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                    }
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.all(size.width * 0.05),
                                                      margin: EdgeInsets.zero,
                                                      width: isMobile ? size.width : size.width * 0.32,
                                                      child: Stack(
                                                        children: [
                                                          CustomScrollView(
                                                            controller: scrollController,
                                                            slivers: [
                                                              SliverToBoxAdapter(
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Transform.translate(
                                                                      offset: Offset(0, size.height * 0.005),
                                                                      child: const CircleAvatar(
                                                                        radius: 6,
                                                                        backgroundColor: Colors.white,
                                                                      ),
                                                                    ),
                                                                    Gap(size.width * 0.02),
                                                                    Expanded(
                                                                      child: Text(
                                                                          context.watch<VehiclePartsInteractionBloc2>().state.mapMedia[context
                                                                                      .watch<VehiclePartsInteractionBloc2>()
                                                                                      .state
                                                                                      .selectedGeneralBodyPart] ==
                                                                                  null
                                                                              ? "No data"
                                                                              : e.value.comments!,
                                                                          style: TextStyle(
                                                                              color: const Color.fromARGB(255, 223, 220, 220), fontSize: size.width * 0.040)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SliverGap(size.height * 0.03),
                                                              SliverGrid.builder(
                                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount: 3, crossAxisSpacing: size.width * 0.02),
                                                                  itemCount: context
                                                                              .watch<VehiclePartsInteractionBloc2>()
                                                                              .state
                                                                              .mapMedia[
                                                                                  context.watch<VehiclePartsInteractionBloc2>().state.selectedGeneralBodyPart]!
                                                                              .images ==
                                                                          null
                                                                      ? 0
                                                                      : e.value.images!.length,
                                                                  itemBuilder: (context, index) => ClipRRect(
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
                                                                                        itemCount: e.value.images == null ? 0 : e.value.images!.length,
                                                                                        builder: (BuildContext context, int index) {
                                                                                          return PhotoViewGalleryPageOptions(
                                                                                            disableGestures: false,
                                                                                            maxScale: 1.5,
                                                                                            filterQuality: FilterQuality.high,
                                                                                            basePosition: Alignment.center,
                                                                                            imageProvider: FileImage(
                                                                                              File(e.value.images![index].path),
                                                                                            ),
                                                                                            initialScale: PhotoViewComputedScale.contained * 0.8,
                                                                                            heroAttributes:
                                                                                                PhotoViewHeroAttributes(tag: e.value.images![index].path),
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
                                                                            File(e.value.images![index].path),
                                                                            fit: BoxFit.fitWidth,
                                                                          ),
                                                                        ),
                                                                      )),
                                                              SliverGap(size.height * 0.03),
                                                              SliverToBoxAdapter(
                                                                  child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    controller: TextEditingController(),
                                                                    maxLines: 5,
                                                                    style: const TextStyle(color: Colors.white),
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
                                                                      state.mapMedia[context.read<MultiBloc>().state.selectedGeneralBodyPart]!
                                                                          .reasonForRejection = value;
                                                                    },
                                                                  ),
                                                                  Gap(size.height * 0.03),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                    },
                                                                    child: Container(
                                                                        alignment: Alignment.center,
                                                                        height: 32,
                                                                        width: size.width * 0.2,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: Colors.black,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                  blurRadius: 5,
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
                                                              )),
                                                              if (MediaQuery.of(context).viewInsets.bottom > 0) SliverGap(size.height * 0.3),
                                                            ],
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            left: size.width * 0.2,
                                                            child: CustomSliderButton(
                                                                controller: _sliderButtonController,
                                                                height: size.height * 0.065,
                                                                width: size.width * 0.5,
                                                                onLeftLabelReached: () {
                                                                  print('selected part ${state.selectedGeneralBodyPart}');
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _interactionBloc.state.selectedGeneralBodyPart, isAccepted: false));
                                                                },
                                                                onRightLabelReached: () {
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _interactionBloc.state.selectedGeneralBodyPart, isAccepted: true));
                                                                },
                                                                onNoStatus: () {
                                                                  _interactionBloc.add(ModifyAcceptedEvent(
                                                                      bodyPartName: _interactionBloc.state.selectedGeneralBodyPart, isAccepted: null));
                                                                },
                                                                leftLabel: Text(
                                                                  'Rejected',
                                                                  style: TextStyle(fontSize: size.height * 0.015),
                                                                ),
                                                                rightLabel: Text('Accepted', style: TextStyle(fontSize: size.height * 0.015))),
                                                          )
                                                        ],
                                                      )),
                                                );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      default:
                        return SizedBox();
                    }
                  },
                ),
                if (context.watch<VehiclePartsInteractionBloc2>().state.mediaJsonStatus == MediaJsonStatus.loading)
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Center(
                      child: Lottie.asset('assets/lottie/car_loading.json',
                          height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
