import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/main_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool gethome = false ;
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

return BlocConsumer<HomeCubit , HomeStates>(
    builder: (context, state){
  return Scaffold(
    backgroundColor: ColorManger.white,
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        getHomeData(context).then((value){
         
        });
      },
    ),
    body: SafeArea(
      child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/logoo.svg",
                color: ColorManger.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "مرحبا بعودتك",
                style: AppTextStyles.titleGreen_30,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                " تم تسجيل دخولك بنجاح وجاري تحميل بياناتك .. ",
                style: AppTextStyles.mediumBlack,
              ),
            ] ,

          )
      ),
    ),
  );
  
}, listener:(context, state)=> AppCubit() );

  }
}
