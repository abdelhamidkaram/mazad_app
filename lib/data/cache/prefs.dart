
import 'package:shared_preferences/shared_preferences.dart';

// shared_preferences class


class PrefsKey {
  static const String isNewInstall = "isNewUser" ;
  static const String isLogin = "isLogin" ;
  static const String token = "token" ;
  static const String img64 = "img64" ;
  static const String isUploadImage = "isUploadImage" ;

}

// class Prefs  {
//   static SharedPreferences? pref =   AppCubit().appPreferences;
//   static String? getDataString(String key){
//    return pref!.getString(key);
//   }
//   // get data
//   static getData(String key ) {
//        return pref!.get(key);
// }
//
// // set data
//   static setDataBool(String key , bool value ) {
//     getPrefInstance().then((prefs) {
//       prefs.setBool(key,value);
//     });
//   }
//    static setDataString(String key , String value ) {
//     getPrefInstance().then((prefs) {
//       prefs.setString(key,value).then((value) => null);
//     });
//   }
//     static setDataInt(String key , int value ) {
//     getPrefInstance().then((prefs) {
//       prefs.setInt(key,value);
//     });
//   }
//      static setDataDouble(String key , double value ) {
//     getPrefInstance().then((prefs) {
//       prefs.setDouble(key,value);
//     });
//   }
//
// }


