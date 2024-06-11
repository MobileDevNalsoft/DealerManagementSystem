import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dms/logger/logger.dart';
import 'package:network_calls/src.dart';

class Repository {
  final NetworkCalls _api;

  Repository({required NetworkCalls api}) : _api = api;

  Future<Map<String, dynamic>> addVehicle(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addVehicle', data: payload);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<int> addService(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addService', data: payload);
    if (apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      if (response["response_code"] == 200) {
        Log.d(apiResponse.response);
        return response["response_code"];
      } else {
        Log.e(apiResponse.response);
        return response["response_code"];
      }
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<Map<String, dynamic>> getVehicle(String registrationNo) async {
    ApiResponse apiResponse = await _api
        .get('getVehicle', queryParameters: {"registrationNo": registrationNo});

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<Map<String, dynamic>> getCustomer(String customerContactNo) async {
    ApiResponse apiResponse = await _api.get('getCustomer',
        queryParameters: {"customerContactNo": customerContactNo});

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<Response<dynamic>?> getHistory(String customerNo) async {
    ApiResponse apiResponse = await _api
        .get('getHistory', queryParameters: {"customerNo": customerNo});

    if (apiResponse.response!.statusCode == 200) {
      return apiResponse.response;
    } else {
      return apiResponse.error;
    }
  }
}
