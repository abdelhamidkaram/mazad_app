import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/main_screen.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/repository/repository.dart';
import 'package:soom/repository/request_models.dart';
import '../../../../constants/api_constants.dart';
import '../../../app_bloc/app_cubit.dart';
import '../../main_view/bloc/home_cubit.dart';
import '../../main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/main.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  final Repository _repository = Repository();

  String errorMessage = '';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var resetPasswordController1 = TextEditingController();
  var resetPasswordController2 = TextEditingController();
  var phone = TextEditingController();
  bool finsh = false;

  // ---------- isRemember ----------------|
  bool isRemember = false;

  changeIconRemember() {
    isRemember = !isRemember;
    emit(IsRememberState());
  }

  // ---------- show password  ----------------|
  bool isObscureText = true;

  showPassword() {
    isObscureText = !isObscureText;
    emit(ShowPassword());
  }

  bool isObscureText1 = true;

  showPassword1() {
    isObscureText1 = !isObscureText1;
    emit(ShowPassword());
  }

  bool isObscureText2 = true;

  showPassword2() {
    isObscureText2 = !isObscureText2;
    emit(ShowPassword());
  }

  // ---------- Password Validation ----------------|

  String? passwordValidation(value, bool isLogin) {
    if (value!.length > 5) {
      RegExp regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$');
        // if (!regex.hasMatch(value) && isLogin == false) {
        //   return ''' يجب ان تحتوي كلمة المرور علي :
        //                         حروف كبيره وصغيرة [A-Z] وارقام ورموز  ''';
        // }
        return null ;

    } else {
      if (value!.isEmpty) {
        return 'ادخل كلمة المرور ';
      }
      return "كلمة المرور قصيرة جدا ";
    }
  }

  // ---------- Email Validation ----------------|

  String ? emailValidation (value) {
    if (value!.isNotEmpty) {
      final bool isValid = EmailValidator.validate(value!);
      if (!isValid) {
        return "البريد الالكتروني غير صالح";
      }
    } else {
      return "لايمكن ترك الحقل فارغا";
    }
    return null;
  }

  // ---------- Login ----------------|
  Future<bool> loginUser(
      LoginRequest loginRequest, BuildContext context) async {
    Dio _dio = Dio(BaseOptions(baseUrl: ApiBase.baseUrl, headers: {
      "Content-Type": "application/json",
      "Accept": "text/plain",
    } ,),
    );
    try{
      Response value = await _dio.post(ApiBase.baseUrl + ApiEndPoint.authentication, data:{
        "userNameOrEmailAddress": loginRequest.email,
        "password": loginRequest.password,
      });
      if(value.statusCode == 200){
        token = value.data["result"]["accessToken"];
        refreshToken = value.data["result"]["refreshToken"];
        idUser = value.data["result"]["userId"].toString();
        SharedPreferences.getInstance().then((pref) async {
          pref.setString(PrefsKey.token, token).then((value) {});
          pref.setString(PrefsKey.refreshToken, refreshToken).then((value) {});
          await pref.setString(PrefsKey.userId, idUser);
          await pref.setBool(PrefsKey.isLogin, true);
        });
        await getHomeData(context);
        return true ;
      }else{
        return false;
      }
    }catch(err){
      if (kDebugMode) {
        print(err.toString());
      }
      return false ;
    }

  }

// ---------- register ----------------|
  String privacyPolicy = "";

  Future getPrivacyPolicy() async {
    DioFactory(token).getData(ApiEndPoint.getSystemConf,
        {"KEYNameFilter": "privacyPolicy"}).then((value) {
      privacyPolicy = value.data["result"]["items"][0]["systemConfigration"]
          ["slideDescription"];
      emit(GetPrivacySuccess());
    }).catchError((err) {
      if (kDebugMode) {
        print(err.toString());
      }
      emit(GetPrivacyError());
    });
  }

  register(RegisterRequest registerRequest, BuildContext context) async {
    emit(RegisterLoading());
    AppToasts.toastLoading("جاري تسجيل حسابك");
    (await _repository.register(
      registerRequest,
      context,
    )).fold((error) {
      emit(RegisterError(error));
      emailController.text = "";
      phone.text = "";
      passwordController.text = "";
      AppToasts.toastError(error.message);
      emit(DialogShow());
    }, (registerSuccess) {
      var login = LoginRequest(
        email: registerRequest.email,
        password: registerRequest.password ,
      );
      loginUser(login, context).then((value) async  {
        HomeCubit.get(context).currentIndex = 0 ;
        MyAuctionsCubit.get(context).isEmpty = true ;
        MyAuctionsCubit.get(context).isEmptyLast = true ;
          AppToasts.toastSuccess("تم التسجيل بنجاح");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      }).catchError((err) {
        if (kDebugMode) {
          print(err.toString());
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      });
      emit(DialogShow());
    });
  }

// ---------- reset password  ----------------|
// TODO: BLOC RESET PASSWORD

// ------------ confirm  -------------- |

  var confirmController1 = TextEditingController();
  var confirmController2 = TextEditingController();
  var confirmController3 = TextEditingController();
  var confirmController4 = TextEditingController();

  int focus = 1;

  String code = "";

  String serverCode = "1234";

  nextConformField(
      String value, int theFocus, TextEditingController controller, BuildContext context) {
    focus = theFocus;
    if (kDebugMode) {
      print(code);
    }
    if (focus != 4) {
      FocusScope.of(context).nextFocus();
    } else {
      // LoginCubit.get(context).focus = 1;
    }
    emit(NextConfirm());
  }

  checkConfirmCode(context) {
    code = confirmController1.text +
        confirmController2.text +
        confirmController3.text +
        confirmController4.text;
    confirmController1.clear();
    confirmController2.clear();
    confirmController3.clear();
    confirmController4.clear();
    if (serverCode == code) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ));
    } else {
      emit(NextConfirm());
      code = "";
      AppToasts.toastError("لقد أدخلت رمزا خاطئا ");
      emit(NextConfirm());
    }

    //TODO: CONFIRM MOBILE
  }

  getConfirmCodeFormServer() {
    // TODO:SEND PHONE NUMBER TO CONFIRM
  }

//---------- log out  ----------------|

  logOut(BuildContext context) {
    emit(LogOutLoading());
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(PrefsKey.isLogin, false);
      prefs.remove(PrefsKey.token);
      prefs.remove(PrefsKey.refreshToken);
      prefs.remove(PrefsKey.userId);
      emailController.text = "";
      passwordController.text = "";
      token = "";
      refreshToken = "";
      idUser = "";
      AppCubit.get(context).clearData();
      MyAuctionsCubit.get(context).clearData();
      FavoriteCubit.get(context).clearData();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
      emit(LogOutSuccess());
    });
  }
}
