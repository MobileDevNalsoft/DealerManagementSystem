import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/navigations/route_generator.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart' hide Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../inits/init.dart';
import '../../logger/logger.dart';
import '../../navigations/navigator_service.dart';

// this class is used to create a stepper widget to show the flow of the job card status in job card details.
class Stepper extends StatefulWidget {
  Stepper({super.key, required this.steps});

  List<Widget> steps;

  @override
  State<Stepper> createState() => _StepperState();
}

class _StepperState extends State<Stepper> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: widget.steps,
    );
  }
}

// this class creates step widget for each step in the stepper.
class Step extends StatefulWidget {
  Step(
      {super.key,
      required this.title,
      required this.currentStep,
      required this.activeStep,
      required this.stepperLength,
      required this.icons,
      required this.jobCardNo,
      required this.statusLines,
      required this.pendingStatusLines});

  String title;
  int currentStep;
  int activeStep;
  int stepperLength;
  String jobCardNo;
  List<String> icons;
  List<String> statusLines;
  List<String> pendingStatusLines;

  @override
  State<Step> createState() => _StepState();
}

class _StepState extends State<Step> with ConnectivityMixin {
  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: constraints.maxWidth * 0.39,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: (isMobile ? 12 : 17), color: widget.currentStep > widget.activeStep ? Colors.black45 : Colors.black),
              )),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: constraints.minWidth * 0.095, top: constraints.minWidth * (widget.currentStep == widget.activeStep ? 0 : 0.01)),
                child: SizedBox(
                  height: constraints.maxWidth * (widget.currentStep == widget.activeStep ? 0.2 : 0.15),
                  width: constraints.maxWidth * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.currentStep == widget.activeStep)
                        Positioned(
                          top: -constraints.maxWidth * (isMobile ? 0.15 : 0.185),
                          bottom: -constraints.maxWidth * (isMobile ? 0.16 : 0.19),
                          left: -constraints.maxWidth * (isMobile ? 0.137 : 0.165),
                          right: -constraints.maxWidth * (isMobile ? 0.15 : 0.18),
                          child: Lottie.asset(
                            'assets/lottie/ripple.json',
                          ),
                        ),
                      InkWell(
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
                          if (widget.currentStep == widget.activeStep) {
                            switch (widget.activeStep) {
                              case 2:
                                context.read<MultiBloc>().add(MultiBlocStatusChange(status: MultiStateStatus.loading));
                                try {
                                  context.read<MultiBloc>().add(MultiBlocStatusChange(status: MultiStateStatus.initial));
                                  navigator.popAndPush('/qualityCheck');
                                } catch (e) {
                                  context.read<MultiBloc>().add(MultiBlocStatusChange(status: MultiStateStatus.failure));

                                  Log.e(" caught an error $e");
                                }

                              case 3:
                                context.read<ServiceBloc>().add(GetInspectionDetails(jobCardNo: widget.jobCardNo));
                                navigator.push('/inspectionOut');
                              case 4:
                                navigator.push('/gatePass');
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: widget.currentStep < widget.activeStep
                              ? Colors.green.shade300
                              : widget.currentStep == widget.activeStep
                                  ? Colors.green.shade100
                                  : Colors.grey.shade300,
                          maxRadius: (isMobile ? 25 : 55),
                          child: Image.asset(
                            'assets/images/${widget.icons[widget.currentStep]}.png',
                            fit: BoxFit.cover,
                            height: (isMobile ? 30 : 55),
                            width: (isMobile ? 30 : 55),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.currentStep < widget.activeStep)
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    widget.statusLines[widget.currentStep],
                    style: TextStyle(fontSize: isMobile ? 12 : 17),
                  ),
                ),
              if (widget.currentStep >= widget.activeStep)
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    widget.pendingStatusLines[widget.currentStep],
                    style: TextStyle(
                        fontSize: isMobile ? 12 : 17,
                        color: (widget.activeStep != widget.stepperLength - 1 && widget.currentStep != 0 && widget.currentStep > widget.activeStep)
                            ? Colors.black45
                            : Colors.black),
                  ),
                )
            ],
          ),
          if (widget.currentStep < widget.stepperLength - 1)
            Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * (isMobile ? 0.173 : 0.185)),
              child: SizedBox(
                height: constraints.maxWidth * 0.1,
                child: VerticalDivider(
                  thickness: 2,
                  color: widget.currentStep < widget.activeStep
                      ? Colors.green.shade300
                      : widget.currentStep == widget.activeStep
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                ),
              ),
            ),
          if (widget.currentStep == widget.stepperLength - 1) Gap(constraints.maxWidth * 0.1)
        ],
      );
    });
  }
}
