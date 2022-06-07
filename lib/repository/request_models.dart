
class LoginRequest {
  String email;
  String password;
  LoginRequest({required this.email, required this.password});
}

class RegisterRequest {
  String email;
  String password;
  String phone;
  String surName;
  String userName;
  String name;
  RegisterRequest({required this.name ,  required this.email, required this.password , required this.phone , required this.surName , required this.userName});
}

class ResetPasswordRequest {
 final  String token ;
 final  String password;
 ResetPasswordRequest(this.password , this.token );
}

