import 'package:dms/bloc/service/service_bloc.dart';
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

class _StepState extends State<Step> with ConnectivityMixin{
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          if (widget.currentStep == widget.activeStep) {
                            switch (widget.activeStep) {
                              case 2: 
                              if(!isConnected()){
                                 DMSCustomWidgets.NetworkCheckFlushbar(size, context);
                                 return;
                              }
                                List<GeneralBodyPart> generalParts = await loadSvgImage(svgImage: 'assets/images/image.svg');
                                List<GeneralBodyPart> rejectedParts = await loadSvgImage(svgImage: 'assets/images/image_reject.svg');
                                List<GeneralBodyPart> acceptedParts = await loadSvgImage(svgImage: 'assets/images/image_accept.svg');
                                List<GeneralBodyPart> pendingParts = await loadSvgImage(svgImage: 'assets/images/image_pending.svg');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => QualityCheck(
                                              model: BodySelectorViewModel(),
                                              generalParts: generalParts,
                                              rejectedParts: rejectedParts,
                                              acceptedParts: acceptedParts,
                                              pendingParts: pendingParts,
                                              jobCardNo: widget.jobCardNo
                                            )));
                              case 3:
                               if(!isConnected()){
                                 DMSCustomWidgets.NetworkCheckFlushbar(size, context);
                                 return;
                              }
                                context.read<ServiceBloc>().add(GetInspectionDetails(jobCardNo: widget.jobCardNo));
                                Navigator.push(context, MaterialPageRoute(builder: (_) => InspectionOut()));
                              case 4:
                               if(!isConnected()){
                                 DMSCustomWidgets.NetworkCheckFlushbar(size, context);
                                 return;
                              }
                                Navigator.push(context, MaterialPageRoute(builder: (_) => GatePass()));
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: widget.currentStep < widget.activeStep
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
              if (widget.currentStep <= widget.activeStep - 1 || (widget.activeStep == 0 && widget.currentStep < 1))
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    widget.statusLines[widget.currentStep],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              if (widget.currentStep == widget.activeStep && widget.currentStep < widget.stepperLength && widget.activeStep != 0)
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
          if (widget.currentStep == widget.stepperLength - 1) Gap(constraints.maxWidth * 0.1)
        ],
      );
    });
  }
}
