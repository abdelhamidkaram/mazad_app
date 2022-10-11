import 'package:flutter/material.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AppButtons {
  static Widget appButtonBlue (VoidCallback onPressed , String text , bool fullWidth ,{bool isVisitor = false } ){
   return  TextButton(
        onPressed:onPressed ,
        child: Container(
          width:fullWidth ? double.infinity :  120 ,
          height: 50,
          decoration: BoxDecoration(
              color: isVisitor ? ColorManger.primaryLight_10 : ColorManger.primary,

            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text(text , style: AppTextStyles.buttonTextStyle(isVisitor),),
              const SizedBox(width: 8,),
               Icon(Icons.arrow_forward , size: 22,color: isVisitor ? ColorManger.black :  ColorManger.white,),
            ],
          ),
        ));
  }
  static Widget appButtonDisable (VoidCallback onPressed,String text,bool fullWidth){
   return  TextButton(
        onPressed:onPressed,
        child: Container(
          width:fullWidth ? double.infinity :  120 ,
          height: 50,
          decoration: BoxDecoration(
            color: ColorManger.lightGrey ,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text(text , style: AppTextStyles.titleBlack,),
              const SizedBox(width: 8,),
            ],
          ),
        ));
  }
  static Widget toastButtonBlue (VoidCallback onPressed , String text , bool fullWidth , {Widget? icon  }){
   return  TextButton(
        onPressed:onPressed,
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
              Text(text , style: AppTextStyles.buttonTextStyle(false),
              ),
            ],
          )),
        ));
  }
}