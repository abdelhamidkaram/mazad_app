import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/main.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/repository/repository.dart';

import '../../models/system_conf_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isConnect = true;

  bool isNewInstall = true;

  bool goToLoginScreen = false;

  int onBoardingIndex = 0;

  PageController pageController = PageController();

  newInstallCache(context) async {
    SharedPreferences.getInstance().then((value) {
      emit(NewInstallLoading());
      // from splash to onBoarding
      if (value.getBool(PrefsKey.isNewInstall) != null &&
          value.getBool(PrefsKey.isNewInstall) == false) {
        isNewInstall = false;
        HomeCubit.get(context).isFirstBuild = true;
      }
      // from splash to login
      if (value.getBool(PrefsKey.isLogin) != null &&
          value.getBool(PrefsKey.isLogin) == true) {
        goToLoginScreen = true;
        HomeCubit.get(context).isFirstBuild = true;
        emit(NewInstallSuccess());
      }
    });
  }

  final Repository _repository = Repository();

  //get profile details
  ProfileEditSuccess profileEditSuccess = ProfileEditSuccess();

  Future getProfileDetails(context) async {
    emit(GetProfileDetailsLoading());
  if(token.isNotEmpty){
    (await _repository.getProfileDetails()).fold((error) {
      LoginCubit.get(context).logOut(context);
      emit(GetProfileDetailsError());
    }, (profileSuccess) async {
      profileEditSuccess = profileSuccess;
      getSystemConf(context).then((value) => null);
      emit(GetProfileDetailsSuccess());
    });
  }
  }

  //getSystemConfiguration
  List<SystemConfigrationModel> allConfigurations = [];
  List<SystemConfigrationModel> ads = [];
  String phone = "";
  String aboutUs = "";
  String privacyPolicy = "";

  Future getSystemConf(context) async {
    emit(GetSystemConfLoading());
    await DioFactory(token)
        .getData(ApiEndPoint.getSystemConf, {}).then((value) {
      List responseList = value.data["result"]["items"];
      allConfigurations =
          responseList.map((e) => SystemConfigrationModel.fromJson(e)).toList();
      List<SystemConfigrationModel>  _list = [] ;
      for (var element in allConfigurations) {
      if(element.systemConfigration!.keyName!.contains("ad")){
        _list.add(element);
      }
      ads = _list ;

      emit(GetSystemConfSuccess());
     }

     emit(GetSystemConfSuccess());
    }).catchError((err) {
      LoginCubit.get(context).logOut(context);
      emit(GetSystemConfError());
    });
  }
}
