import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/app_bloc/bloc_observer.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/product/bloc/product_cubit.dart';
import 'package:soom/presentation/screens/splash/splash.dart';
import 'package:soom/style/theme_style.dart';
var  token = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  await SharedPreferences.getInstance().then((value) async {
    token = value.getString(PrefsKey.token) ?? "";
    });
  BlocOverrides.runZoned(
        () {
     runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>
        AppCubit()
          ..newInstallCache()
        ),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => BidCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => AppCubit(),
        builder: (context, state) {
          _checkInternet()async{
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult != ConnectivityResult.none) {
              AppCubit.get(context).isConnect = true ;
            }else{
              AppCubit.get(context).isConnect = false ;
            }
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              tabBarTheme: AppThemeStyles.tabBarTheme,
            ),
            home:  FutureBuilder(
              future: _checkInternet() ,
              builder:(context , snap)=> const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}


