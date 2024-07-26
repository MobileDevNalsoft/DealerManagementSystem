import 'dart:convert';

import 'package:flutter/material.dart'
    hide BoxDecoration, BoxShadow, Stepper, Step;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../models/services.dart';
import 'custom_widgets/stepper.dart';

class JobCardDetails extends StatelessWidget {
  JobCardDetails({super.key, required this.service});

  Service service;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int activeStep = service.status! == 'N'
        ? 0
        : service.status! == 'I'
            ? 1
            : 2;

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

    List<String> statusLines = [
      'Job Card created on "Creation Date"',
      'Vehicle Service is in progress',
      'Quality Check is done',
      'Inpection out is done',
      'Service Completed'
    ];

    List<String> pendingStatusLines = [
      '',
      'Vehicle Service needs to be done',
      'Quality Check needs to be done',
      'Inpection out needs to be done'
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.black45,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black)),
          title: SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.45,
            child: Card(
                elevation: 8,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: Colors.orange.shade200,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'JobCard Details',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black26, Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.5, 1])),
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
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    width: size.width * 0.93,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Gap(size.height * 0.01),
                        Expanded(
                            child: Stepper(
                          steps: dmsFlow
                              .map((e) => Step(
                                    activeStep: activeStep,
                                    currentStep: dmsFlow.indexOf(e),
                                    icons: icons,
                                    stepperLength: dmsFlow.length,
                                    title: e,
                                    statusLines: statusLines,
                                    pendingStatusLines: pendingStatusLines,
                                    jobCardNo: service.jobCardNo!,
                                  ))
                              .toList(),
                        )),
                      ],
                    )),
              )
            ],
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
