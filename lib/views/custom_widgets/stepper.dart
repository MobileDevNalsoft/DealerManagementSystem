import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
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

class Step extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print('current $currentStep');
      print('activeStep $activeStep');
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: constraints.maxWidth * 0.4,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: constraints.minWidth * 0.095,
                    top: constraints.minWidth *
                        (currentStep == activeStep ? 0 : 0.01)),
                child: SizedBox(
                  height: constraints.maxWidth *
                      (currentStep == activeStep ? 0.2 : 0.15),
                  width: constraints.maxWidth * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (currentStep == activeStep)
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
                        onTap: () {
                          print('current $currentStep');
                          print('activeStep $activeStep');
                          if (currentStep == activeStep) {
                            switch (activeStep) {
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => QualityCheck(
                                            model: BodySelectorViewModel())));
                              case 3:
                                context.read<ServiceBloc>().add(
                                    GetInspectionDetails(jobCardNo: jobCardNo));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => InspectionOut()));
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => GatePass()));
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: currentStep < activeStep
                              ? Colors.green.shade300
                              : currentStep == activeStep
                                  ? Colors.green.shade100
                                  : Colors.grey.shade300,
                          maxRadius: 25,
                          child: Image.asset(
                            'assets/images/${icons[currentStep]}.png',
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
              if (currentStep <= activeStep - 1 ||
                  (activeStep == 0 && currentStep < 1))
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    statusLines[currentStep],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              if (currentStep == activeStep &&
                  currentStep < stepperLength &&
                  activeStep != 0)
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    pendingStatusLines[currentStep],
                    style: const TextStyle(fontSize: 12),
                  ),
                )
            ],
          ),
          if (currentStep < stepperLength - 1)
            Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * 0.173),
              child: SizedBox(
                height: constraints.maxWidth * 0.1,
                child: VerticalDivider(
                  thickness: 2,
                  color: currentStep < activeStep
                      ? Colors.green.shade300
                      : currentStep == activeStep
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                ),
              ),
            ),
          if (currentStep == stepperLength - 1) Gap(constraints.maxWidth * 0.1)
        ],
      );
    });
  }
}
