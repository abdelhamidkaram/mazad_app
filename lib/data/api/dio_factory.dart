import 'package:dio/dio.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import '../../main.dart';

Dio dio = Dio(BaseOptions(baseUrl: ApiBase.baseUrl, headers: {
  "Content-Type": "application/json",
  "Accept": "text/plain",
  "Authorization": "Bearer $token",
}));
class DioFactory {
  DioFactory(){
    //TODO: ADD LOGGER TO DIO
    // dio.interceptors.add(PrettyDioLogger());
  }
  Future<Response> getData(String endpoint, Map<String, dynamic> query) async {
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


  Future<Response> deleteData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio.delete(endpoint, queryParameters: query);
  }


}
