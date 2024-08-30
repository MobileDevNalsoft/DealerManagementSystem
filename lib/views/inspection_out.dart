import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/custom_slider_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../bloc/service/service_bloc.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class InspectionOut extends StatefulWidget {
  const InspectionOut({super.key});

  @override
  State<InspectionOut> createState() => _InspectionOutState();
}

class _InspectionOutState extends State<InspectionOut> with ConnectivityMixin {
  // controllers
  final PageController _pageController = PageController();
  final AutoScrollController _autoScrollController = AutoScrollController();
  final SliderButtonController _sliderButtonController = SliderButtonController();

  // bloc variables
  late ServiceBloc _serviceBloc;

  // navigation service
  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();

    _serviceBloc = context.read<ServiceBloc>();

    // initialize required statuses
    _serviceBloc.state.inspectionJsonUploadStatus = InspectionJsonUploadStatus.initial;

    _serviceBloc.state.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return GestureDetector(
      onTap: () {
        // unfocuses all the current focused widgets
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // restricts widget resizing when keyboard appears
        resizeToAvoidBottomInset: false,
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Inspection Out'),
        body: Container(
          padding: EdgeInsets.only(top: size.height * 0.01),
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
          ),
          child: BlocConsumer<ServiceBloc, ServiceState>(listener: (context, state) {
            if (state.inspectionJsonUploadStatus == InspectionJsonUploadStatus.success) {
              context.read<ServiceBloc>().add(GetJobCards(query: 'Location27'));
            }
          }, builder: (context, state) {
            switch (state.getInspectionStatus) {
              // Show loading animation while data is being fetched
              case GetInspectionStatus.loading:
                return Transform(
                  transform: Matrix4.translationValues(0, -40, 0),
                  child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                  ),
                );
              case GetInspectionStatus.success:
                // Extract button text from JSON data
                List<String> buttonsText = [];

                for (var entry in state.json!.entries) {
                  buttonsText.add(entry.key);
                }

                // Build the UI for buttons and content pages
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(size.height * 0.008),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                      child: SizedBox(
                        height: size.height * (isMobile ? 0.04 : 0.035),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _autoScrollController,
                          children: buttonsText
                              .map((e) => AutoScrollTag(
                                    // Use AutoScrollTag widget to auto scroll the buttons list UI to make the buttons visible corresponding to the page index.
                                    key: ValueKey(buttonsText.indexOf(e)),
                                    controller: _autoScrollController,
                                    index: buttonsText.indexOf(e),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.008),
                                      child: SizedBox(
                                        height: size.height * 0.035,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                backgroundColor: state.index == buttonsText.indexOf(e) ? Colors.black : Colors.grey.shade400,
                                                foregroundColor: state.index == buttonsText.indexOf(e) ? Colors.white : const Color.fromARGB(255, 29, 22, 22),
                                                side: const BorderSide(color: Colors.black)),
                                            onPressed: () {
                                              _pageController.jumpToPage(buttonsText.indexOf(e));
                                            },
                                            child: Text(e, style: TextStyle(fontSize: isMobile ? 14 : 18))),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    Gap(size.height * 0.01),
                    Expanded(
                      // Outer SizedBox: Likely used for layout constraints or alignment purposes.
                      child: SizedBox(
                        width: size.width,
                        child: PageView.builder(
                          // Creates a scrollable view with multiple pages based on the number of items in state.json
                          itemCount: state.json!.length,
                          controller: _pageController,
                          onPageChanged: (value) {
                            // Updates the service bloc with the current page index
                            _serviceBloc.add(PageChange(index: value));
                            // Scrolls Buttons list corresponding to the current page index
                            _autoScrollController.scrollToIndex(value, duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
                          },
                          itemBuilder: (context, pageIndex) => Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    // Creates a list view for each page
                                    child: ListView.builder(
                                      itemCount: state.json![buttonsText[pageIndex]].length - 1,
                                      itemBuilder: (context, index) {
                                        // sets slider position based on each page status in json
                                        _sliderButtonController.position = state.json![buttonsText[pageIndex]].last['status'] == "Accepted"
                                            ? Position.right
                                            : state.json![buttonsText[pageIndex]].last['status'] == "Rejected"
                                                ? Position.left
                                                : Position.middle;
                                        // Renders a column for each item in the list
                                        return Column(
                                          children: [
                                            Gap(size.height * 0.01),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Gap(size.width * 0.05),
                                                SizedBox(
                                                  width: size.width * 0.2,
                                                  child: Wrap(
                                                    children: [
                                                      Text(state.json![buttonsText[pageIndex]][index]['properties']['label'],
                                                          style: TextStyle(fontSize: isMobile ? 14 : 18)),
                                                    ],
                                                  ),
                                                ),
                                                Gap(size.width * 0.05),
                                                // Dynamically renders a widget based on the index, page, and other data
                                                getWidget(
                                                    context: context,
                                                    index: index,
                                                    page: buttonsText[pageIndex],
                                                    json: state.json!,
                                                    size: size,
                                                    isMobile: isMobile),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  // slider button to accept or reject each part inspection
                                  CustomSliderButton(
                                    height: size.height * 0.06,
                                    width: size.width * (isMobile ? 0.6 : 0.5),
                                    controller: _sliderButtonController,
                                    isMobile: isMobile,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(233, 227, 227, 1),
                                      borderRadius: BorderRadius.circular(isMobile ? 22 : 40),
                                    ),
                                    onLeftLabelReached: () {
                                      state.json![buttonsText[pageIndex]].last['status'] = 'Rejected';
                                      _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                      showReasonDialog(
                                          size: size,
                                          state: state,
                                          pageIndex: pageIndex,
                                          buttonsTextLength: buttonsText.length,
                                          page: buttonsText[pageIndex],
                                          controller: TextEditingController());
                                    },
                                    onRightLabelReached: () {
                                      state.json![buttonsText[pageIndex]].last['status'] = 'Accepted';
                                      _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                      if (pageIndex == buttonsText.length - 1) {
                                        showSubmitDialog(size: size, state: state, page: buttonsText[pageIndex]);
                                      }
                                    },
                                    onNoStatus: () {
                                      state.json![buttonsText[pageIndex]].last['status'] = '';
                                      _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                    },
                                    leftLabel: Text(
                                      'Reject',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 18),
                                    ),
                                    rightLabel: Text(
                                      'Accept',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 18),
                                    ),
                                    icon: Stack(
                                      children: [
                                        Container(
                                            height: size.height * 0.1,
                                            width: size.width * 0.1,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 15,
                                                  blurStyle: BlurStyle.outer,
                                                  spreadRadius: 0,
                                                  color: Colors.orange.shade200,
                                                  offset: const Offset(0, 0))
                                            ])),
                                        Positioned(
                                            top: isMobile ? 8 : size.height * 0.016,
                                            left: isMobile ? 0 : size.width * 0.018,
                                            child: const Icon(
                                              Icons.chevron_left_rounded,
                                              color: Colors.white,
                                            )),
                                        Positioned(
                                            top: isMobile ? 8 : size.height * 0.016,
                                            right: isMobile ? 0 : size.width * 0.018,
                                            child: const Icon(
                                              Icons.chevron_right_rounded,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Gap(size.height * 0.02)
                                ],
                              ),
                              if (state.inspectionJsonUploadStatus == InspectionJsonUploadStatus.loading)
                                Center(
                                  child: Lottie.asset('assets/lottie/car_loading.json',
                                      height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              default:
                return const SizedBox();
            }
          }),
        ),
      ),
    );
  }

  // dialog to show when inspection out to be submitted
  void showSubmitDialog({required Size size, required ServiceState state, required String page}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          bool isMobile = size.shortestSide < 500;
          return PopScope(
            canPop: false,
            child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.only(top: size.height * 0.01),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * (isMobile ? 0.03 : 0.02)),
                      child: Text(
                        'Hey Advisor...\nAre you done with inspection ?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 18),
                      ),
                    ),
                    Gap(size.height * 0.01),
                    Container(
                      height: size.height * 0.05,
                      margin: EdgeInsets.all(size.height * 0.001),
                      decoration: const BoxDecoration(
                          color: Colors.black, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                state.json![page].last['status'] = '';
                                _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                navigator.pop();
                              },
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
                              child: Text(
                                'No',
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
                              onPressed: () {
                                if (!isConnected()) {
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: 'Looks like you'
                                          're offline. Please check your connection and try again.',
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                  return;
                                }
                                state.json = state.json!;
                                _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                _serviceBloc.add(InspectionJsonAdded(jobCardNo: state.service!.jobCardNo!, inspectionIn: 'false'));
                                _serviceBloc.add(GetJobCards(query: 'Location27'));
                              },
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
                              child: Text('Yes', style: TextStyle(fontSize: isMobile ? 14 : 18)),
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
  }

  // dialog to show when part inspection is rejected
  void showReasonDialog(
      {required Size size,
      required ServiceState state,
      required int pageIndex,
      required int buttonsTextLength,
      required String page,
      required TextEditingController controller}) {
    controller.text = state.json![page].last['reason'] ?? '';
    bool isMobile = size.shortestSide < 500;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
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
                          child: TextFormField(
                            selectionControls: MaterialTextSelectionControls(),
                            controller: controller,
                            autofocus: true,
                            cursorColor: Colors.black,
                            style: TextStyle(fontSize: isMobile ? 14 : 18),
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black26, fontSize: isMobile ? 14 : 18),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(),
                                focusColor: Colors.black,
                                contentPadding: const EdgeInsets.only(left: 14, top: 14),
                                hintText: "Reason for rejection",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onChanged: (value) {
                              state.json![page].last['reason'] = value;
                              _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                            },
                          ),
                        )),
                    Gap(size.height * 0.01),
                    Container(
                      height: size.height * 0.05,
                      margin: EdgeInsets.all(size.height * 0.001),
                      decoration: const BoxDecoration(
                          color: Colors.black, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                state.json![page].last['status'] = '';
                                _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                navigator.pop();
                              },
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
                              child: Text(
                                'Cancel',
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
                              onPressed: () {
                                state.json![page].last['reason'] = controller.text;
                                _serviceBloc.add(InspectionJsonUpdated(json: state.json!));
                                if (controller.text.isEmpty) {
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: "Reason cannot be empty",
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                } else {
                                  navigator.pop();
                                  if (pageIndex == buttonsTextLength - 1) {
                                    showSubmitDialog(size: size, state: state, page: page);
                                  }
                                }
                              },
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
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
  }
}
