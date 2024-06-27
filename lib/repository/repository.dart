import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/logger/logger.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:flutter/services.dart';
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

  Future<Map<String, dynamic>> getHistory(String year) async {
    ApiResponse apiResponse =
        await _api.get('getHistory', queryParameters: {"year": year});

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

    Future<Map<String, dynamic>> getVehicleCustomer(String registrationNo) async {
    ApiResponse apiResponse = await _api.get('getVehicleCustomer',
        queryParameters: {"registrationNo": registrationNo});

    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          return jsonDecode(apiResponse.response!.data);
        } else {
          throw apiResponse.error;
        }
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }

    Future<List<dynamic>> getSalesPersons(String searchText) async {
      print(searchText);
    ApiResponse apiResponse = await _api.get('getSalesPerson',queryParameters: {
      "search_text":searchText
    });
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          print(jsonDecode(apiResponse.response!.data)["data"].runtimeType);
          return (jsonDecode(apiResponse.response!.data)["data"] );
        } else {
          throw apiResponse.error;
        }
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }

  
   Future<List<dynamic>>  addVehicleMedia(Map<String, dynamic> image) async {
    print(image);
    ApiResponse apiResponse = await _api.post('addImage',data: {
      "image": jsonEncode(image),
    });
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          return (jsonDecode(apiResponse.response!.data)["data"] );
        } else {
          throw apiResponse.error;
        }
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }

    Future getImage() async {
    
    ApiResponse apiResponse = await _api.get('getImage');
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        // if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          // print(jsonDecode(apiResponse.response!.data).runtimeType);
          return apiResponse.response!.data["items"][0]["image"];
        // } else {
        //   throw apiResponse.error;
        // }
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }
}
