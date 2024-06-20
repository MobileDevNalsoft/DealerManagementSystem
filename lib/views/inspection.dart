import 'dart:convert';

import 'package:dms/dynamic_ui_src/Entry/json_to_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/multi/multi_bloc.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  Map<String, dynamic> functions = {};

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
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MultiBloc, MultiBlocState>(
        builder: (context, state) {
          switch (state.jsonStatus) {
            case JsonStatus.loading:
              return const CircularProgressIndicator();
            case JsonStatus.success:

              // container
              state.json!['width'] = size.width * 0.9;
              state.json!['height'] = size.height * 0.4;

              // gaps in header
              for (int i = 1; i < 6; i = i + 2) {
                state.json!['child']['children'][0]['children'][i]['value'] =
                    size.width * 0.036;
              }

              // gaps in first column
              state.json!['child']['children'][1]['children'][0]['children'][0]
                  ['value'] = size.height * 0.02;

              for (int i = 2; i < 11; i = i + 2) {
                state.json!['child']['children'][1]['children'][0]['children']
                    [i]['value'] = size.height * 0.01;
              }

              state.json!['child']['children'][1]['children'][1]['value'] =
                  size.width * 0.12;
              state.json!['child']['children'][1]['children'][3]['value'] =
                  size.width * 0.1;
              state.json!['child']['children'][1]['children'][5]['value'] =
                  size.width * 0.1;

              for (int i = 2; i < 7; i = i + 2) {
                state.json!['child']['children'][1]['children'][i]['children'] =
                    List.generate(
                  6,
                  (index) {
                    functions = {
                      "onTap": (value) {
                        print(value);
                        context.read<MultiBloc>().add(CheckBoxTapped(
                            key: (index + (i / 2 - 1) * 6).toInt()));
                      }
                    };
                    print(state.checkBoxStates);
                    print((index + (i / 2 - 1) * 6).toInt());
                    return {
                      "type": "sizedBox",
                      "width": size.width * 0.1,
                      "height": size.height * 0.052,
                      "child": {
                        "type": "checkBox",
                        "value": state
                            .checkBoxStates![(index + (i / 2 - 1) * 6).toInt()],
                        "side": {"color": "#ffffff"},
                        "onChanged": "onTap"
                      }
                    };
                  },
                );
              }

              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/dms_bg.png'),
                        fit: BoxFit.cover)),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Vehicle no.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          ' : ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'dynamic',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Customer Name',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          ' : ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'dynamic',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Chassis no.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          ' : ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'dynamic',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    Gap(size.width * 0.1),
                    JsonToWidget.fromJson(state.json, context, functions)!,
                    Gap(size.width * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(70.0, 35.0),
                                padding: const EdgeInsets.all(8),
                                backgroundColor:
                                    const Color.fromARGB(255, 145, 19, 19),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              'Add Comments',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(70.0, 35.0),
                                padding: const EdgeInsets.all(8),
                                backgroundColor:
                                    const Color.fromARGB(255, 145, 19, 19),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              );
            default:
              return const Text("Some Error has occurred");
          }
        },
      ),
    ));
  }
}
