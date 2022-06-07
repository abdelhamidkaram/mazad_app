import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return BlocConsumer<LoginCubit , LoginStates>(
      listener: (context, state) => LoginCubit(),
      builder: (context , state){
        return InkWell(
          onTap: (){
            //login cubit logout
            LoginCubit.get(context).logOut(context);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: ColorManger.white,
              border: Border.all(
                color: ColorManger.lightGrey,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  SvgPicture.asset("assets/logout.svg" , width: 30 , height:  30 ,),
                  const SizedBox(width: 10,),
                  const Text("تسجيل الخروج ", style: AppTextStyles.mediumBlack,),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
