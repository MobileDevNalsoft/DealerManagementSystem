import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

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

  late MultiBloc _multiBloc;
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();

    _multiBloc = context.read<MultiBloc>();
    _multiBloc.state.index = 0;

    _serviceBloc = context.read<ServiceBloc>();
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
            "Inspection Out",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
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
          child:
              BlocBuilder<ServiceBloc, ServiceState>(builder: (context, state) {
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
                                          backgroundColor: _multiBloc
                                                      .state.index ==
                                                  buttonsText.indexOf(e)
                                              ? const Color.fromARGB(
                                                  255, 145, 19, 19)
                                              : const Color.fromARGB(
                                                  255, 238, 203, 203),
                                          foregroundColor:
                                              _multiBloc.state.index ==
                                                      buttonsText.indexOf(e)
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 29, 22, 22),
                                          side: const BorderSide(
                                              color: Color.fromARGB(255, 145, 19, 19))),
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
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    Gap(size.height * 0.01),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: PageView.builder(
                          itemCount: state.inspectionDetails!.length,
                          controller: _pageController,
                          onPageChanged: (value) {
                            context
                                .read<MultiBloc>()
                                .add(PageChange(index: value));
                          },
                          itemBuilder: (context, pageIndex) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IntrinsicHeight(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin:
                                      EdgeInsets.only(top: size.height * 0.04),
                                  width: size.width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03,
                                      vertical: size.height * 0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [],
                                  ),
                                ),
                              ),
                            ],
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

  Widget buildDetailRow(String key, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(fontFamily: 'Gilroy', fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold,
                fontSize: 13),
          )
        ]);
  }
}
