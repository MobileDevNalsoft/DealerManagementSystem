import 'dart:typed_data';
import 'dart:ui' as ui; // Import the 'ui' library

import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/views/comments_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:touchable/touchable.dart';

class BodyPainter extends CustomPainter {
  final BuildContext context;
  final BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  String previousSelected = '';
  static int cnt = 1;
  BodyPainter({
    required this.context,
    required this.model,
    this.generalParts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 8.0;

    // Paint borderPaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.65
    //   ..color = const Color.fromARGB(255, 255, 255, 255);

    var contextSize = MediaQuery.of(context).size;

    final Matrix4 matrix4 = Matrix4.identity();

    if (contextSize.width > 1050) {
      var xScale = contextSize.width / contextSize.width * 0.4;
      var yScale = contextSize.height * 0.96 / contextSize.height * 0.7;

      double translateX =
          (contextSize.width - contextSize.width * 1.6 * xScale) / 2;
      double translateY =
          (contextSize.height * 0.96 - contextSize.height * 0.8 * yScale) / 2;

      matrix4.translate(translateX, translateY);
      matrix4.scale(xScale, yScale);
    } else {
      var xScale = contextSize.width / contextSize.width * 0.38;
      var yScale = contextSize.height * 0.94 / contextSize.height * 0.6;

      double translateX =
          (contextSize.width - contextSize.width * 1.5 * xScale) / 2;
      double translateY =
          (contextSize.height * 0.96 - contextSize.height * 0.85 * yScale) / 2;

      matrix4.translate(translateX, translateY);
      matrix4.scale(xScale, yScale);
    }

    for (var muscle in generalParts!) {
      Path path = parseSvgPath(muscle.path);
      paint.color = ui.Color.fromARGB(133, 97, 97, 194);
      if (muscle.name.startsWith("text")) {
        paint.color = Colors.black;
      } else if ([
        "front_window",
        "rear_window",
        "rear_right_window",
        "rear_left_window",
        "front_left_window",
        "front_right_window"
      ].contains(muscle.name)) {
        paint.color = Color.fromARGB(255, 88, 88, 88);
      } else if ([
        "front_right_tire",
        "front_left_tire",
        "rear_left_tire",
        "rear_right_tire"
      ].contains(muscle.name)) {
        paint.color = const Color.fromARGB(255, 12, 10, 10);
      } else if ([
        "front_right_cap",
        "front_left_cap",
        "rear_left_cap",
        "rear_right_cap"
      ].contains(muscle.name)) {
        paint.color = Color.fromRGBO(92, 92, 92, 1);
      } else if (["front_right_light", "front_left_light"]
          .contains(muscle.name)) {
        paint.color = Color.fromRGBO(255, 221, 28,1);
      } else if (["rear_right_light", "rear_left_light"]
          .contains(muscle.name)) {
        paint.color = Color.fromRGBO(190, 39, 39, 1);
      } else if (["spare_and_tool_kit"].contains(muscle.name)) {
        paint.color = Color.fromARGB(134, 55, 55, 94);
      } else if (["front_bumper", "rear_bumper"].contains(muscle.name)) {
        paint.color = Color.fromRGBO(133, 127, 127, 0.612);
      }
      if (model.selectedGeneralBodyPart != null &&
          model.selectedGeneralBodyPart == muscle.name) {
        paint.color = Colors.white;
      }

      var myCanvas = TouchyCanvas(context, canvas);
      //     myCanvas.drawPath(
      //   path.transform(matrix4.storage),
      //   borderPaint,
      // );

      myCanvas.drawPath(
        path.transform(matrix4.storage),
        paint,
        onTapDown: (details) {
          print("details $details");
          if (!muscle.name.startsWith('text')) {
            print(" name ${muscle.name}");
            model.selectGeneralBodyPart(muscle.name);
            model.isTapped=true;
          }
        },
        onSecondaryTapDown: (d) {
          print(d);
        },
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
