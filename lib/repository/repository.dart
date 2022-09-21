import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/login_success.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/models/ragister_success.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/repository/error_model.dart';
import 'package:soom/repository/request_models.dart';

import '../data/cache/prefs.dart';
import '../main.dart';
import '../models/bids_model.dart';
import '../presentation/screens/main_view/bloc/home_cubit.dart';
import '../presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';

class Repository {
  // ------------ login --------------//
  Future<Either<ErrorModel, LoginSuccessModel>> login(
      LoginRequest loginRequest, context) async {
    Response _response;
    try {
      _response = await DioFactory(token).postData(ApiEndPoint.authentication, {
        "userNameOrEmailAddress": loginRequest.email,
        "password": loginRequest.password,
      });
    } catch (error) {
      return Left(ErrorModel(
          message: "فشل تسجيل الدخول : تحقق من بياناتك واعد المحاولة",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      token = _response.data["result"]['accessToken'];
      SharedPreferences.getInstance().then((value) {
        value
            .setString(PrefsKey.token,
                _response.data["result"]['accessToken'].toString())
            .then((value) => null);
        value
            .setInt(PrefsKey.userId, _response.data["result"]['userId'])
            .then((value) => null);
      });
      return Right(LoginSuccessModel.fromJson(_response.data));
    } else {
      return Left(ErrorModel(
        statusCode: _response.hashCode,
        message: "فشل تسجيل الدخول : تحقق من بياناتك واعد المحاولة",
      ));
    }
  }

  // ------------ register  --------------//
  Future<Either<ErrorModel, RegisterSuccessModel>> register(
      RegisterRequest registerRequest, context) async {
    Response _response;
    try {
      _response = await DioFactory(token).postData(ApiEndPoint.register, {
        "emailAddress": registerRequest.email,
        "name": registerRequest.name,
        "password": registerRequest.password,
        "surname": registerRequest.surName,
        "userName": registerRequest.userName,
        // "phone": registerRequest.phone, TODO : ADD PHONE
      });
    } catch (error) {
      return Left(ErrorModel(
          message: "فشل التسجيل  : تحقق من بياناتك واعد المحاولة",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      return Right(RegisterSuccessModel.fromJson(_response.data));
    } else {
      return Left(ErrorModel(
        statusCode: _response.hashCode,
        message: "فشل التسجيل  : تحقق من بياناتك واعد المحاولة",
      ));
    }
  }

  // ------------ reset password   --------------//

//TODO:RESET PASSWORD

// ------------ get profile Details   --------------//

  Future<Either<ErrorModel, ProfileEditSuccess>> getProfileDetails() async {
    Response _response;
    try {
      _response =
          await DioFactory(token).getData(ApiEndPoint.getProfileDetails, {});
    } catch (error) {
      print("profile  error : :::::::::::::::::::::::: ");
      print(error.toString());
      return Left(ErrorModel(
          message: error.toString() +
              "\n" +
              "فشل جلب معلومات حسابك في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      return Right(ProfileEditSuccess.fromJson(_response.data));
    } else {
      return Left(ErrorModel(
        statusCode: _response.hashCode,
        message: "فشل جلب معلومات حسابك في الوقت الحالي يرجي المحاولة لاحقا",
      ));
    }
  }

// ------------ get all products details   --------------//

  Future<Either<ErrorModel, List<ProductForViewModel>>> getProducts(
      {int? maxResult, List<BidsModel>? lastBids}) async {
    Response _response;
    try {
      if (maxResult != null) {
        _response =
            await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
          "MaxResultCount": maxResult,
        });
      } else {
        _response =
            await DioFactory(token).getData(ApiEndPoint.getAllProducts, {});
      }
    } catch (error) {
      return Left(ErrorModel(
          message: (kDebugMode ? error.toString() + "\n" : "") +
              "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      List _productsResponse = _response.data["result"]["items"];
      List<ProductModel> _products = _productsResponse.map((e) {
        return ProductModel.fromJson(e);
      }).toList();
      return Right(_products
          .map((product) => ProductForViewModel("", product))
          .toList());
    } else {
      return Left(ErrorModel(
          message: "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: _response.hashCode));
    }
  }

// ------------ get products Details based on category name    --------------//

  Future<Either<ErrorModel, List<ProductModel>>> getProductsBaseOnCategoryName(
      {int? maxResult, String? categoryName}) async {
    Response _response;
    try {
      if (maxResult != null) {
        if (categoryName != null) {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "MaxResultCount": maxResult,
            "CategoryNameFilter": categoryName,
          });
        } else {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "MaxResultCount": maxResult,
          });
        }
      } else {
        if (categoryName != null) {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "CategoryNameFilter": categoryName,
          });
        } else {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {});
        }
      }
    } catch (error) {
      return Left(ErrorModel(
          message: (kDebugMode ? error.toString() + "\n" : "") +
              "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      List _products = _response.data["result"]["items"];
      return Right(
          _products.map((product) => ProductModel.fromJson(product)).toList());
    } else {
      return Left(ErrorModel(
          message: "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: _response.hashCode));
    }
  }

// ------------ get products Details based on search    --------------//

  Future<Either<ErrorModel, List<ProductModel>>> getProductsBaseOnSearchFilter(
      {int? maxResult, String? searchKeywords}) async {
    Response _response;
    try {
      if (maxResult != null) {
        if (searchKeywords != null) {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "MaxResultCount": maxResult,
            "Filter": searchKeywords,
          });
        } else {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "MaxResultCount": maxResult,
          });
        }
      } else {
        if (searchKeywords != null) {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
            "Filter": searchKeywords,
          });
        } else {
          _response =
              await DioFactory(token).getData(ApiEndPoint.getAllProducts, {});
        }
      }
    } catch (error) {
      return Left(ErrorModel(
          message: (kDebugMode ? error.toString() + "\n" : "") +
              "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      List _products = _response.data["result"]["items"];
      return Right(
          _products.map((product) => ProductModel.fromJson(product)).toList());
    } else {
      return Left(ErrorModel(
          message: "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: _response.hashCode));
    }
  }

// ------------ get products Details based on  filter    --------------//

  Future<Either<ErrorModel, List<ProductModel>>> getProductsBaseOnFilter({
    required int maxResult,
    required List<int> categoryIds,
    required bool isMost,
    required bool isLess,
    required bool isNew,
    required bool isOld,
    required double minRang,
    required double maxRang,
  }) async {
    Response _response;
    try {
      _response = await DioFactory(token).getData(ApiEndPoint.getAllProducts, {
        "MaxResultCount": maxResult,
        "CategoryIds": categoryIds,
        "MaxminPriceFilter": maxRang,
        "MinminPriceFilter": minRang,
      });
    } catch (error) {
      print(error.toString());
      return Left(ErrorModel(
          message: "حدث خطأ ما يرجي المحاولة لاحقا!",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      List _products = _response.data["result"]["items"];
      print(_products);
      List<ProductModel> products =
          _products.map((product) => ProductModel.fromJson(product)).toList();
      if (isNew) {
        products.reversed;
      }
      if (isMost) {
        products.sort(
          (a, b) {
            return a.product!.intitalPrice!
                .toInt()
                .compareTo(b.product!.intitalPrice!.toInt());
          },
        );
      }
      if (isLess) {
        products.sort(
          (a, b) {
            return a.product!.minPrice!
                .toInt()
                .compareTo(b.product!.minPrice!.toInt());
          },
        );
        products.reversed;
      }

      return Right(products);
    } else {
      return Left(ErrorModel(
          message: "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: _response.hashCode));
    }
  }

// ------------ get  categories    --------------//

  Future<Either<ErrorModel, List<CategoryModel>>> getCategories(
      {int? maxResult}) async {
    Response _response;
    try {
      if (maxResult != null) {
        _response =
            await DioFactory(token).getData(ApiEndPoint.getAllCategories, {
          "MaxResultCount": maxResult,
        });
      } else {
        _response =
            await DioFactory(token).getData(ApiEndPoint.getAllCategories, {});
      }
    } catch (error) {
      return Left(ErrorModel(
          message: (kDebugMode ? error.toString() + "\n" : "") +
              "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: error.hashCode));
    }
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      List _categories = _response.data["result"]["items"];
      return Right(_categories
          .map((category) => CategoryModel.fromJson(category["category"]))
          .toList());
    } else {
      if (_response.statusCode! == 401 && token.isNotEmpty) {
        DioFactory(token).getData(ApiEndPoint.getRefreshToken,
            {"refreshToken": refreshToken}).then((value) async {
          if (kDebugMode) {
            print("\n \n \n refresh token success \n \n \n ");
          }
          token = value.data["result"]["accessToken"];
          await SharedPreferences.getInstance().then((pref) async {
            await pref.setString(
                PrefsKey.token, value.data["result"]["accessToken"]);
          });
          getCategories();
        });
      }
      return Left(ErrorModel(
          message: "فشل جلب المعلومات في الوقت الحالي يرجي المحاولة لاحقا ",
          statusCode: _response.hashCode));
    }
  }

// ------------ upload  products details    --------------//

  Future<Either<ErrorModel, Map<String, dynamic>>> uploadProductDetails(
      {required Map<String, dynamic> data}) async {
    Response _response;
    try {
      _response =
          await DioFactory(token).postData(ApiEndPoint.uploadProducts, data);
    } catch (error) {
      return Left(
        ErrorModel(
            message: (kDebugMode ? error.toString() + "\n" : "") +
                "فشل رفع المنتجات في الوقت الحالي حاول لاحقا ! ",
            statusCode: error.hashCode),
      );
    }
    print(_response.data);
    if (_response.statusCode! >= 200 && _response.statusCode! <= 299) {
      return Right(_response.data);
    } else {
      return Left(ErrorModel(
          message: "فشل رفع المنتجات في الوقت الحالي حاول لاحقا !  ",
          statusCode: _response.hashCode));
    }
  }
}
