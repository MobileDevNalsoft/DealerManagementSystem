import 'package:dms/bloc/customer_bloc/customer_bloc.dart';
import 'package:dms/bloc/vehicle_bloc/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/providers/service_history_provider.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/views/homeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(RepositoryProvider(
    create: (context) => Repository(api: getIt()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleBloc()),
        BlocProvider(create: (_) => CustomerBloc(repo: _.read<Repository>())),
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
