import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/logger/logger.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:network_calls/src.dart';

class Repository {
  final NetworkCalls _api;

  Repository({required NetworkCalls api}) : _api = api;

  Future<int> addVehicle(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addVehicle', data: payload);

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
    print(apiResponse.response);
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

  Future<Map<String, dynamic>> getHistory(String query, int pageNo,
      {String? vehicleRegNo}) async {
    ApiResponse apiResponse = await _api.get('getHistory', queryParameters: {
      "param": query,
      "pageNo": pageNo,
      "vehicleRegNo": vehicleRegNo ?? ""
    });

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<Map<String, dynamic>> getLocations() async {
    ApiResponse apiResponse = await _api.get("getLocations");

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
        return jsonDecode(apiResponse.response!.data);
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }

  Future<Map<String, dynamic>> getInspection(String jobCardNo) async {
    ApiResponse apiResponse = await _api
        .get('getInspection', queryParameters: {"jobCardNo": jobCardNo});

    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        return jsonDecode(apiResponse.response!.data);
      } else {
        throw apiResponse.error;
      }
    } else {
      throw Error();
    }
  }

  Future<List<dynamic>> getSalesPersons(String searchText) async {
    print(searchText);
    ApiResponse apiResponse = await _api
        .get('getSalesPerson', queryParameters: {"search_text": searchText});
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          print(jsonDecode(apiResponse.response!.data)["data"].runtimeType);
          return (jsonDecode(apiResponse.response!.data)["data"]);
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

  Future<int> addVehicleMedia(Map<String, dynamic> image) async {
    print(image);
    ApiResponse apiResponse = await _api.post('addImage', data: {
      "image": jsonEncode(image),
    });
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          return 200;
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

  Future<int> addinspection(Map<String, dynamic> payload) async {
    ApiResponse apiResponse = await _api.post('addInspection', data: payload);
    if (apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      if (response["response_code"] == 200) {
        return response["response_code"];
      } else {
        return response["response_code"];
      }
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<Map<String, dynamic>> authenticateUser(
      String username, String password) async {
    ApiResponse apiResponse = await _api.get('authenticateUser',
        queryParameters: {"username": username, "password": password});

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final response = jsonDecode(apiResponse.response!.data);
      return response;
    } else {
      Log.e(apiResponse.error);
      throw Error();
    }
  }

  Future<int> updateJobCardStatus(
      String jobCardStatus, String jobCardNo) async {
    ApiResponse apiResponse = await _api.post('updateJobCardStatus',
        queryParameters: {"status": jobCardStatus, "jobCardNo": jobCardNo});
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

  Future getImage(String jobCardNo) async {
    ApiResponse apiResponse =
        await _api.get('getImage', queryParameters: {"jobCardNo": jobCardNo});
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

  Future<int> addVehiclePartMedia(
      {Map<String, dynamic>? bodyPartData,
      required String id,
      required String name}) async {
    print(bodyPartData);
    ApiResponse apiResponse = await _api.post('addVehiclePartMedia', data: {
      "id": id,
      "name": name,
      "data": jsonEncode(bodyPartData),
    });
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          return 200;
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

  Future<int> addQualityStatus({Map<String, dynamic>? qualityCheckJson}) async {
    print(qualityCheckJson);
    ApiResponse apiResponse =
        await _api.post('qualityCheckStatus', data: qualityCheckJson);
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        Log.d(apiResponse.response);
        if (jsonDecode(apiResponse.response!.data)["response_code"] == 200) {
          return 200;
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

  Future getGatePass({required String jobCardNo}) async {
    ApiResponse apiResponse =
        await _api.get('gatePass', queryParameters: {"jobCardNo": jobCardNo});
    if (apiResponse.response != null) {
      if (apiResponse.response!.statusCode == 200) {
        if ((apiResponse.response!.data)["count"] == 1) {
          return (apiResponse.response!.data)["items"][0];
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
}
