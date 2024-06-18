import 'dart:convert';

import 'package:dms/dynamic_ui_src/Entry/json_to_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              state.json!['child']['child']['children'][0]['children'][0]
                  ['value'] = size.width * 0.2;
              state.json!['width'] = size.width;
              state.json!['height'] = size.height;
              state.json!['child']['child']['children'][3]['width'] =
                  size.width * 0.9;
              state.json!['child']['child']['children'][3]['height'] =
                  size.height * 0.4;
              return JsonToWidget.fromJson(state.json, context)!;
            default:
              return const Text("Some Error has occurred");
          }
        },
      ),
    ));
  }
}
