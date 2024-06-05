import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dms/logger/logger.dart';
import 'package:network_calls/src.dart';

class Repository {
  final NetworkCalls _api;

  Repository({required NetworkCalls api}) : _api = api;

  Future<int> addCustomer(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addCustomer', data: payload);
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

  Future<int?> addVehicle(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addVehicle', data: payload);

    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        return jsonDecode(apiResponse.response!.data)["response_code"];
      } else {
        Log.e(apiResponse.error);
        return apiResponse.response!.statusCode;
      }
    }
    else{
      throw Error();
    }
  }

  Future<void> addService(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addService', data: payload);
    if (apiResponse.response!.statusCode == 200) {
      Log.d(apiResponse.response);
    } else {
      Log.e(apiResponse.error);
    }
  }

  Future<Response<dynamic>?> getVehicle(String registrationNumber) async {
    ApiResponse apiResponse = await _api.get('getVehicle',
        queryParameters: {registrationNumber: registrationNumber});

    if (apiResponse.response!.statusCode == 200) {
      return apiResponse.response;
    } else {
      return apiResponse.error;
    }
  }

  Future<Response<dynamic>?> getHistory(String customerNo) async {
    ApiResponse apiResponse =
        await _api.get('getHistory', queryParameters: {customerNo: customerNo});

    if (apiResponse.response!.statusCode == 200) {
      return apiResponse.response;
    } else {
      return apiResponse.error;
    }
  }
}
