import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:gap/gap.dart';

import '../models/services.dart';

class JobCardDetails extends StatelessWidget {
  JobCardDetails({super.key, required this.service});

  Service service;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<String> dmsFlow = [
      'Initiated',
      'In Progress',
      'Quality Check',
      'Inspection out',
      'Completed'
    ];

    List<String> icons = [
      'initiated',
      'work_in_progress',
      'quality_check',
      'inspection_out',
      'completed'
    ];

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 5,
              backgroundColor: const Color.fromARGB(255, 145, 19, 19),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "JobCard Details",
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
                        Color.fromARGB(255, 241, 184, 184),
                        Colors.white
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.04),
                    height: size.height * 0.31,
                    width: size.width * 0.9,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.03),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildDetailRow(
                            'Job Card Number', service.jobCardNo.toString()),
                        Divider(
                          color: Colors.grey.shade100,
                          height: size.height * 0.03,
                          thickness: 3,
                        ),
                        buildDetailRow('Vehicle Registration Number',
                            service.registrationNo.toString()),
                        Divider(
                          color: Colors.grey.shade100,
                          height: size.height * 0.03,
                          thickness: 3,
                        ),
                        buildDetailRow('Location', service.location.toString()),
                        Divider(
                          color: Colors.grey.shade100,
                          height: size.height * 0.03,
                          thickness: 3,
                        ),
                        buildDetailRow('Job Type', service.jobType.toString()),
                        Divider(
                          color: Colors.grey.shade100,
                          height: size.height * 0.03,
                          thickness: 3,
                        ),
                        buildDetailRow(
                            'Schedule Date', service.scheduleDate.toString())
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.04),
                        width: size.width * 0.95,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset(1, 1),
                                  spreadRadius: 10)
                            ]),
                        child: SizedBox(
                          child: EasyStepper(
                              showTitle: true,
                              activeStep: 1,
                              direction: Axis.vertical,
                              alignment: Alignment.center,
                              enableStepTapping: false,
                              showLoadingAnimation: false,
                              defaultStepBorderType: BorderType.normal,
                              padding: EdgeInsets.zero,
                              fitWidth: true,
                              showStepBorder: false,
                              stepRadius: 25,
                              lineStyle: const LineStyle(
                                  lineType: LineType.normal,
                                  finishedLineColor: Colors.green,
                                  lineLength: 20,
                                  lineSpace: 5,
                                  lineWidth: 10,
                                  unreachedLineColor: Colors.grey,
                                  unreachedLineType: LineType.dotted),
                              steps: dmsFlow
                                  .map(
                                    (e) => EasyStep(
                                        customTitle: Transform(
                                            transform:
                                                Matrix4.translationValues(
                                                    1, -60, 0),
                                            child: Text(
                                              e,
                                              style: TextStyle(fontSize: 10),
                                              textAlign: TextAlign.center,
                                            )),
                                        customStep: CircleAvatar(
                                          backgroundColor:
                                              dmsFlow.indexOf(e) < 1
                                                  ? Colors.lightGreen.shade300
                                                  : dmsFlow.indexOf(e) == 1
                                                      ? Colors.amber.shade200
                                                      : Colors.grey.shade300,
                                          maxRadius: 50,
                                          child: Image.asset(
                                            'assets/images/${icons[dmsFlow.indexOf(e)]}.png',
                                            fit: BoxFit.cover,
                                            height: 30,
                                            width: 30,
                                          ),
                                        )),
                                  )
                                  .toList()),
                        )),
                  )
                ],
              ),
            )));
  }

  Widget buildDetailRow(String key, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(fontFamily: 'Gilroy'),
          ),
          Text(
            value,
            style: const TextStyle(
                fontFamily: 'Gilroy', fontWeight: FontWeight.bold),
          )
        ]);
  }
}
