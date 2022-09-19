import 'package:flutter/material.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../main.dart';
import '../../../../app_bloc/app_cubit.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    String aboutUs = AppCubit.get(context).aboutUs ;
    if(AppCubit.get(context).aboutUs.isEmpty && AppCubit.get(context).allConfigurations.isNotEmpty){
      AppCubit.get(context).allConfigurations.forEach((element) {
        if(element.systemConfigration!.keyName == "aboutUs"){
          aboutUs = element.systemConfigration!.slideDescription.toString() ;
          AppCubit.get(context).aboutUs = element.systemConfigration!.slideDescription.toString() ;
          setState(() {

          });
        }
      });
    }
    if(aboutUs.isEmpty) {
       DioFactory(token).getData("api/services/app/SystemConfigrations/GetAll?KEYNameFilter=aboutUs", {}).then((value){
        aboutUs = value.data["result"]["items"][0]["systemConfigration"]["slideDescription"];
        AppCubit.get(context).aboutUs = value.data["result"]["items"][0]["systemConfigration"]["slideDescription"];
        setState(() {

        });
      });
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar:  AppBars.appBarGeneral(context,HomeCubit(), "من نحن " , cartView: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24.0),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text("من نحن " , style: AppTextStyles.titleBlue,  ) ,
                    Spacer()
                  ]
                ),
                 const SizedBox(height: 24,),
                 Text( aboutUs , style: AppTextStyles.smallGrey,
                maxLines: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
