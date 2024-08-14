import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/navigations/route_generator.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dynamic_ui_src/Entry/json_to_widget.dart';
import 'views/login.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  await JsonToWidget.initialize();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // sharedPreferences.setBool('isLogged', false);

  print(sharedPreferences.getInt('service_advisor_id'));
  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => VehicleBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(
            create: (_) => CustomerBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(
            create: (_) => ServiceBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(
            create: (_) => MultiBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(
            create: (_) =>
                AuthenticationBloc(repo: getIt(), navigator: getIt())),
        BlocProvider(
            create: (_) =>
                VehiclePartsInteractionBloc(repo: getIt(), navigator: getIt())),
        ChangeNotifierProvider(create: (_) => BodySelectorViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: getIt<NavigatorService>().navigatorkey,
        theme: ThemeData(
            fontFamily: 'Gilroy',
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white, primary: Colors.black)),
        debugShowCheckedModeBanner: false,
        initialRoute: !sharedPreferences.containsKey('isLogged') ||
                sharedPreferences.getBool('isLogged') == false
            ? '/login'
            : '/home',
        routes: {
          '/home': (context) => const HomeView(),
          '/login': (context) => const LoginView()
        },
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  ));
}
