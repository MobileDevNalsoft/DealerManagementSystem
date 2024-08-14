import 'dart:ui' as ui;

import 'package:dms/vehiclemodule/body_painter.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:touchable/touchable.dart';

class BodyCanvas extends StatelessWidget{
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  final List<GeneralBodyPart>? rejectedParts;
  final List<GeneralBodyPart>? pendingParts;
  final bool displayAcceptedStatus;
  BodyCanvas({this.generalParts, this.acceptedParts, this.rejectedParts, this.pendingParts,this.displayAcceptedStatus=false});

  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      gesturesToOverride: 
      // Provider.of<BodySelectorViewModel>(context, listen: true).isTapped == false ? 
      [GestureType.onTapDown] ,
      // : [GestureType.onTapUp],
      builder: (context) => CustomPaint(
        painter: BodyPainter(
            context: context,
            generalParts: generalParts, 
            acceptedParts: acceptedParts, 
            rejectedParts: rejectedParts, 
            pendingParts: pendingParts,
            displayAcceptedStatus: displayAcceptedStatus
            ),
      ),
    );
  }
}

