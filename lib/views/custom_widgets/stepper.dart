import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/navigations/route_generator.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/gate_pass.dart';
import 'package:dms/views/inspection_out.dart';
import 'package:dms/views/quality_check.dart';
import 'package:flutter/material.dart' hide Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../inits/init.dart';
import '../../navigations/navigator_service.dart';

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
      children: widget.steps,
    );
  }
}

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
    return LayoutBuilder(builder: (context, constraints) {
      print('current ${widget.currentStep}');
      print('activeStep ${widget.activeStep}');
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: constraints.maxWidth * 0.4,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              )),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: constraints.minWidth * 0.095,
                    top: constraints.minWidth *
                        (widget.currentStep == widget.activeStep ? 0 : 0.01)),
                child: SizedBox(
                  height: constraints.maxWidth *
                      (widget.currentStep == widget.activeStep ? 0.2 : 0.15),
                  width: constraints.maxWidth * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.currentStep == widget.activeStep)
                        Positioned(
                          top: -constraints.maxWidth * 0.15,
                          bottom: -constraints.maxWidth * 0.16,
                          left: -constraints.maxWidth * 0.137,
                          right: -constraints.maxWidth * 0.15,
                          child: Lottie.asset(
                            'assets/lottie/ripple.json',
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          print('current ${widget.currentStep}');
                          print('activeStep ${widget.activeStep}');
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
                                context.read<MultiBloc>().add(
                                    MultiBlocStatusChange(
                                        status: MultiStateStatus.loading));
                                List<GeneralBodyPart> generalParts;
                                List<GeneralBodyPart> rejectedParts;
                                List<GeneralBodyPart> acceptedParts;
                                List<GeneralBodyPart> pendingParts;
                                try {
                                  generalParts = await loadSvgImage(
                                      svgImage: 'assets/images/image.svg');
                                  rejectedParts = await loadSvgImage(
                                      svgImage:
                                          'assets/images/image_reject.svg');
                                  acceptedParts = await loadSvgImage(
                                      svgImage:
                                          'assets/images/image_accept.svg');
                                  pendingParts = await loadSvgImage(
                                      svgImage:
                                          'assets/images/image_pending.svg');
                                  context.read<MultiBloc>().add(
                                      MultiBlocStatusChange(
                                          status: MultiStateStatus.initial));
                                  navigator.push('/qualityCheck',
                                      arguments: GeneralBodyParts(
                                          generalParts: generalParts,
                                          rejectedParts: rejectedParts,
                                          acceptedParts: acceptedParts,
                                          pendingParts: pendingParts,
                                          jobCardNo: widget.jobCardNo));
                                } catch (e) {
                                  print(" caught an error $e");
                                }

                              case 3:
                                context.read<ServiceBloc>().add(
                                    GetInspectionDetails(
                                        jobCardNo: widget.jobCardNo));
                                navigator.push('/inspectionOut');
                              case 4:
                                navigator.push('/gatePass');
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              widget.currentStep < widget.activeStep
                                  ? Colors.green.shade300
                                  : widget.currentStep == widget.activeStep
                                      ? Colors.green.shade100
                                      : Colors.grey.shade300,
                          maxRadius: 25,
                          child: Image.asset(
                            'assets/images/${widget.icons[widget.currentStep]}.png',
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.currentStep <= widget.activeStep - 1 ||
                  (widget.activeStep == 0 && widget.currentStep < 1))
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    widget.statusLines[widget.currentStep],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              if (widget.currentStep == widget.activeStep &&
                  widget.currentStep < widget.stepperLength &&
                  widget.activeStep != 0)
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    widget.pendingStatusLines[widget.currentStep],
                    style: const TextStyle(fontSize: 12),
                  ),
                )
            ],
          ),
          if (widget.currentStep < widget.stepperLength - 1)
            Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * 0.173),
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
          if (widget.currentStep == widget.stepperLength - 1)
            Gap(constraints.maxWidth * 0.1)
        ],
      );
    });
  }
}
