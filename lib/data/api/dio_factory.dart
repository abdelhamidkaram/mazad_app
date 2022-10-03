import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/cache/prefs.dart';
import '../../main.dart';
int refresh = 0;

class DioFactory {
  String newToken;
  bool noToken;

  DioFactory(this.newToken, {this.noToken = false});

  Dio dio(){
    Dio _dio = Dio(BaseOptions(
      baseUrl: ApiBase.baseUrl,
      headers: !noToken
          ?
      {
        "Content-Type": "application/json",
        "Accept": "text/plain",
        "Authorization": "Bearer $newToken",
      }
          :
      {
        "Content-Type": "application/json",
        "Accept": "text/plain",
      } ,
    ));
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (DioError error, handler) async {
        if ((error.response?.statusCode == 401)) {
          if (refreshToken.isNotEmpty) {
            if (await _refreshToken()) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
        }
        return handler.next(error);
      }
    ));
    return _dio ;
  }
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio().request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> _refreshToken() async {
    if(refresh == 1){
      return false ;
    }
    final response = await dio()
        .post("api/TokenAuth/RefreshToken?refreshToken=$refreshToken",);
    if (response.statusCode == 200) {
      token = response.data["result"]["accessToken"];
      newToken = response.data["result"]["accessToken"];
      await SharedPreferences.getInstance().then((value) async {
        await value.setString(PrefsKey.token,response.data["result"]["accessToken"] );
      });
      refresh = 1 ;
      return true;
    } else {
      refresh = 1 ;
      token = "";
      return false;
    }
  }
  Future<Response> getData(String endpoint, Map<String, dynamic> query) async {
   Response _response = await dio().get(
      endpoint,
      queryParameters: query,
    );

   return _response;
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
