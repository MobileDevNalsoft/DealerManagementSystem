import 'package:dms/models/services.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../bloc/service/service_bloc.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class InspectionIn extends StatefulWidget {
  const InspectionIn({super.key});

  @override
  State<InspectionIn> createState() => _InspectionInState();
}

class _InspectionInState extends State<InspectionIn> with ConnectivityMixin {
  // controllers
  final PageController _pageController = PageController();
  final AutoScrollController _autoScrollController = AutoScrollController();

  // navigator service
  final NavigatorService navigator = getIt<NavigatorService>();

  // bloc varaibles
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();

    _serviceBloc = context.read<ServiceBloc>();

    //initialize required statuses
    _serviceBloc.state.serviceUploadStatus = ServiceUploadStatus.initial;
    _serviceBloc.state.inspectionJsonUploadStatus = InspectionJsonUploadStatus.initial;
    _serviceBloc.state.svgStatus = SVGStatus.initial;
    _serviceBloc.state.index = 0;

    // get json to create widgets dynamically
    _serviceBloc.add(GetJson());
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
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Inspection In'),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: size.height * 0.01),
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
              ),
              child: BlocBuilder<ServiceBloc, ServiceState>(builder: (context, state) {
                switch (state.jsonStatus) {
                  case JsonStatus.loading:
                    // Show loading animation while data is being fetched
                    return Transform(
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                      ),
                    );
                  case JsonStatus.success:
                    // Extract button text from JSON data
                    List<String> buttonsText = [];
                    for (var entry in state.json!.entries) {
                      buttonsText.add(entry.key);
                    }

                    // Build the UI for buttons and content pages
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                                          child: SizedBox(
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    backgroundColor: state.index == buttonsText.indexOf(e) ? Colors.black : Colors.grey.shade400,
                                                    foregroundColor:
                                                        state.index == buttonsText.indexOf(e) ? Colors.white : const Color.fromARGB(255, 29, 22, 22),
                                                    side: const BorderSide(color: Colors.black)),
                                                onPressed: () {
                                                  _pageController.jumpToPage(buttonsText.indexOf(e));
                                                },
                                                child: Text(
                                                  e,
                                                  style: TextStyle(fontSize: isMobile ? 14 : 18),
                                                )),
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
                                _autoScrollController.scrollToIndex(value,
                                    duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
                              },
                              itemBuilder: (context, pageIndex) =>
                                  // Creates a list view for each page
                                  ListView.builder(
                                itemCount: state.json![buttonsText[pageIndex]].length - 1,
                                itemBuilder: (context, index) {
                                  // Renders a column for each item in the list
                                  return Column(
                                    children: [
                                      Gap(size.height * (isMobile ? 0.01 : 0.03)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Gap(size.width * 0.05),
                                          SizedBox(
                                            width: size.width * 0.2,
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  state.json![buttonsText[pageIndex]][index]['properties']['label'],
                                                  style: TextStyle(fontSize: isMobile ? 14 : 18),
                                                )
                                              ],
                                            ),
                                          ),
                                          Gap(size.width * 0.05),
                                          // Dynamically renders a widget based on the index, page, and other data
                                          getWidget(
                                              context: context, index: index, page: buttonsText[pageIndex], json: state.json!, size: size, isMobile: isMobile),
                                        ],
                                      ),
                                      Gap(size.height * 0.02),
                                      // Conditional rendering of spacing and a BlocListener based on the current page and item index
                                      if (pageIndex == buttonsText.length - 1 && index == state.json![buttonsText[pageIndex]].length - 2)
                                        Gap(size.height * 0.05),
                                      if (pageIndex == buttonsText.length - 1 && index == state.json![buttonsText[pageIndex]].length - 2)
                                        BlocBuilder<ServiceBloc, ServiceState>(builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () async {
                                              // Checks for internet connection
                                              if (!isConnected()) {
                                                // Displays an error message if offline
                                                DMSCustomWidgets.DMSFlushbar(size, context,
                                                    message: 'Looks like you'
                                                        're offline. Please check your connection and try again.',
                                                    icon: const Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                    ));
                                                return;
                                              }

                                              // Unfocus any active input
                                              FocusManager.instance.primaryFocus?.unfocus();

                                              // Dispatches an event to the service bloc to add inspection data
                                              _serviceBloc.add(InspectionJsonAdded(dynamicNo: state.service!.serviceBookingNo!, inspectionIn: 'true'));
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: size.height * 0.045,
                                                width: size.width * (isMobile ? 0.2 : 0.15),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 10,
                                                      blurStyle: BlurStyle.outer,
                                                      spreadRadius: 0,
                                                      color: Colors.orange.shade200,
                                                      offset: const Offset(0, 0))
                                                ]),
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  'submit',
                                                  style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18),
                                                )),
                                          );
                                        })
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  default:
                    return const SizedBox();
                }
              }),
            ),
            if (context.watch<ServiceBloc>().state.inspectionJsonUploadStatus == InspectionJsonUploadStatus.loading ||
                context.watch<ServiceBloc>().state.svgStatus == SVGStatus.loading)
              // Show a loading indicator when inspection JSON upload or SVG is loading
              Container(
                color: Colors.black54,
                child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
              )
          ],
        ),
      ),
    );
  }
}
