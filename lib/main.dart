import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/providers/service_history_provider.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/views/homeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'dynamic_ui_src/Entry/json_to_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  await JsonToWidget.initialize();
  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => CustomerBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => ServiceBloc(repo: _.read<Repository>())),
        BlocProvider(create: (_) => MultiBloc()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ServiceHistoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    ),
  ));
}
