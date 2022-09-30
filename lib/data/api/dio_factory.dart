import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import '../../main.dart';
import '../cache/prefs.dart';

class DioFactory {
  String newToken;
  bool noToken;

  DioFactory(this.newToken, {this.noToken = false});

  Dio dio() => Dio(BaseOptions(
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

  Future<Response> getData(String endpoint, Map<String, dynamic> query) async {
   Response _response = await dio().get(
      endpoint,
      queryParameters: query,
    );
   if (_response.statusCode! == 401 && refreshToken.isNotEmpty) {
     await getRefreshToken().then((value){
       getData(endpoint, query);
     }).catchError((err){
       if (kDebugMode) {
         print("error when refresh token :: \n "+err.toString());
       }
     });
   }
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
  Future<void> getRefreshToken() async {
   await DioFactory(token , noToken: true).getData(ApiEndPoint.getRefreshToken,
        {"refreshToken": refreshToken}).then((value) async {
      if (kDebugMode) {
        print("\n \n \n refresh token success \n \n \n ");
      }
      token = value.data["result"]["accessToken"];
      await SharedPreferences.getInstance().then((pref) async {
        await pref.setString(
            PrefsKey.token, value.data["result"]["accessToken"]);
      });
    });

  }

}
