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
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeView(),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1)
                .chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case '/dashboard':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashBoard(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/addVehicle':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AddVehicleView(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/customDetector':
        final args = settings.arguments as GeneralBodyParts;
        return MaterialPageRoute(
            builder: (_) => CustomDetector(
                  model: BodySelectorViewModel(),
                  generalParts: args.generalParts,
                ));
      case '/gatePass':
        return MaterialPageRoute(builder: (_) => const GatePass());
      case '/inspectionIn':
        return MaterialPageRoute(builder: (_) => const InspectionView());
      case '/inspectionOut':
        return MaterialPageRoute(builder: (_) => const InspectionOut());
      case '/jobCardDetails':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              JobCardDetails(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeIn));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/listOfJobCards':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ListOfJobcards(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/myJobCards':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MyJobcards(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
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
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ServiceBooking(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeIn));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case '/vehicleInfo':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const VehicleInfo(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/serviceHistory':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ServiceHistoryView(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
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
