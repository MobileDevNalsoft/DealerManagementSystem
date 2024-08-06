import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:dms/views/jobcard_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dynamic_ui_src/Entry/json_to_widget.dart';
import 'views/login.dart';
import 'views/service_booking.dart';
import 'views/home_view.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  await JsonToWidget.initialize();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // sharedPreferences.setBool('isLogged', false);

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
            : const HomeView(),
        routes: {
          '/home': (context) => ServiceMain(),
          '/listOfJobCards': (context) => const ListOfJobcards(),
          '/jobCardDetails': (context) => JobCardDetails(),
          '/addVehicle': (context) => const AddVehicleView(),
          '/serviceBooking': (context) => ServiceMain(),
        },
      ),
    ),
  ));
}
