import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';


import '../../main.dart';
import '../cache/prefs.dart';

Dio dio(token) => Dio(BaseOptions(baseUrl: ApiBase.baseUrl, headers: {
  "Content-Type": "application/json",
  "Accept": "text/plain",
  "Authorization": "Bearer $token",
}));
class DioFactory {
  String newToken = token ;
  DioFactory(){
    //TODO: ADD LOGGER TO DIO
    // dio.interceptors.add(PrettyDioLogger());
    SharedPreferences.getInstance().then((prefs){
      newToken =  prefs.getString(PrefsKey.token)!;
    });
  }
  Future<Response> getData(String endpoint, Map<String, dynamic> query) async {
    return await dio(newToken).get(
      endpoint,
      queryParameters: query,
    );
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> query) async {
    return await dio(newToken).post(
      endpoint,
      data: query,
    );
  }

  Future<Response> updateData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio(newToken).put(endpoint, data: query);
  }


  Future<Response> deleteData(
      String endpoint, Map<String, dynamic> query) async {
    return await dio(newToken).delete(endpoint, queryParameters: query);
  }


}
