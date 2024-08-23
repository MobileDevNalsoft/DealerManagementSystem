import 'package:dms/bloc/authentication/authentication_bloc.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/constants/app_constants.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/repository/repository.dart';
import 'package:get_it/get_it.dart';
import 'package:network_calls/src.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;

  //Api
  getIt.registerLazySingleton<NetworkCalls>(() => NetworkCalls(AppConstants.BaseURL, getIt(), connectTimeout: 30, receiveTimeout: 30));

  //Repo
  getIt.registerLazySingleton<Repository>(
    () => Repository(api: getIt()),
  );

  //Navigator Service
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}
