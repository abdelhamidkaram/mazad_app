import 'package:flutter/material.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AppButtons {
  static Widget appButtonBlue (VoidCallback onPressed , String text , bool fullWidth ){
   return  TextButton(
        onPressed:onPressed ,
        child: Container(
          width:fullWidth ? double.infinity :  120 ,
          height: 50,
          decoration: BoxDecoration(
              color: ColorManger.primary,

            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text(text , style: AppTextStyles.buttonTextStyle,),
              const SizedBox(width: 8,),
              const Icon(Icons.arrow_forward , size: 22,color: ColorManger.white,),
            ],
          ),
        ));
  }
  static Widget toastButtonBlue (VoidCallback onPressed , String text , bool fullWidth , {Widget? icon  }){
   return  TextButton(
        onPressed:onPressed ,
        child: Container(
          width:fullWidth ? double.infinity :  120 ,
          height: 50,
          decoration: BoxDecoration(
              color: ColorManger.primary,
            borderRadius: BorderRadius.circular(10)
          ),
          child:Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? const SizedBox(),
              const SizedBox(width: 10,),
              Text(text , style: AppTextStyles.buttonTextStyle,),
            ],
          )),
        ));
  }

}