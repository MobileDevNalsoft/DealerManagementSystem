import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/views/dashboard.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/service_main.dart';
import 'package:dms/views/test_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dynamic_ui_src/Entry/json_to_widget.dart';
import 'views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  await JsonToWidget.initialize();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  //sharedPreferences.setBool('isLogged', true);

  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => CustomerBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => ServiceBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => MultiBloc(repo: _.read<Repository>())),
        BlocProvider(
            create: (_) => AuthenticationBloc(repo: _.read<Repository>())),
        BlocProvider(
            create: (_) =>
                VehiclePartsInteractionBloc(repo: _.read<Repository>())),
        ChangeNotifierProvider(create: (_) => BodySelectorViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Gilroy'),
        debugShowCheckedModeBanner: false,
        home: !sharedPreferences.containsKey('isLogged') ||
                sharedPreferences.getBool('isLogged') == false
            ? const LoginView()
            : const DribbleUI(),
        routes: {
          '/home': (context) => HomeView(),
        },
      ),
    ),
  ));
}
