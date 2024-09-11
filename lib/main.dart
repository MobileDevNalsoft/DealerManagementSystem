import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc_2/vehicle_parts_interaction_bloc2.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/navigations/route_generator.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/views/Vehicle_examination_2.dart';
import 'package:dms/views/quality_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => CustomerBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => ServiceBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => MultiBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => AuthenticationBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => VehiclePartsInteractionBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(create: (_) => VehiclePartsInteractionBloc2(repo: getIt(), navigator: getIt())),
      ],
      child: MaterialApp(
        navigatorKey: getIt<NavigatorService>().navigatorkey,
        theme: ThemeData(fontFamily: 'Gilroy', colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
        debugShowCheckedModeBanner: false,
        // home: QualityCheck(jobCardNo: 'JC-LOC-11',),
        initialRoute: !sharedPreferences.containsKey('isLogged') || sharedPreferences.getBool('isLogged') == false ? '/login' : '/vehicleExamination',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [MyNavigationObserver()],
      ),
    ),
  ));
}

class MyNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed Route: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped Route: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Removed Route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print("newRoute:  ${newRoute!.settings.name} oldRoute: ${oldRoute!.settings.name}");
  }
}
