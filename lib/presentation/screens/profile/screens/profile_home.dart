import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/screens/profile/screens/about/about_screen.dart';
import 'package:soom/presentation/screens/profile/screens/notifications/notifications_screen.dart';
import 'package:soom/presentation/screens/profile/screens/q_a/q_a_screen.dart';
import 'package:soom/presentation/screens/profile/screens/support/support_screen.dart';
import 'package:soom/presentation/screens/profile/screens/wallet_screen/wallet_screen.dart';
import 'package:soom/presentation/screens/profile/widgets/item.dart';
import 'package:soom/presentation/screens/profile/widgets/logout_widget.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => AppCubit(),
      builder: (context, state) {
        List<ProfileItemModel> items = [
          ProfileItemModel(
              "المحفظة", "assets/wallet.svg", const WalletScreen()),
          ProfileItemModel("الاشعارات", "assets/notifications.svg",
              const NotificationsScreen()),
          ProfileItemModel(
              "من نحن ", "assets/about.svg", const AboutUsScreen()),
          ProfileItemModel(
              // ignore: prefer_const_constructors
              "الأسئلة الشائعة", "assets/qa.svg",  QAScreen()),
          ProfileItemModel(
              "الدعم الفني", "assets/support.svg", const SupportScreen()),
        ];
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                physics:const BouncingScrollPhysics(),
                children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorManger.white,
                    border: Border.all(
                      color: ColorManger.lightGrey,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: List.generate(
                      items.length,
                          (index) =>
                          ProfileListItem(profileItemModel: items[index]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const LogOutWidget(),
                  const SizedBox(
                    height: 27,
                  ),
                  const Center(child:   Text("تواصل معنا ", style: AppTextStyles.mediumBlackBold,)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: (){
                          //TODO : SOCIAL MEDIA LINK FORM SERVER
                        },
                        child: SvgPicture.asset("assets/snap.svg" , width: 20,height:20,)),
                    const SizedBox(width: 20,),
                    SvgPicture.asset("assets/whatsapp.svg", width: 20,height:20,),
                    const SizedBox(width: 20,),
                    SvgPicture.asset("assets/instagram.svg" , width: 20,height:20,),
                    const SizedBox(width: 20,),
                    SvgPicture.asset("assets/twitter.svg", width: 20,height:20,),
                    const SizedBox(width: 20,),
                    SvgPicture.asset("assets/facebook.svg", width: 20,height:20,),
                  ],
                )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileItemModel {
  final String svg;
  final String title;
  final Widget nextScreen;
  ProfileItemModel(this.title, this.svg, this.nextScreen);
}
