import 'dart:convert';

import 'package:dms/views/custom_widgets/custom_slider_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:slider_button/slider_button.dart';

import '../bloc/multi/multi_bloc.dart';
import '../bloc/service/service_bloc.dart';
import '../vehiclemodule/body_canvas.dart';
import '../vehiclemodule/responsive_interactive_viewer.dart';
import '../vehiclemodule/xml_parser.dart';

class InspectionOut extends StatefulWidget {
  const InspectionOut({super.key});

  @override
  State<InspectionOut> createState() => _InspectionOutState();
}

class _InspectionOutState extends State<InspectionOut> {
  final PageController _pageController = PageController();
  final AutoScrollController _autoScrollController = AutoScrollController();
  final SliderButtonController _sliderButtonController =
      SliderButtonController();

  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();

    _serviceBloc = context.read<ServiceBloc>();

    _serviceBloc.state.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.black45,
          leadingWidth: size.width * 0.14,
          leading: Container(
            margin: EdgeInsets.only(left: size.width * 0.045),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      color: Colors.orange.shade200,
                      offset: const Offset(0, 0))
                ]),
            child: Transform(
              transform: Matrix4.translationValues(-3, 0, 0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
            ),
          ),
          title: Container(
              height: size.height * 0.05,
              width: size.width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 0,
                        color: Colors.orange.shade200,
                        offset: const Offset(0, 0))
                  ]),
              child: const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Inspection Out',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                ),
              )),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: size.height * 0.01),
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black45, Colors.black26, Colors.black45],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 1]),
          ),
          child:
              BlocBuilder<ServiceBloc, ServiceState>(builder: (context, state) {
            print('position ${state.sliderPosition}');
            switch (state.getInspectionStatus) {
              case GetInspectionStatus.loading:
                return Transform(
                  transform: Matrix4.translationValues(0, -40, 0),
                  child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: size.height * 0.5, width: size.width * 0.6),
                  ),
                );
              case GetInspectionStatus.success:
                List<String> buttonsText = [];

                for (var entry in state.inspectionDetails!.entries) {
                  buttonsText.add(entry.key);
                }

                List<Widget> widgets = [];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(size.height * 0.008),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.005),
                      child: SizedBox(
                        height: size.height * 0.04,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _autoScrollController,
                          children: buttonsText
                              .map((e) => AutoScrollTag(
                                    key: ValueKey(buttonsText.indexOf(e)),
                                    controller: _autoScrollController,
                                    index: buttonsText.indexOf(e),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.008),
                                      child: SizedBox(
                                        height: size.height * 0.035,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                backgroundColor: state.index ==
                                                        buttonsText.indexOf(e)
                                                    ? Colors.black
                                                    : Colors.grey.shade400,
                                                foregroundColor: state.index ==
                                                        buttonsText.indexOf(e)
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 29, 22, 22),
                                                side: const BorderSide(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              _pageController.jumpToPage(
                                                  buttonsText.indexOf(e));
                                            },
                                            child: Text(e)),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    Gap(size.height * 0.01),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: PageView.builder(
                          itemCount: state.inspectionDetails!.length,
                          controller: _pageController,
                          onPageChanged: (value) {
                            _serviceBloc.add(PageChange(index: value));
                            _autoScrollController.scrollToIndex(value,
                                duration: const Duration(milliseconds: 500),
                                preferPosition: AutoScrollPosition.begin);
                          },
                          itemBuilder: (context, pageIndex) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state
                                          .inspectionDetails![
                                              buttonsText[pageIndex]]
                                          .length -
                                      1,
                                  itemBuilder: (context, index) {
                                    state.sliderPosition = state
                                                .inspectionDetails![
                                                    buttonsText[pageIndex]]
                                                .last['status'] ==
                                            "Accepted"
                                        ? Position.right
                                        : state
                                                    .inspectionDetails![
                                                        buttonsText[pageIndex]]
                                                    .last['status'] ==
                                                "Rejected"
                                            ? Position.left
                                            : Position.middle;
                                    _sliderButtonController.position =
                                        state.sliderPosition;
                                    return Column(
                                      children: [
                                        Gap(size.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(size.width * 0.05),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: Wrap(
                                                children: [
                                                  Text(state.inspectionDetails![
                                                          buttonsText[
                                                              pageIndex]][index]
                                                      ['properties']['label'])
                                                ],
                                              ),
                                            ),
                                            Gap(size.width * 0.05),
                                            getWidget(
                                                context: context,
                                                index: index,
                                                page: buttonsText[pageIndex],
                                                json: state.inspectionDetails!,
                                                size: size),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   height: size.height * 0.1,
                              //   width: size.width,
                              //   child: CustomSliderButton(
                              //     height: size.height * 0.06,
                              //     width: size.width * 0.6,
                              //     controller: _sliderButtonController,
                              //     decoration: BoxDecoration(
                              //       color:
                              //           const Color.fromRGBO(233, 227, 227, 1),
                              //       borderRadius: BorderRadius.circular(22),
                              //     ),
                              //     onLeftLabelReached: () {
                              //       state
                              //           .inspectionDetails![
                              //               buttonsText[pageIndex]]
                              //           .last['status'] = 'Rejected';
                              //       state.sliderPosition = Position.left;
                              //     },
                              //     onRightLabelReached: () {
                              //       state
                              //           .inspectionDetails![
                              //               buttonsText[pageIndex]]
                              //           .last['status'] = 'Accepted';
                              //       state.sliderPosition = Position.right;
                              //       if (pageIndex == buttonsText.length - 1) {
                              //         showSubmitDialog(
                              //             size: size,
                              //             state: state,
                              //             controller: _sliderButtonController,
                              //             page: buttonsText[pageIndex]);
                              //       }
                              //     },
                              //     onNoStatus: () {
                              //       state
                              //           .inspectionDetails![
                              //               buttonsText[pageIndex]]
                              //           .last['status'] = '';
                              //     },
                              //     leftLabel: const Text(
                              //       'Reject',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     rightLabel: const Text(
                              //       'Accept',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     icon: Stack(
                              //       children: [
                              //         Container(
                              //             height: size.height * 0.1,
                              //             width: size.width * 0.1,
                              //             decoration: BoxDecoration(
                              //                 shape: BoxShape.circle,
                              //                 color: Colors.black,
                              //                 boxShadow: [
                              //                   BoxShadow(
                              //                       blurRadius: 15,
                              //                       blurStyle: BlurStyle.outer,
                              //                       spreadRadius: 0,
                              //                       color:
                              //                           Colors.orange.shade200,
                              //                       offset: const Offset(0, 0))
                              //                 ])),
                              //         const Positioned(
                              //             top: 8,
                              //             child: Icon(
                              //               Icons.chevron_left_rounded,
                              //               color: Colors.white,
                              //             )),
                              //         const Positioned(
                              //             top: 8,
                              //             right: 1,
                              //             child: Icon(
                              //               Icons.chevron_right_rounded,
                              //               color: Colors.white,
                              //             ))
                              //       ],
                              //     ),
                              //   ),
                              // )
                              DraggableScrollableSheet(
                                controller: DraggableScrollableController(),
                                snap: true,
                                snapAnimationDuration:
                                    Duration(milliseconds: 500),
                                shouldCloseOnMinExtent: true,
                                minChildSize: 0.25,
                                maxChildSize: true ? 0.5 : 0.7,
                                initialChildSize: true ? 0.5 : 0.7,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: size.width * 0.776,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(26, 26, 27, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: CustomScrollView(
                                        controller: scrollController,
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Gap(size.width * 0.35),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      height: 4,
                                                      width: 32,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    Spacer(),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            Icons.cancel,
                                                          ),
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                        ))
                                                  ],
                                                ),
                                                Text(
                                                  "Qualtiy Check",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: 1.5,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SliverList.list(
                                              addRepaintBoundaries: true,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 18.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Gap(16),
                                                      Row(
                                                        children: [
                                                          Gap(8),
                                                          CircleAvatar(
                                                            radius: 4,
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    145,
                                                                    19,
                                                                    19,
                                                                    1),
                                                          ),
                                                          Gap(6),
                                                          Text("No data",
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        223,
                                                                        220,
                                                                        220),
                                                              )),
                                                        ],
                                                      ),
                                                      Gap(8.0),
                                                      SizedBox(
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.12,
                                                        child: GridView.builder(
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  true ? 3 : 5,
                                                              crossAxisSpacing:
                                                                  10,
                                                              mainAxisSpacing:
                                                                  10),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      SizedBox()),
                                                            );
                                                          },
                                                          itemCount: 1,
                                                        ),
                                                      ),
                                                      Gap(8),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.1,
                                                        width: size.width,
                                                        child:
                                                            CustomSliderButton(
                                                          height: size.height *
                                                              0.06,
                                                          width:
                                                              size.width * 0.6,
                                                          controller:
                                                              _sliderButtonController,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromRGBO(233,
                                                                227, 227, 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        22),
                                                          ),
                                                          onLeftLabelReached:
                                                              () {
                                                            state
                                                                .inspectionDetails![
                                                                    buttonsText[
                                                                        pageIndex]]
                                                                .last['status'] = 'Rejected';
                                                            state.sliderPosition =
                                                                Position.left;
                                                          },
                                                          onRightLabelReached:
                                                              () {
                                                            state
                                                                .inspectionDetails![
                                                                    buttonsText[
                                                                        pageIndex]]
                                                                .last['status'] = 'Accepted';
                                                            state.sliderPosition =
                                                                Position.right;
                                                            if (pageIndex ==
                                                                buttonsText
                                                                        .length -
                                                                    1) {
                                                              showSubmitDialog(
                                                                  size: size,
                                                                  state: state,
                                                                  controller:
                                                                      _sliderButtonController,
                                                                  page: buttonsText[
                                                                      pageIndex]);
                                                            }
                                                          },
                                                          onNoStatus: () {
                                                            state
                                                                .inspectionDetails![
                                                                    buttonsText[
                                                                        pageIndex]]
                                                                .last['status'] = '';
                                                          },
                                                          leftLabel: const Text(
                                                            'Reject',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          rightLabel:
                                                              const Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          icon: Stack(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                      size.height *
                                                                          0.1,
                                                                  width:
                                                                      size.width *
                                                                          0.1,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .black,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            blurRadius:
                                                                                15,
                                                                            blurStyle: BlurStyle
                                                                                .outer,
                                                                            spreadRadius:
                                                                                0,
                                                                            color:
                                                                                Colors.orange.shade200,
                                                                            offset: const Offset(0, 0))
                                                                      ])),
                                                              const Positioned(
                                                                  top: 8,
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_left_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              const Positioned(
                                                                  top: 8,
                                                                  right: 1,
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_right_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Gap(8),
                                                      if (state
                                                              .inspectionDetails![
                                                                  buttonsText[
                                                                      pageIndex]]
                                                              .last['status'] ==
                                                          'Rejected')
                                                        TextFormField(
                                                          controller:
                                                              TextEditingController(),
                                                          // autofocus:
                                                          //     rejectionController
                                                          //         .text.isEmpty,
                                                          maxLines: 5,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          onTap: () {},

                                                          decoration: InputDecoration(
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14),
                                                              fillColor: Color
                                                                  .fromRGBO(
                                                                      38,
                                                                      38,
                                                                      40,
                                                                      1),
                                                              filled: true,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 14,
                                                                      top: 14),
                                                              hintText:
                                                                  "Reasons for rejection",
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16))),
                                                          onChanged: (value) {},
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ])
                                        ],
                                      ),
                                    ),
                                  );
                                },
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

  void showSubmitDialog(
      {required Size size,
      required ServiceState state,
      required String page,
      required SliderButtonController controller}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(top: size.height * 0.01),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: const Text(
                      'Hey Advisor...\nAre you done with inspection ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(size.height * 0.01),
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              state.inspectionDetails![page].last['status'] =
                                  '';
                              _serviceBloc.add(UpdateSliderPosition(
                                  position: Position.middle));
                              Navigator.pop(context, false);
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'No',
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
                              Navigator.pop(context, false);
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'Yes',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero);
        });
  }

  Widget getWidget(
      {required Size size,
      required String page,
      required int index,
      required Map<String, dynamic> json,
      required BuildContext context}) {
    switch (json[page][index]['widget']) {
      case "checkBox":
        return SizedBox(
          height: size.height * 0.03,
          width: size.width * 0.05,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: json[page][index]['properties']['value'] == true
                ? const WidgetStatePropertyAll(Colors.black)
                : const WidgetStatePropertyAll(Colors.white),
            value: json[page][index]['properties']['value'],
            side: const BorderSide(strokeAlign: 1, style: BorderStyle.solid),
            onChanged: (value) {
              json[page][index]['properties']['value'] = value;
              _serviceBloc.add(InspectionJsonUpdated(json: json));
            },
          ),
        );
      case "textField":
        TextEditingController textEditingController = TextEditingController();

        textEditingController.text = json[page][index]['properties']['value'];

        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));

        return Container(
          height: size.height * 0.11,
          width: size.width * 0.62,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.black)),
          child: TextField(
              textInputAction: TextInputAction.done,
              controller: textEditingController,
              cursorColor: Colors.black,
              minLines: 1,
              maxLines: 5,
              maxLength: 200,
              decoration: const InputDecoration(
                counterText: '',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                hintStyle: TextStyle(color: Colors.black38),
              ),
              onChanged: (value) {
                textEditingController.text = value;
                _serviceBloc.state.json![page][index]['properties']['value'] =
                    value;
              }),
        );
      case "dropDown":
        List<String> items = [];

        for (String s in json[page][index]['properties']['items']) {
          items.add(s);
        }

        if (json[page][index]['properties']['value'] == '') {
          json[page][index]['properties']['value'] = items[0];
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            onMenuStateChange: (isOpen) {},
            isExpanded: true,
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: json[page][index]['properties']['value'],
            onChanged: (String? value) {
              json[page][index]['properties']['value'] = value;
              _serviceBloc.add(InspectionJsonUpdated(json: json));
            },
            buttonStyleData: ButtonStyleData(
              height: size.height * 0.04,
              width: size.width * 0.5,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(!false
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded),
              iconSize: 14,
              iconEnabledColor: Colors.black,
              iconDisabledColor: Colors.black,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: size.height * 0.3,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(6),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 30,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        );
      case "radioButtons":
        List<String> options = [];

        for (String s in json[page][index]['properties']['options']) {
          options.add(s);
        }

        return SizedBox(
          height: size.height * 0.25,
          width: size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options
                .map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      json[page][index]['properties']['options']
                          [options.indexOf(e)],
                      style: const TextStyle(fontSize: 13),
                    ),
                    leading: Radio<int>(
                      value: options.indexOf(e) + 1,
                      groupValue: json[page][index]['properties']['value'],
                      activeColor: Colors
                          .white, // Change the active radio button color here
                      fillColor: WidgetStateProperty.all(
                          Colors.black), // Change the fill color when selected
                      splashRadius: 20, // Change the splash radius when clicked
                      onChanged: (value) {
                        json[page][index]['properties']['value'] = value;
                        context.read<MultiBloc>().add(
                            RadioOptionChanged(selectedRadioOption: value!));
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        );
    }

    return const SizedBox();
  }
}