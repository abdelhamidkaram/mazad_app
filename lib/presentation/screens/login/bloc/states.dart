 import 'package:soom/models/login_success.dart';
import 'package:soom/models/ragister_success.dart';
import 'package:soom/repository/error_model.dart';

abstract  class LoginStates {}

 class InitState extends LoginStates {}
// login
 class LoginLoading extends LoginStates {}
 class LoginSuccess extends LoginStates {
 LoginSuccessModel loginSuccessModel ;
 LoginSuccess(this.loginSuccessModel);
 }
 class LoginError extends LoginStates {
  ErrorModel errorModel ;
  LoginError(this.errorModel);
 }
// register
 class RegisterLoading extends LoginStates {}
 class RegisterSuccess extends LoginStates {
  RegisterSuccessModel registerSuccessModel ;
  RegisterSuccess(this.registerSuccessModel);
 }
 class RegisterError extends LoginStates {
  ErrorModel errorModel ;
  RegisterError(this.errorModel);
 }



 class GetPrivacySuccess extends LoginStates {}
 class GetPrivacyError extends LoginStates {}


 // confirm
 class NextConfirm extends LoginStates {}


 // confirm

 class IsRememberState extends LoginStates {}


 class ShowPassword extends LoginStates {}
 class DialogShow extends LoginStates {}


// log out
class LogOutLoading extends LoginStates {}
class LogOutSuccess extends LoginStates {}
class LogOutError extends LoginStates {
  ErrorModel errorModel ;
  LogOutError(this.errorModel);
}

