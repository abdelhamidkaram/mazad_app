import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/app_string.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

import '../../app_bloc/app_states.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.white,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => AppCubit(),
      builder: (context, state) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorManger.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
                // statusBarColor:Colors.transparent,
                ),
            elevation: 0.0,
            backgroundColor: ColorManger.white,
            leading: TextButton(
              onPressed: () async {
                await SharedPreferences.getInstance().then((value) {
                  value.setBool(PrefsKey.isNewInstall, false);
                });
              },
              child: Text(
                AppCubit.get(context).onBoardingIndex < 2 ? "تخطي " : " ",
                style: AppTextStyles.smallGrey,
              ),
            ),
          ),
          body: PageView(
            children: onBoardingList,
            scrollDirection: Axis.horizontal,
            reverse: false,
            physics: const NeverScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            controller: AppCubit.get(context).pageController,
            onPageChanged: (onBoardingIndex) {
              setState(() {
                AppCubit.get(context).onBoardingIndex = onBoardingIndex;
              });
            },
          ),
        ),
      ),
    );
  }
}

class Pages extends StatefulWidget {
  final String title;
  final String subTitle;
  final int index;

  const Pages(
      {Key? key,
      required this.title,
      required this.index,
      required this.subTitle})
      : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/on${widget.index}.png"),
            SizedBox(
              height: AppCubit.get(context).onBoardingIndex == 2 ? 25 : 40,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleBlack,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 200,
              child: Text(
                widget.subTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.mediumGrey,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: CircleAvatar(
                            backgroundColor:
                                index == AppCubit.get(context).onBoardingIndex
                                    ? ColorManger.primary
                                    : ColorManger.lightGrey,
                            radius: 6,
                          ),
                        )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AppButtons.appButtonBlue(
              () async {
                int pageIndex = AppCubit.get(context).onBoardingIndex;
                var pageController = AppCubit.get(context).pageController;
                if (pageIndex != 2) {
                  setState(() {
                    AppCubit.get(context).onBoardingIndex++;
                    pageController.animateToPage(pageIndex + 1,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.linearToEaseOut);
                  });
                } else {
                  await SharedPreferences.getInstance().then((value) {
                    value.setBool(PrefsKey.isNewInstall, false);
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                }
              },
              AppCubit.get(context).onBoardingIndex == 2
                  ? "ابدء الآن  "
                  : "التالى ",
              AppCubit.get(context).onBoardingIndex == 2 ? true : false,
            ),
          ]),
    );
  }
}

List<Widget> onBoardingList = <Widget>[
  const Center(
      child: Pages(
    title: AppString.onBoardingTitle1,
    subTitle: AppString.onBoardingSubTitle1,
    index: 1,
  )),
  const Center(
      child: Pages(
    title: AppString.onBoardingTitle2,
    subTitle: AppString.onBoardingSubTitle2,
    index: 2,
  )),
  const Center(
      child: Pages(
    title: AppString.onBoardingTitle3,
    subTitle: AppString.onBoardingSubTitle3,
    index: 3,
  )),
];
