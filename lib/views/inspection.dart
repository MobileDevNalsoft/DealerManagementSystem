import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/responsive_interactive_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../bloc/multi/multi_bloc.dart';

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
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
                ),
                body: BlocBuilder<MultiBloc, MultiBlocState>(builder: (context, state) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(size.height * 0.005),
                  Center(
                    child: SizedBox(
                        width: size.width * 0.95,
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
                                                : Color.fromARGB(255, 29, 22, 22),
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
                        )),
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
                          context.read<MultiBloc>().add(PageChange(index: value));
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(state.json![buttonsText[pageIndex]]
                                        [index]['properties']['label']),
                                    getWidget(
                                        context: context,
                                        index: index,
                                        page: buttonsText[pageIndex],
                                        json: state.json!,
                                        size: size)
                                  ],
                                ),
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
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomDetector(
                                                model: BodySelectorViewModel(),
                                                generalParts: [],
                                              ),
                                            ));
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
        return Checkbox(
          value: json[page][index]['properties']['value'],
          onChanged: (value) {
            json[page][index]['properties']['value'] = value;
            context.read<MultiBloc>().add(InspectionJsonUpdated(json: json));
            print(context.read<MultiBloc>().state.json);
          },
        );
      case "textField":
        // focusNode.addListener(() {
        //   print('focus changed');
        //   if (!focusNode.hasFocus) {
        //     json[page][index]['properties']['value'] =
        //         textEditingController.text;
        // context.read<MultiBloc>().add(InspectionJsonUpdated(json: json));
        //   }
        // });

        print(json);
        TextEditingController textEditingController = TextEditingController();

        textEditingController.text = json[page][index]['properties']['value'];

  
       
        return SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.5,
          child: TextField(
            textInputAction: TextInputAction.done,
            controller: textEditingController,
            // autofocus: true,
            onChanged: (value) {
              textEditingController.text = value;
                      textEditingController.selection = TextSelection.fromPosition( TextPosition(offset: textEditingController.text.length));

              //  json[page][index]['properties']['value'] = value;
               context.read<MultiBloc>().state.json![page][index]['properties']['value'] = value;
            }
          ),
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

        return Row(
          children: [
            Gap(size.width * 0.05),
            DropdownButton(
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              value: json[page][index]['properties']['value'],
              alignment: AlignmentDirectional.bottomStart,
              onChanged: (value) {
                json[page][index]['properties']['value'] = value;
                context
                    .read<MultiBloc>()
                    .add(InspectionJsonUpdated(json: json));
                print(context.read<MultiBloc>().state.json);
              },
            ),
          ],
        );
      case "radioButtons":
        List<String> options = [];

        for (String s in json[page][index]['properties']['options']) {
          options.add(s);
        }

        return SizedBox(
          height: size.height * 0.3,
          width: size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: options
                .map(
                  (e) => ListTile(
                    title: Text(json[page][index]['properties']['options']
                        [options.indexOf(e)]),
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
                        print(context.read<MultiBloc>().state.json);
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

  void onFocusChange() {}
}
