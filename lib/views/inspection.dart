import 'package:dms/views/DMS_custom_widgets.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<MultiBloc>().add(GetJson());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
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

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(size.height * 0.01),
                Center(
                  child: SizedBox(
                    height: size.height * 0.04,
                    width: size.width * 0.95,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Gap(size.width * 0.01),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.json!.length,
                      itemBuilder: (context, index) {
                        for (var entry in state.json!.entries) {
                          buttonsText.add(entry.key);
                        }

                        return TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor: state.index == index
                                    ? const Color.fromARGB(255, 145, 19, 19)
                                    : const Color.fromARGB(255, 238, 203, 203),
                                foregroundColor: state.index == index
                                    ? Colors.white
                                    : const Color.fromARGB(255, 145, 19, 19),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 145, 19, 19))),
                            onPressed: () {},
                            child: Text(buttonsText[index]));
                      },
                    ),
                  ),
                ),
                Divider(
                  height: size.height * 0.025,
                  thickness: 2,
                  color: Colors.grey.shade300,
                ),
                Gap(size.height * 0.01),
                Expanded(
                  child: SizedBox(
                    width: size.width * 0.95,
                    child: PageView.builder(
                      itemCount: state.json!.length,
                      onPageChanged: (value) {
                        context.read<MultiBloc>().add(PageChange(index: value));
                      },
                      itemBuilder: (context, pageIndex) => ListView.builder(
                        itemCount: state.json![buttonsText[pageIndex]].length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(state.json![buttonsText[pageIndex]][index]
                                  ['properties']['label']),
                              getWidget(
                                  widget: state.json![buttonsText[pageIndex]]
                                      [index],
                                  size: size)
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
    ));
  }

  Widget getWidget({required Map<String, dynamic> widget, required Size size}) {
    switch (widget['widget']) {
      case "checkBox":
        return Checkbox(
          value: widget['properties']['value'],
          onChanged: (value) {},
        );
      case "textField":
        return SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.5,
          child: TextField(),
        );
      case "dropDown":
        List<DropdownMenuItem<Object>>? dropDownList = [];

        for (var item in widget['properties']['items']) {
          dropDownList.add(DropdownMenuItem(
            child: Text(item),
          ));
        }

        return DropdownButton(
          items: dropDownList,
          value: "Front Left Hand Side",
          onChanged: (value) {},
        );
    }

    return SizedBox();
  }
}
