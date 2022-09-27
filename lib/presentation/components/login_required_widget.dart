import 'package:flutter/material.dart';
import '../../style/color_manger.dart';
import '../../style/text_style.dart';
import '../screens/login/login.dart';
import 'buttons/buttons.dart';

class LoginRequiredWidget extends StatelessWidget {
  final String message ;
  const LoginRequiredWidget({
    Key? key, required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline , color: ColorManger.grey, size: 70,),
          const SizedBox(height: 20,),
           Text(message , style: AppTextStyles.mediumBlack,),
          const SizedBox(height: 20,),
          AppButtons.appButtonBlue(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          }, "تسجيل الدخول", true)
        ],
      ),
    ),);
  }
}
