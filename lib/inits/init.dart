import 'package:dms/constants/app_constants.dart';
import 'package:dms/repository/repository.dart';
import 'package:get_it/get_it.dart';
import 'package:network_calls/src.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;

  //Api
  getIt.registerLazySingleton<NetworkCalls>(
      () => NetworkCalls(AppConstants.BaseURL, getIt()));

  //Repo
  getIt.registerLazySingleton(() => Repository(api: getIt()));

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}
