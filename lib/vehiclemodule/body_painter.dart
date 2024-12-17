import 'dart:ui' as ui;
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:touchable/touchable.dart';

class BodyPainter extends CustomPainter {
  final BuildContext context;
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  final List<GeneralBodyPart>? rejectedParts;
  final List<GeneralBodyPart>? pendingParts;
  final bool displayAcceptedStatus;
  String previousSelected = '';
  final ui.Image? uiImage;
  static int cnt = 0;
  late double translateX;
  late double translateY;
  BodyPainter(
      {required this.context, this.generalParts, this.acceptedParts, this.rejectedParts, this.pendingParts, this.uiImage, this.displayAcceptedStatus = false});

  @override
  void paint(Canvas canvas, Size size) {
    cnt++;
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 8.0;

    var contextSize = MediaQuery.of(context).size;

    VehiclePartsInteractionBloc interactionBloc = context.read<VehiclePartsInteractionBloc>();

    final Matrix4 matrix4 = Matrix4.identity();

    //For tab screens
    if (contextSize.width > 1050) {
      //scale
      var xScale = contextSize.width / contextSize.width * 0.4;
      var yScale = contextSize.height * 0.96 / contextSize.height * 0.7;

      //position
      double translateX = (contextSize.width - contextSize.width * 1.2 * xScale) / 2;
      double translateY = (contextSize.height * 0.96 - contextSize.height * 1 * yScale) / 2;

      matrix4.translate(translateX, translateY);
      matrix4.scale(xScale, yScale);
    }
    // For mobile screens
    else {
      //scale
      var xScale = contextSize.width / contextSize.width * 0.38;
      var yScale = contextSize.height * 0.94 / contextSize.height * 0.6;

      //position
      double translateX = (contextSize.width - contextSize.width * 1.5 * xScale) / 2;
      double translateY = (contextSize.height * 0.96 - contextSize.height * yScale) / 2;

      matrix4.translate(translateX, translateY);
      matrix4.scale(xScale, yScale);
    }

    var myCanvas = TouchyCanvas(context, canvas);

    for (var muscle in generalParts!) {
      Path path = parseSvgPath(muscle.path);
      paint.color = const ui.Color.fromARGB(133, 97, 97, 194);
      if (muscle.name.startsWith("text")) {
        paint.color = Colors.black;
      } else if (["front_window", "rear_window", "rear_right_window", "rear_left_window", "front_left_window", "front_right_window"].contains(muscle.name)) {
        paint.color = const Color.fromARGB(255, 88, 88, 88);
      } else if (["front_right_tire", "front_left_tire", "rear_left_tire", "rear_right_tire"].contains(muscle.name)) {
        paint.color = const Color.fromARGB(255, 12, 10, 10);
      } else if (["front_right_cap", "front_left_cap", "rear_left_cap", "rear_right_cap"].contains(muscle.name)) {
        paint.color = const Color.fromRGBO(92, 92, 92, 1);
      } else if (["front_right_light", "front_left_light"].contains(muscle.name)) {
        paint.color = const Color.fromRGBO(255, 221, 28, 1);
      } else if (["rear_right_light", "rear_left_light"].contains(muscle.name)) {
        paint.color = const Color.fromRGBO(190, 39, 39, 1);
      } else if (["spare_and_tool_kit"].contains(muscle.name)) {
        paint.color = const Color.fromARGB(134, 55, 55, 94);
      } else if (["front_bumper", "rear_bumper"].contains(muscle.name)) {
        paint.color = const Color.fromRGBO(133, 127, 127, 0.612);
      }
      if (context.read<VehiclePartsInteractionBloc>().state.selectedBodyPart == muscle.name) {
        //color of the selected part
        paint.color = Colors.white;
      }

      myCanvas.drawPath(
        path.transform(matrix4.storage),
        paint,
        onTapDown: (details) {
          // on tap actions is only for parts
          if (!muscle.name.startsWith('text')) {
            context.read<VehiclePartsInteractionBloc>().add(ModifyVehicleInteractionStatus(selectedBodyPart: muscle.name, isTapped: true));
          }
        },
      );
      if (displayAcceptedStatus && interactionBloc.state.mapMedia.containsKey(muscle.name)) {
        if (interactionBloc.state.mapMedia[muscle.name]!.isAccepted == true) {
          String acceptedPart = "";
          for (var part in acceptedParts!) {
            if (part.name == "${muscle.name}_accept") {
              acceptedPart = part.path;
              break;
            }
          }
          if (acceptedPart.isNotEmpty) {
            paint.color = const ui.Color.fromARGB(255, 66, 255, 66);
            Path path = parseSvgPath(acceptedPart);
            myCanvas.drawPath(path.transform(matrix4.storage), paint, paintStyleForTouch: PaintingStyle.fill);
          }
        } else if (interactionBloc.state.mapMedia[muscle.name]!.isAccepted == false) {
          String rejectedPart = "";
          for (var part in rejectedParts!) {
            if (part.name == "${muscle.name}_reject") {
              rejectedPart = part.path;
              break;
            }
          }
          if (rejectedPart.isNotEmpty) {
            paint.color = const ui.Color.fromARGB(255, 247, 25, 25);
            Path path = parseSvgPath(rejectedPart);
            myCanvas.drawPath(path.transform(matrix4.storage), paint, paintStyleForTouch: PaintingStyle.fill);
          }
        } else {
          String pendingPart = "";
          for (var part in pendingParts!) {
            if (part.name == "${muscle.name}_pending") {
              pendingPart = part.path;
              break;
            }
          }
          if (pendingPart.isNotEmpty) {
            paint.color = const ui.Color.fromARGB(255, 255, 145, 2);
            Path path = parseSvgPath(pendingPart);
            myCanvas.drawPath(path.transform(matrix4.storage), paint, paintStyleForTouch: PaintingStyle.fill);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
