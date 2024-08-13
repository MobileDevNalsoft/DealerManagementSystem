import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/vehiclemodule/responsive_interactive_viewer.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/comments.dart';
import 'package:dms/views/dashboard.dart';
import 'package:dms/views/gate_pass.dart';
import 'package:dms/views/home_view.dart';
import 'package:dms/views/inspection_in.dart';
import 'package:dms/views/inspection_out.dart';
import 'package:dms/views/jobcard_details.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:dms/views/login.dart';
import 'package:dms/views/my_jobcards.dart';
import 'package:dms/views/quality_check.dart';
import 'package:dms/views/service_booking.dart';
import 'package:dms/views/service_history.dart';
import 'package:dms/views/vehicle_info.dart';
import 'package:flutter/material.dart';

import '../vehiclemodule/wrapper_ex.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashBoard());
      case '/addVehicle':
        return MaterialPageRoute(builder: (_) => AddVehicleView());
      case '/customDetector':
        final args = settings.arguments as GeneralBodyParts;
        return MaterialPageRoute(
            builder: (_) => CustomDetector(
                  model: BodySelectorViewModel(),
                  generalParts: args.generalParts,
                ));
      case '/gatePass':
        return MaterialPageRoute(builder: (_) => GatePass());
      case '/inspectionIn':
        return MaterialPageRoute(builder: (_) => InspectionView());
      case '/inspectionOut':
        return MaterialPageRoute(builder: (_) => InspectionOut());
      case '/jobCardDetails':
        return MaterialPageRoute(builder: (_) => JobCardDetails());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/listOfJobCards':
        return MaterialPageRoute(builder: (_) => ListOfJobcards());
      case '/myJobCards':
        return MaterialPageRoute(builder: (_) => MyJobcards());
      case '/qualityCheck':
        final args = settings.arguments as GeneralBodyParts;
        return MaterialPageRoute(
            builder: (_) => QualityCheck(
                  model: BodySelectorViewModel(),
                  generalParts: args.generalParts,
                  acceptedParts: args.acceptedParts,
                  rejectedParts: args.rejectedParts,
                  pendingParts: args.pendingParts,
                ));
      case '/serviceBooking':
        return MaterialPageRoute(builder: (_) => ServiceBooking());
      case '/vehicleInfo':
        return MaterialPageRoute(builder: (_) => VehicleInfo());
      case '/serviceHistory':
        return MaterialPageRoute(builder: (_) => ServiceHistoryView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

class GeneralBodyParts {
  List<GeneralBodyPart>? generalParts;
  List<GeneralBodyPart>? acceptedParts;
  List<GeneralBodyPart>? rejectedParts;
  List<GeneralBodyPart>? pendingParts;
  GeneralBodyParts(
      {this.generalParts,
      this.acceptedParts,
      this.rejectedParts,
      this.pendingParts});
}
