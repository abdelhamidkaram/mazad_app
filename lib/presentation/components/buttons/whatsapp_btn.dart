import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main.dart';
import '../../../style/color_manger.dart';
import '../../../style/text_style.dart';
import '../../app_bloc/app_cubit.dart';

class WhatsappButton extends StatefulWidget {
  final bool ? isFullWidth ;
  const WhatsappButton({
    Key? key,
 this.isFullWidth
  }) : super(key: key);

  @override
  State<WhatsappButton> createState() => _WhatsappButtonState();
}

class _WhatsappButtonState extends State<WhatsappButton> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        String phone = AppCubit.get(context).phone ;
        if(AppCubit.get(context).phone.isEmpty && AppCubit.get(context).allConfigurations.isNotEmpty){
          AppCubit.get(context).allConfigurations.forEach((element) {
            if(element.systemConfigration!.keyName == "phone"){
              phone = element.systemConfigration!.slideDescription.toString() ;
              AppCubit.get(context).phone = element.systemConfigration!.slideDescription.toString() ;
              setState(() {

              });
            }
          });
        }
        if(phone.isEmpty){
          await DioFactory(token).getData("api/services/app/SystemConfigrations/GetAll?KEYNameFilter=phone", {}).then((value){
            phone = value.data["result"]["items"][0]["systemConfigration"]["slideDescription"];
            AppCubit.get(context).phone = value.data["result"]["items"][0]["systemConfigration"]["slideDescription"];
            setState(() {

            });
          });
        }
        //https://wa.me/phoneNumber
        Uri  _url  = Uri.parse("https://wa.me/$phone");
        if (!await launchUrl(
            _url,
            mode: LaunchMode.externalApplication

        )) {
          throw 'Could not launch $_url';
        }
      },
      child: Container(
        width:(widget.isFullWidth != null && widget.isFullWidth ==true ) ? double.infinity : null ,
        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorManger.green)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/whatsapp.svg", width: 30,height:30,),
              const SizedBox(width: 10,),
              const Text("تواصل معنا عبر واتساب ", style: AppTextStyles.mediumBlackBold,),
            ],
          ),
        ),
      ),
    );
  }
}