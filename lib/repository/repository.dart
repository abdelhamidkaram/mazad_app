import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/login_success.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/models/ragister_success.dart';
import 'package:soom/repository/error_model.dart';
import 'package:soom/repository/request_models.dart';

class Repository {


  // ------------ login --------------//
  Future<Either<ErrorModel, LoginSuccessModel>> login(
      LoginRequest loginRequest ) async {
    Response _response ;
 try{
   _response =  await  DioFactory().postData( ApiEndPoint.authentication, {
       "userNameOrEmailAddress": loginRequest.email,
       "password": loginRequest.password,
     });
   }catch(error){
     return Left(ErrorModel(message: "فشل تسجيل الدخول : تحقق من بياناتك واعد المحاولة", statusCode: error.hashCode)) ;
   }
   if(_response.statusCode!  >=  200 && _response.statusCode! <= 299  ){
     return Right(LoginSuccessModel.fromJson(_response.data));
   }else{
     return Left(ErrorModel(statusCode: _response.hashCode , message:"فشل تسجيل الدخول : تحقق من بياناتك واعد المحاولة" ,) );
   }

  }


    // ------------ register  --------------//
  Future<Either<ErrorModel, RegisterSuccessModel>> register(
      RegisterRequest registerRequest , context ) async {
    Response _response ;
 try{
   _response =  await  DioFactory().postData( ApiEndPoint.register, {
     "emailAddress":registerRequest.email,
     "name": registerRequest.name,
     "password": registerRequest.password,
     "surname": registerRequest.surName,
     "userName": registerRequest.userName,
     // "phone": registerRequest.phone, TODO : ADD PHONE
     });
   }catch(error){
     return Left(ErrorModel(message: "فشل التسجيل  : تحقق من بياناتك واعد المحاولة", statusCode: error.hashCode)) ;
   }
   if(_response.statusCode!  >=  200 && _response.statusCode! <= 299  ){
     return Right(RegisterSuccessModel.fromJson(_response.data));
   }else{
     return Left(ErrorModel(statusCode: _response.hashCode , message:"فشل التسجيل  : تحقق من بياناتك واعد المحاولة" ,) );
   }

  }

    // ------------ reset password   --------------//
//TODO:RESET PASSWORD

// ------------ get profile Details   --------------//

Future<Either<ErrorModel , ProfileEditSuccess>> getProfileDetails() async {
  Response _response ;
  try{
    _response =  await  DioFactory().getData( ApiEndPoint.getProfileDetails, {});
  }catch(error){
    return Left(ErrorModel(message:  error.toString() + "\n" + "فشل جلب معلومات حسابك في الوقت الحالي يرجي المحاولة لاحقا ", statusCode: error.hashCode)) ;
  }
  if(_response.statusCode!  >=  200 && _response.statusCode! <= 299  ){
    return Right(ProfileEditSuccess.fromJson(_response.data));
  }else{
    return Left(ErrorModel(statusCode: _response.hashCode , message:"فشل جلب معلومات حسابك في الوقت الحالي يرجي المحاولة لاحقا" ,) );
  }

}


// ------------ get profile Details   --------------//

Future<Either<ErrorModel , List<ProductModel>>> getProducts({int? maxResult }) async {
    Response _response ;
   try{
    if(maxResult != null ){
      _response = await DioFactory().getData(ApiEndPoint.getAllProducts , {
        "MaxResultCount": maxResult ,
      });
    }else {
      _response = await DioFactory().getData(ApiEndPoint.getAllProducts , {

      });
    }
   }catch(error){
     return Left(ErrorModel(message: ( kDebugMode ? error.toString()+ "\n"  : "" ) + "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ", statusCode: error.hashCode)) ;
   }
    if(_response.statusCode!  >=  200 && _response.statusCode! <= 299  ){
      List _products = _response.data["result"]["items"] ;
      return Right(
         _products.map((product) => ProductModel.fromJson(product)).toList()
      );
    }else{
      return Left(ErrorModel(message:  "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ", statusCode: _response.hashCode)) ;
    }

}



}

