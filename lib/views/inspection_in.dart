import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/navigations/route_generator.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/vehicle_examination.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../bloc/multi/multi_bloc.dart';
import '../bloc/service/service_bloc.dart';
import '../inits/init.dart';
import '../navigations/navigator_service.dart';
import '../vehiclemodule/xml_parser.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> with ConnectivityMixin {
  final PageController _pageController = PageController();
  final AutoScrollController _autoScrollController = AutoScrollController();
  final NavigatorService navigator = getIt<NavigatorService>();
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();

    _serviceBloc = context.read<ServiceBloc>();
    _serviceBloc.state.serviceUploadStatus = ServiceUploadStatus.initial;
    _serviceBloc.state.inspectionJsonUploadStatus = InspectionJsonUploadStatus.initial;
    _serviceBloc.state.svgStatus = SVGStatus.initial;
    _serviceBloc.state.index = 0;
    _serviceBloc.add(GetJson());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    navigator.pop();
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
              child: const Text(
                textAlign: TextAlign.center,
                'Inspection In',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              )),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
              ),
              child: BlocBuilder<ServiceBloc, ServiceState>(builder: (context, state) {
                switch (state.jsonStatus) {
                  case JsonStatus.loading:
                    return Transform(
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32),
                      ),
                    );
                  case JsonStatus.success:
                    List<String> buttonsText = [];
                    for (var entry in state.json!.entries) {
                      buttonsText.add(entry.key);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(size.height * 0.008),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
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
                                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                                          child: SizedBox(
                                            height: size.height * 0.035,
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
                              itemCount: state.json!.length,
                              controller: _pageController,
                              onPageChanged: (value) {
                                _serviceBloc.add(PageChange(index: value));
                                _autoScrollController.scrollToIndex(value,
                                    duration: const Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
                              },
                              itemBuilder: (context, pageIndex) => ListView.builder(
                                itemCount: state.json![buttonsText[pageIndex]].length - 1,
                                itemBuilder: (context, index) {
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
                                              children: [Text(state.json![buttonsText[pageIndex]][index]['properties']['label'])],
                                            ),
                                          ),
                                          Gap(size.width * 0.05),
                                          getWidget(
                                              context: context, index: index, page: buttonsText[pageIndex], json: state.json!, size: size, isMobile: isMobile),
                                        ],
                                      ),
                                      Gap(size.height * 0.02),
                                      if (pageIndex == buttonsText.length - 1 && index == state.json![buttonsText[pageIndex]].length - 2)
                                        Gap(size.height * 0.05),
                                      if (pageIndex == buttonsText.length - 1 && index == state.json![buttonsText[pageIndex]].length - 2)
                                        BlocListener<ServiceBloc, ServiceState>(
                                            listener: (context, state) async {},
                                            child: GestureDetector(
                                              onTap: () async {
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
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                _serviceBloc.add(InspectionJsonAdded(jobCardNo: state.jobCardNo!, inspectionIn: 'true'));
                                                context.read<VehicleBloc>().state.status = VehicleStatus.initial;
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: size.height * 0.045,
                                                  width: isMobile ? size.width * 0.2 : size.width * 0.08,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        blurStyle: BlurStyle.outer,
                                                        spreadRadius: 0,
                                                        color: Colors.orange.shade200,
                                                        offset: const Offset(0, 0))
                                                  ]),
                                                  child: const Text(
                                                    textAlign: TextAlign.center,
                                                    'submit',
                                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                                  )),
                                            ))
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

  Widget getWidget(
      {required Size size,
      required String page,
      required int index,
      required Map<String, dynamic> json,
      required BuildContext context,
      required bool isMobile}) {
    switch (json[page][index]['widget']) {
      case "checkBox":
        return SizedBox(
          height: size.height * 0.03,
          width: isMobile ? size.width * 0.05 : size.width * 0.024,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor:
                json[page][index]['properties']['value'] == true ? const WidgetStatePropertyAll(Colors.black) : const WidgetStatePropertyAll(Colors.white),
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

        textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));

        return Container(
          height: size.height * 0.11,
          width: isMobile ? size.width * 0.62 : size.width * 0.32,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, border: Border.all(color: Colors.black)),
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
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                hintStyle: TextStyle(color: Colors.black38),
              ),
              onChanged: (value) {
                _serviceBloc.state.json![page][index]['properties']['value'] = value;
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
              width: isMobile ? size.width * 0.5 : size.width * 0.32,
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
              icon: Icon(!false ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options
                .map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      json[page][index]['properties']['options'][options.indexOf(e)],
                      style: const TextStyle(fontSize: 13),
                    ),
                    leading: Radio<int>(
                      value: options.indexOf(e) + 1,
                      groupValue: json[page][index]['properties']['value'],
                      activeColor: Colors.white, // Change the active radio button color here
                      fillColor: WidgetStateProperty.all(Colors.black), // Change the fill color when selected
                      splashRadius: 20, // Change the splash radius when clicked
                      onChanged: (value) {
                        json[page][index]['properties']['value'] = value;
                        _serviceBloc.add(InspectionJsonUpdated(json: json));
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
