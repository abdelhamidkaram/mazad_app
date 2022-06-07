import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/main_view/main_screen.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/presentation/screens/login/confirm.dart';
import 'package:soom/repository/repository.dart';
import 'package:soom/repository/request_models.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitState());
  static LoginCubit get(context)=> BlocProvider.of(context);
  final  Repository _repository = Repository() ;
  String errorMessage = '';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var resetPasswordController1 = TextEditingController();
  var resetPasswordController2 = TextEditingController();
  var phone = TextEditingController();
  bool finsh = false ;

  // ---------- isRemember ----------------|
bool isRemember = false;
changeIconRemember(){
  isRemember = !isRemember ;
  emit(IsRememberState());
}

  // ---------- show password  ----------------|
  bool isObscureText = true;
  showPassword(){
    isObscureText = !isObscureText ;
  emit(ShowPassword());
}
  bool isObscureText1 = true;
  showPassword1(){
    isObscureText1 = !isObscureText1 ;
  emit(ShowPassword());
}
bool isObscureText2 = true;
  showPassword2(){
    isObscureText2 = !isObscureText2;
  emit(ShowPassword());
}

  // ---------- Password Validation ----------------|

  passwordValidation(value , bool isLogin ){
    if (value!.length > 5) {
      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$');
      if (value!.isEmpty) {
        return 'ادخل كلمة المرور ';
      } else {
        if (!regex.hasMatch(value) && isLogin == false ) {
          return ''' يجب ان تحتوي كلمة المرور علي : 
                                حروف كبيره وصغيرة [A-Z] وارقام ورموز  ''';
        }
      }
    }else{
      return "كلمة المرور قصيرة جدا " ;
    }
  }

  // ---------- Email Validation ----------------|

  emailValidation(value){
    if (value!.isNotEmpty) {
      final bool isValid =
      EmailValidator.validate(value!);
      if (!isValid) {
        return "البريد الالكتروني غير صالح";
      }
    } else {
      return "لايمكن ترك الحقل فارغا";
    }
  }

  // ---------- Login ----------------|

  login(LoginRequest loginRequest , context )async {
  emit(LoginLoading());
  AppToasts.toastLoading(context);
  (
   await _repository.login(loginRequest)
  ).fold((error){
    emit(LoginError(error));
    Navigator.pop(context);
    AppToasts.toastError("حدث خطأ ما , تأكد من البيانات و أعد المحاولة لاحقا", context);
    emit(DialogShow());
  }, (loginSuccess){
    Navigator.pop(context);
    AppToasts.toastSuccess("تم الدخول بنجاح ! ", context );
    if (kDebugMode) {
      print(loginSuccess.result!.accessToken);
    }
    token = loginSuccess.result!.accessToken.toString();
    SharedPreferences.getInstance().then((prefs){
      prefs.setString(PrefsKey.token , loginSuccess.result?.accessToken ?? "").then((value){});
    });
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool(PrefsKey.isLogin , true);
    });
    emit(DialogShow());
    Timer(const Duration(seconds: 1), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen(),));
      emit(LoginSuccess(loginSuccess));
    });
  });
}


// ---------- register ----------------|
  register(RegisterRequest registerRequest , context )async {
    emit(RegisterLoading());
    AppToasts.toastLoading(context);
    (
        await _repository.register( context ,registerRequest)
    ).fold((error){
      emit(RegisterError(error));
      Navigator.pop(context);
      AppToasts.toastError(error.message, context);
      emit(DialogShow());
    }, (registerSuccess){
      Navigator.pop(context);
      //TODO: SEND CODE TO MOBILE
      AppToasts.toastSuccess(
          ''' تم التسجيل بنجاح ! 
يمكنك الان تأكيد حسابك من خلال رمز التفعيل المرسل لجوالك 
          ''', context );
      emit(DialogShow());
      Timer(const Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmScreen(phone: phone.text,),));
        emit(RegisterSuccess(registerSuccess));
      });
    });
  }


// ---------- reset password  ----------------|
// TODO: BLOC RESET PASSWORD



// ------------ confirm  -------------- |

var confirmController1 = TextEditingController();
var confirmController2= TextEditingController();
var confirmController3 = TextEditingController();
var confirmController4= TextEditingController();

int  focus  = 1 ;
String code = "" ;
String serverCode = "1234" ;

nextConformField(String value , int theFocus , TextEditingController controller , context) {
  focus = theFocus ;
  print(code);
  if(focus != 4 ){
    FocusScope.of(context).nextFocus();
  }else{
    // LoginCubit.get(context).focus = 1;
  }
  emit(NextConfirm());
}

checkConfirmCode (context){
  code = confirmController1.text+ confirmController2.text + confirmController3.text + confirmController4.text ;
  confirmController1.clear();
  confirmController2.clear();
  confirmController3.clear();
  confirmController4.clear();
     if(serverCode == code){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen(),));
     }else{
       emit(NextConfirm());
       code="";
       AppToasts.toastError("لقد أدخلت رمزا خاطئا ", context);
       emit(NextConfirm());
     }


    //TODO: CONFIRM MOBILE
  }

  getConfirmCodeFormServer(){
  // TODO:SEND PHONE NUMBER TO CONFIRM

  }

//---------- log out  ----------------|

logOut(context){
  emit(LogOutLoading());
  SharedPreferences.getInstance().then((prefs){
    prefs.setBool(PrefsKey.isLogin , false);
    prefs.remove(PrefsKey.token);
    emailController.text = "";
    passwordController.text = "";
    token = "";
    emit(LogOutSuccess());
  });
  emit(LogOutSuccess());
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
  emit(LogOutSuccess());

}








}