import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/responsive_interactive_viewer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../bloc/multi/multi_bloc.dart';
import '../bloc/service/service_bloc.dart';
import '../vehiclemodule/xml_parser.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MultiBloc>().add(GetJson());
    context.read<MultiBloc>().state.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color.fromARGB(255, 145, 19, 19),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: const Text(
            "Inspection",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 255, 231, 231),
                 Color.fromARGB(255, 241, 193, 193),
                    Color.fromARGB(255, 235, 136, 136),
                    Color.fromARGB(255, 226, 174, 174)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.35, 1]),
          ),
          child: BlocBuilder<MultiBloc, MultiBlocState>(builder: (context, state) {
            switch (state.jsonStatus) {
              case JsonStatus.loading:
                return Transform(
                  transform: Matrix4.translationValues(0, -40, 0),
                  child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: size.height * 0.5, width: size.width * 0.6),
                  ),
                );
              case JsonStatus.success:
                List<String> buttonsText = [];
          
                for (var entry in state.json!.entries) {
                  buttonsText.add(entry.key);
                }
          
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(size.height * 0.005),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: size.width * 0.01,
                        runSpacing: size.width * 0.01,
                        children: buttonsText
                            .map((e) => SizedBox(
                                  height: size.height * 0.035,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          backgroundColor: state.index ==
                                                  buttonsText.indexOf(e)
                                              ? const Color.fromARGB(
                                                  255, 145, 19, 19)
                                              : const Color.fromARGB(
                                                  255, 238, 203, 203),
                                          foregroundColor: state.index ==
                                                  buttonsText.indexOf(e)
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 29, 22, 22),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 145, 19, 19))),
                                      onPressed: () {
                                        _pageController
                                            .jumpToPage(buttonsText.indexOf(e));
                                      },
                                      child: Text(e)),
                                ))
                            .toList(),
                      ),
                    ),
                    Divider(
                      height: size.height * 0.015,
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                    Gap(size.height * 0.01),
                    Expanded(
                      child: SizedBox(
                        width: size.width * 0.95,
                        child: PageView.builder(
                          itemCount: state.json!.length,
                          controller: _pageController,
                          onPageChanged: (value) {
                            context
                                .read<MultiBloc>()
                                .add(PageChange(index: value));
                          },
                          itemBuilder: (context, pageIndex) => ListView.builder(
                            itemCount: state.json![buttonsText[pageIndex]].length,
                            itemBuilder: (context, index) {
                              // if (state.json![buttonsText[pageIndex]][index]
                              //         ['widget'] ==
                              //     'textField') {
                              //   textEditingController.text =
                              //       state.json![buttonsText[pageIndex]][index]
                              //           ['properties']['value'];
                              // }
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
                                            Text(state
                                                    .json![buttonsText[pageIndex]]
                                                [index]['properties']['label'])
                                          ],
                                        ),
                                      ),
                                      Gap(size.width * 0.05),
                                      getWidget(
                                          context: context,
                                          index: index,
                                          page: buttonsText[pageIndex],
                                          json: state.json!,
                                          size: size),
                                    ],
                                  ),
                                  Gap(size.height * 0.02),
                                  if (pageIndex == buttonsText.length - 1 &&
                                      index ==
                                          state.json![buttonsText[pageIndex]]
                                                  .length -
                                              1)
                                    Gap(size.height * 0.05),
                                  if (pageIndex == buttonsText.length - 1 &&
                                      index ==
                                          state.json![buttonsText[pageIndex]]
                                                  .length -
                                              1)
                                    ElevatedButton(
                                        onPressed: () async {
                                          context.read<MultiBloc>().add(
                                              InspectionJsonAdded(
                                                  jobCardNo: context
                                                      .read<ServiceBloc>()
                                                      .state
                                                      .service!
                                                      .jobCardNo!));
                                          await loadSvgImage(
                                                  svgImage:
                                                      'assets/images/image.svg')
                                              .then(
                                            (value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomDetector(
                                                      model:
                                                          BodySelectorViewModel(),
                                                      generalParts: value,
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(70.0, 35.0),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: const Color.fromARGB(
                                                255, 145, 19, 19),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
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
      ),
    ));
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
            value: json[page][index]['properties']['value'],
            side: const BorderSide(strokeAlign: 1, style: BorderStyle.solid),
            onChanged: (value) {
              json[page][index]['properties']['value'] = value;
              context.read<MultiBloc>().add(InspectionJsonUpdated(json: json));
              print(context.read<MultiBloc>().state.json);
            },
          ),
        );
      case "textField":
        print(json);
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
                
                context.read<MultiBloc>().state.json![page][index]['properties']
                    ['value'] = value;
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

        print(items);
        print(json[page][index]['properties']['value']);

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
              context.read<MultiBloc>().add(InspectionJsonUpdated(json: json));
              print(context.read<MultiBloc>().state.json);
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
                          .red, // Change the active radio button color here
                      fillColor: WidgetStateProperty.all(
                          Colors.red), // Change the fill color when selected
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
