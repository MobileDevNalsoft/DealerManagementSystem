import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/bloc/vehile_parts_interaction_bloc/vehicle_parts_interaction_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/providers/service_history_provider.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/vehiclemodule/responsive_interactive_viewer.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:dms/vehiclemodule/xml_parser.dart';
import 'package:dms/views/dashboard_view.dart';
import 'package:dms/vehiclemodule/body_canvas.dart';
import 'package:dms/views/homeview.dart';
import 'package:dms/views/inspection_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
 List<GeneralBodyPart> generalParts =await  loadSvgImage(svgImage: 'assets/images/image.svg');
  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => CustomerBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => ServiceBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => MultiBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => AuthenticationBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => VehiclePartsInteractionBloc(repo: _.read<Repository>())),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ServiceHistoryProvider()),
        ChangeNotifierProvider(create: (_) => BodySelectorViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
        //  DashboardView()
         CustomDetector(model: BodySelectorViewModel(),generalParts: generalParts,)
      ),
    ),
  ));
}
