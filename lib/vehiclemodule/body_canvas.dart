import 'package:dms/vehiclemodule/body_painter.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class BodyCanvas extends StatelessWidget {
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  final List<GeneralBodyPart>? rejectedParts;
  final List<GeneralBodyPart>? pendingParts;
  final bool displayAcceptedStatus;

  //General Parts for vehicle examination view
  //remaining for quality check view.
  const BodyCanvas(
      {super.key,
      this.generalParts,
      this.acceptedParts,
      this.rejectedParts,
      this.pendingParts,
      this.displayAcceptedStatus = false});

  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      gesturesToOverride: const [GestureType.onTapDown],
      builder: (context) => CustomPaint(
        painter: BodyPainter(
            context: context,
            generalParts: generalParts,
            acceptedParts: acceptedParts,
            rejectedParts: rejectedParts,
            pendingParts: pendingParts,
            displayAcceptedStatus: displayAcceptedStatus),
      ),
    );
  }
}
