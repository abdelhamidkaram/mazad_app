
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/repository/repository.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

static AppCubit get(context) => BlocProvider.of(context);
 bool  isConnect = true ;
bool isNewInstall = true ;
  bool goToLoginScreen =  false ;
  int onBoardingIndex = 0 ;
  PageController pageController = PageController();


  newInstallCache(context)async {
    SharedPreferences.getInstance().then((value){
      // from splash to onBoarding
      if(value.getBool(PrefsKey.isNewInstall) != null && value.getBool(PrefsKey.isNewInstall) == false  ){
        isNewInstall = false ;
        HomeCubit.get(context).isFirstBuild = true ;
      }
      // from splash to login
      if(value.getBool(PrefsKey.isLogin) != null && value.getBool(PrefsKey.isLogin) == true  ){
        goToLoginScreen = true ;
        HomeCubit.get(context).isFirstBuild = true ;
      }
    });
  }


  final  Repository _repository = Repository() ;
  //get profile details
  ProfileEditSuccess profileEditSuccess = ProfileEditSuccess();
  getProfileDetails(context )async {
    emit(GetProfileDetailsLoading(  ));
    (await _repository.getProfileDetails()).fold(
            (error){
              Timer(const Duration(seconds: 1), (){
                LoginCubit.get(context).logOut(context);
              });
          emit(GetProfileDetailsError());
        },
            (profileSuccess){
          emit(GetProfileDetailsSuccess());
          profileEditSuccess = profileSuccess;
        }
    );
  }
}

