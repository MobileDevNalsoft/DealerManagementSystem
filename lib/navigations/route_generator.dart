import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/dashboard.dart';
import 'package:dms/views/gate_pass.dart';
import 'package:dms/views/home.dart';
import 'package:dms/views/inspection_in.dart';
import 'package:dms/views/inspection_out.dart';
import 'package:dms/views/jobcard_details.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:dms/views/login.dart';
import 'package:dms/views/my_jobcards.dart';
import 'package:dms/views/quality_check.dart';
import 'package:dms/views/service_booking.dart';
import 'package:dms/views/service_history.dart';
import 'package:dms/views/vehicle_examination.dart';
import 'package:dms/views/vehicle_info.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case '/dashboard':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const DashBoard(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/addVehicle':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const AddVehicle(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/vehicleExamination':
        final args = settings.arguments as GeneralBodyParts;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => VehicleExamination(
                  generalParts: args.generalParts,
                ));
      case '/gatePass':
        return Transitions.slideLeftTransition(const GatePass(), settings);
      case '/inspectionIn':
        return Transitions.slideLeftTransition(const InspectionIn(), settings);
      case '/inspectionOut':
        return Transitions.slideLeftTransition(const InspectionOut(), settings);
      case '/jobCardDetails':
        return Transitions.slideLeftTransition(JobCardDetails(), settings);
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login(), settings: settings);
      case '/listOfJobCards':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const ListOfJobcards(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/myJobCards':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const MyJobcards(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/qualityCheck':
        final args = settings.arguments as GeneralBodyParts;
        return Transitions.slideLeftTransition(
            QualityCheck(
              generalParts: args.generalParts,
              acceptedParts: args.acceptedParts,
              rejectedParts: args.rejectedParts,
              pendingParts: args.pendingParts,
              jobCardNo: args.jobCardNo!,
            ),
            settings);
      case '/serviceBooking':
        return Transitions.slideUpTransition(ServiceBooking(), settings);
      case '/vehicleInfo':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const VehicleInfo(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      case '/serviceHistory':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const ServiceHistory(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
      default:
        return MaterialPageRoute(
            settings: settings,
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
  String? jobCardNo;
  GeneralBodyParts({this.generalParts, this.acceptedParts, this.rejectedParts, this.pendingParts, this.jobCardNo});
}

class Transitions {
  static PageRouteBuilder<dynamic> slideUpTransition(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<dynamic> slideLeftTransition(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
