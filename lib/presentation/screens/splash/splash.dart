import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/main_screen.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/onboarding/on_boarding.dart';
import 'package:soom/style/color_manger.dart';
import '../../../data/cache/prefs.dart';
import '../../../main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  Timer? _timer2;
  double op = 0;
  _startDelay() {
    _timer = Timer( const Duration(seconds: 5), _goNext);
    _timer2 = Timer(const Duration(milliseconds: 50) , (){
       setState(() {
         op = 1 ;
       });
    });
  }

  PageRoute routeTo(){
    if(AppCubit.get(context).isNewInstall){
     return MaterialPageRoute(builder: (context) => const OnBoardingScreen(),);
    }else{
      AppCubit.get(context).getSystemConf(context);
      if(!AppCubit.get(context).goToLoginScreen){
        return MaterialPageRoute(builder: (context) {
          SharedPreferences.getInstance().then((prefs){
            token =  prefs.getString(PrefsKey.token) ?? "";
            idUser = "${ prefs.get(PrefsKey.userId) ?? "" }";
          });
         if(token.isNotEmpty){
           HomeCubit.get(context).getCategories(context).then((value){
             MyAuctionsCubit.get(context).getMyBids(context).then((value) => null);
             if(HomeCubit.get(context).products.isEmpty ){
               HomeCubit.get(context).getProducts(context ,  false).then((value){
                 HomeCubit.get(context).getCategoryBlocks(false);
                 return  const MainScreen();
               });
             }else{
               return  const MainScreen();
             }
           });
         }else{
           HomeCubit.get(context).getCategories(context).then((value){
             if(HomeCubit.get(context).products.isEmpty ){
               HomeCubit.get(context).getProducts(context,  false).then((value){
                 HomeCubit.get(context).getCategoryBlocks( false);
                 return  const MainScreen();
               });
             }else{
               return  const MainScreen();
             }
           });
         }

          return  const MainScreen();
        },);
      }else{
        return MaterialPageRoute(builder: (context) => const LoginScreen(),);
      }
    }
  }

  _goNext() {
    Navigator.pushReplacement(context, routeTo());
  }

  @override
  void initState() {

    super.initState();
    _startDelay();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.primary,
      statusBarBrightness: Brightness.light,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManger.primary,
          elevation: 0.0,
        ),
        body: Container(
          decoration:  const BoxDecoration(
            gradient:  LinearGradient(
              colors: [
                ColorManger.primary,
                ColorManger.primaryLight,
              ] ,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.3,
                0.9
              ],
            ),
          ),
          child: Center(
            child: AnimatedOpacity(
                duration: const Duration(seconds: 5),
                opacity: op,
                child: const LightLogo()),
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
}

