import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow, Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../bloc/service/service_bloc.dart';
import '../models/services.dart';
import '../navigations/navigator_service.dart';
import 'custom_widgets/stepper.dart';

class JobCardDetails extends StatelessWidget {
  JobCardDetails({super.key});

  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    final ServiceBloc _serviceBloc = context.read<ServiceBloc>();
    List<String> dmsFlow = ['New', 'Work in progress', 'Quality Check', 'Inspection Out', 'Completed'];

    List<String> icons = ['initiated', 'work_in_progress', 'quality_check', 'inspection_out', 'completed'];

    List<String> statusLines = [
      'JC created on ${_serviceBloc.state.service!.creationDate}',
      'Vehicle Service is done',
      'Quality Check is done',
      'Inpection out is done',
      'Service Completed'
    ];

    List<String> pendingStatusLines = [
      '',
      'Vehicle Service is in progress',
      'Quality Check needs to be done',
      'Inpection out needs to be done',
      'Gate Pass Generated'
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
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
                'JobCard Details',
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
                      colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1])),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.04),
                    height: size.height * 0.32,
                    width: size.width * (isMobile ? 0.9 : 0.48),
                    padding: EdgeInsets.symmetric(horizontal: size.width * (isMobile ? 0.05 : 0.032), vertical: size.height * 0.03),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                    child: ListView(
                      children: [
                        buildDetailRow('Job Card Number', _serviceBloc.state.service!.jobCardNo.toString(), size, isMobile),
                        Gap(size.height * 0.03),
                        buildDetailRow('Vehicle Registration Number', _serviceBloc.state.service!.registrationNo.toString(), size, isMobile),
                        Gap(size.height * 0.03),
                        buildDetailRow('Location', _serviceBloc.state.service!.location.toString(), size, isMobile),
                        Gap(size.height * 0.03),
                        buildDetailRow('Job Type', _serviceBloc.state.service!.jobType.toString(), size, isMobile),
                        Gap(size.height * 0.03),
                        buildDetailRow('Scheduled Date', _serviceBloc.state.service!.scheduledDate.toString(), size, isMobile)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.032),
                        padding: EdgeInsets.only(top: size.height * 0.01),
                        width: size.width * (isMobile ? 0.93 : 0.48),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, blurStyle: BlurStyle.normal, offset: Offset(1, 1), spreadRadius: 10)]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 16),
                            ),
                            Gap(size.height * 0.01),
                            Expanded(
                                child: Stepper(
                              steps: dmsFlow
                                  .map((e) => Step(
                                        activeStep: dmsFlow.indexWhere((e) => e == _serviceBloc.state.service!.status),
                                        currentStep: dmsFlow.indexOf(e),
                                        icons: icons,
                                        stepperLength: dmsFlow.length,
                                        title: e,
                                        statusLines: statusLines,
                                        pendingStatusLines: pendingStatusLines,
                                        jobCardNo: _serviceBloc.state.service!.jobCardNo!,
                                      ))
                                  .toList(),
                            )),
                          ],
                        )),
                  )
                ],
              ),
            ),
            if (context.watch<MultiBloc>().state.status == MultiStateStatus.loading)
              Container(
                color: Colors.blueGrey.withOpacity(0.25),
                child: Center(child: Lottie.asset('assets/lottie/car_loading.json', height: size.height * 0.4, width: size.width * 0.4)),
              )
          ],
        ));
  }

  Widget buildDetailRow(String key, String value, Size size, bool isMobile) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: size.width * (isMobile ? 0.4 : 0.16),
        child: Text(
          key,
          softWrap: true,
          style: const TextStyle(fontSize: 13),
        ),
      ),
      SizedBox(
        width: size.width * (isMobile ? 0.4 : 0.16),
        child: Text(
          textAlign: TextAlign.right,
          value,
          softWrap: true,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, overflow: TextOverflow.visible),
        ),
      )
    ]);
  }
}
