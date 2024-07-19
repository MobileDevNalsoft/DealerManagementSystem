import 'dart:ui' as ui; // Import the 'ui' library

import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:touchable/touchable.dart';

class BodyPainter extends CustomPainter {
  final BuildContext context;
  final BodySelectorViewModel model;
  final List<GeneralBodyPart>? generalParts;
  final List<GeneralBodyPart>? acceptedParts;
  String previousSelected = '';
  static int cnt = 0;
  BodyPainter({
    required this.context,
    required this.model,
    this.generalParts,
     this.acceptedParts
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

    var myCanvas = TouchyCanvas(context, canvas);

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
        paint.color = Color.fromRGBO(255, 221, 28, 1);
      } else if (["rear_right_light", "rear_left_light"]
          .contains(muscle.name)) {
        paint.color = Color.fromRGBO(190, 39, 39, 1);
      } else if (["spare_and_tool_kit"].contains(muscle.name)) {
        paint.color = Color.fromARGB(134, 55, 55, 94);
      } else if (["front_bumper", "rear_bumper"].contains(muscle.name)) {
        paint.color = Color.fromRGBO(133, 127, 127, 0.612);
      }
      if (model.selectedGeneralBodyPart == muscle.name) {
        paint.color = Colors.white;
      }

      //     myCanvas.drawPath(
      //   path.transform(matrix4.storage),
      //   borderPaint,
      // );
      
      myCanvas.drawPath(
        path.transform(matrix4.storage),
        paint,
        
      
        onTapDown: (details) {
          print("details ${details}");
         
          if (!muscle.name.startsWith('text')) {
            print(" name from painter${muscle.name} ${ Provider.of<BodySelectorViewModel>(context,listen:false).isTapped}");

             Provider.of<BodySelectorViewModel>(context,listen:false).selectedGeneralBodyPart =  muscle.name;
             Provider.of<BodySelectorViewModel>(context,listen:false).isTapped = true;
          }
         
        },
        onTapUp: (details) {
            print("outside if");
            Provider.of<BodySelectorViewModel>(context,listen:false).isTapped=false;
            Provider.of<BodySelectorViewModel>(context,listen:false).selectedGeneralBodyPart="";
        },
      );
      
      paint.color =ui.Color.fromARGB(255, 66, 255, 66);
      if(context.read<VehiclePartsInteractionBloc>().state.mapMedia.containsKey(muscle.name)){
      
        context.read<VehiclePartsInteractionBloc>().state.mapMedia.forEach((key,value){
          if(context.read<VehiclePartsInteractionBloc>().state.mapMedia[muscle.name]!.isAccepted==true){
          // Path path = parseSvgPath(acceptedParts!.where((test){if(test.name=="${muscle.name}_accept")return test;}).path);
          myCanvas.drawPath(path.transform(matrix4.storage), paint,paintStyleForTouch: PaintingStyle.fill);
          return;
          }
        });
          
      }
      // Offset getPathCenterPoint(Path path) {
      //   Rect bounds = path.getBounds();
      //   return Offset(bounds.left + bounds.width / 2, bounds.top + bounds.height / 2);
      // }      
      // final icon = Icons.add;
      // TextPainter textPainter = TextPainter(
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.text = TextSpan(
      //   text: String.fromCharCode(icon.codePoint),
      //   style: TextStyle(
      //     fontSize: 40.0,
      //     fontFamily: icon.fontFamily,
      //   ),
      // );
      // textPainter.layout();    
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
