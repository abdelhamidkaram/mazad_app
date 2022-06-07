import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/style/color_manger.dart';

import '../../main.dart';

Dio dio = Dio(BaseOptions(baseUrl: ApiBase.baseUrl, headers: {
  "Content-Type": "application/json",
  "Accept": "text/plain",
  "Authorization": "Bearer $token",
}));

class DioFactory {
  getData(String endpoint, Map<String, dynamic> query) async {
    return await dio.get(
      endpoint,
      queryParameters: query,
    );
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> query) async {
    return await dio.post(
      endpoint,
      data: query,
    );
  }

  Future<Response> updateData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio.put(endpoint, data: query);
  }
}
