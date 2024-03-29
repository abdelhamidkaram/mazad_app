import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/add_auction/add_auction_screen.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/favorite_screen.dart';
import 'package:soom/presentation/screens/main_view/home_screen/home_screen.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_auctions_screen.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/presentation/screens/profile/screens/profile_home.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'my_auctions/bloc/my_auctions_cubit.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.white,
      statusBarBrightness: Brightness.light,
    ));
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() {
          if (result != ConnectivityResult.none) {
            setState(() { isConnect = true; }
            );
          } else {
            isConnect = false;
          }
        });
      },
    );
    super.initState();
  }

  bool isConnect = true;

  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) => HomeCubit(),
      builder: (context, state) {
        var homeCubit = HomeCubit.get(context);
        List<bool> cartViewsAndElevation = [true, true, true, true, false];
        List<String> titles = [
          "الرئيسية",
          "مزاداتي",
          "اضافة منتج",
          " المفضلة ",
          " حسابي "
        ];
        List<Widget> screens = [
          HomeScreen(
            homeCubit: homeCubit,
            state: state,
          ),
          const MyAuctions(),
          const AddAuctionScreen(),
          const FavoriteScreen(),
          const ProfileHome(),
        ];
        PageController pageController = PageController();

        return isConnect
            ? Directionality(
                textDirection: TextDirection.rtl,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: WillPopScope(
                    onWillPop: () => homeCubit.onWillPop(context),
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        backgroundColor: ColorManger.white,
                        appBar: AppBars.appBarGeneral(
                          context,
                          homeCubit,
                          titles[homeCubit.currentIndex],
                          backButton: true,
                          cartView:
                              cartViewsAndElevation[homeCubit.currentIndex],
                          isProfile:
                              !cartViewsAndElevation[homeCubit.currentIndex],
                        ),
                        body: homeCubit.isGetCatsFinish
                            ? PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: pageController,
                                onPageChanged: (value) {
                                  if (value == 4 ) {
                                    if(AppCubit.get(context).profileEditSuccess.result != null ){
                                      if((AppCubit.get(context).profileEditSuccess.result!.emailAddress!.isEmpty ||AppCubit.get(context).profileEditSuccess.result == null ) && token.isNotEmpty){
                                        AppCubit.get(context)
                                            .getProfileDetails(context);
                                      }
                                    }
                                  }
                                  if (value == 1) {
                                    if(MyAuctionsCubit.get(context).isFirstBuild) {
                                      MyAuctionsCubit.get(context).getMyBids(context , isRefresh: true).then((value){
                                      MyAuctionsCubit.get(context).getMyProducts(context, isRefresh: true);
                                    });
                                    }
                                    homeCubit.changeBottomNavBar();
                                  }
                                  if (value == 3) {
                                    if(FavoriteCubit.get(context).isFirstBuild) {
                                      FavoriteCubit.get(context).getFavorite(context , isRefresh: true);
                                    }
                                    homeCubit.changeBottomNavBar();
                                  }
                                  if (value < 5) {
                                    homeCubit.currentIndex = value;
                                    homeCubit.changeBottomNavBar();
                                  }else {
                                    pageController.jumpToPage(0);
                                    homeCubit.currentIndex = 0;
                                    homeCubit.changeBottomNavBar();
                                  }
                                },
                                itemBuilder: (context, index) =>
                                    screens[homeCubit.currentIndex],
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        bottomNavigationBar: BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            onTap: (value) {
                              homeCubit.currentIndex = value;
                              pageController.jumpToPage(value);
                              homeCubit.changeBottomNavBar();
                            },
                            showUnselectedLabels: true,
                            unselectedLabelStyle: AppTextStyles.smallGrey,
                            selectedLabelStyle: AppTextStyles.smallBlue,
                            unselectedItemColor: ColorManger.grey,
                            fixedColor: ColorManger.primaryLight,
                            currentIndex: homeCubit.currentIndex,
                            items: [
                              const BottomNavigationBarItem(
                                  icon: Icon(Icons.home), label: "الرئيسية" ,

                              ),
                              BottomNavigationBarItem(
                                  icon: svgIcon(homeCubit), label: "مزاداتي "),
                              const BottomNavigationBarItem(
                                  icon: Icon(Icons.add_circle),
                                  label: "اضافة منتج "),
                              const BottomNavigationBarItem(
                                  icon: Icon(Icons.favorite),
                                  label: " المفضلة "),
                              const BottomNavigationBarItem(
                                  icon: Icon(Icons.person), label: " حسابى "),
                            ]),
                      ),
                    ),
                  ),
                ),
              )
            : const OfflineScreen();
      },
    );
  }

  String assetName = 'assets/auction.svg';

  Widget svgIcon(HomeCubit homeCubit) => SvgPicture.asset(
        assetName,
        color: homeCubit.currentIndex == 1
            ? ColorManger.primaryLight
            : ColorManger.grey,
      );

  @override
  void dispose() {
    super.dispose();
    subscription!.cancel();
  }
}
