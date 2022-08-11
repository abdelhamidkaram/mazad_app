
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/repository/repository.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

static AppCubit get(context) => BlocProvider.of(context);
 bool  isConnect = true ;
bool isNewInstall = true ;
  bool goToLoginScreen =  false ;
  int onBoardingIndex = 0 ;
  PageController pageController = PageController();


  newInstallCache()async {
    SharedPreferences.getInstance().then((value){
      // from splash to onBoarding
      if(value.getBool(PrefsKey.isNewInstall) != null && value.getBool(PrefsKey.isNewInstall) == false  ){
        isNewInstall = false ;
      }
      // from splash to login
      if(value.getBool(PrefsKey.isLogin) != null && value.getBool(PrefsKey.isLogin) == true  ){
        goToLoginScreen = true ;
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
              AppToasts.toastError("يرجي اعادة تسجيل الدخول ", context);
              Timer(const Duration(seconds: 1), (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen() ,));
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

