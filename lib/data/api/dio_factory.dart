import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';


import '../../main.dart';
import '../cache/prefs.dart';



class DioFactory {
  String newToken ;
  DioFactory(this.newToken);
  Dio dio() => Dio(BaseOptions(baseUrl: ApiBase.baseUrl, headers: {
    "Content-Type": "application/json",
    "Accept": "text/plain",
    "Authorization": "Bearer $newToken"  ,
  }));
  Future<Response> getData(String endpoint, Map<String, dynamic> query) async {
    return await dio().get(
      endpoint,
      queryParameters: query,
    );
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> query) async {
    return await dio().post(
      endpoint,
      data: query,
    );
  }

  Future<Response> updateData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio().put(endpoint, data: query);
  }


  Future<Response> deleteData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio().delete(endpoint, queryParameters: query);
  }


}
