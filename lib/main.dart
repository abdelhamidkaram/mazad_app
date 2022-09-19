
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_cubit.dart';
import 'package:soom/presentation/screens/splash/splash.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/theme_style.dart';
var  token = "";
var  id = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (error)=> const CustomErrorWidget();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferences.getInstance().then((value) async {
    if( value.getBool(PrefsKey.isLogin) ?? true){
      token = value.getString(PrefsKey.token)??"";
      id = value.get(PrefsKey.userId).toString();
    }
    });
  BlocOverrides.runZoned(
        () {
     runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color:ColorManger.lightGrey,child:  const Icon(Icons.error, color: ColorManger.red,),);
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>
        AppCubit()
          ..newInstallCache(context)
        ),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => BidCubit()),
        BlocProvider(create: (context) => FavoriteCubit()),
        BlocProvider(create: (context) => MyAuctionsCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => AppCubit(),
        builder: (context, state) {
          _checkInternet()async{
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult != ConnectivityResult.none) {
              AppCubit.get(context).isConnect = true ;
              await SharedPreferences.getInstance().then((value) async {
                if( value.getBool(PrefsKey.isLogin) ?? true  )  {
                  HomeCubit.get(context).getCategories(context).then((value) async{
                    await HomeCubit.get(context).getProducts(context).then((value){
                      HomeCubit.get(context).getCategoryBlocks() ;
                    });
                  });
                }
              });

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
          // home: const TestScreen(),
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


