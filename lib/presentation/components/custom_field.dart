import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';

import '../../style/color_manger.dart';

class CustomFields {


  static Widget confirmField (context ,int focus , TextEditingController confirmController  ){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 50,
        child: TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          autofocus: focus == LoginCubit.get(context).focus,
          controller:
          confirmController,
          enabled: confirmController
              .text
              .isNotEmpty
              ? false
              : true,
          onChanged: (value) {
            if (value.length == 1) {
              LoginCubit.get(context).nextConformField(
                  value,
                  focus,
                  confirmController , context );


            }
          },
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)) ,
              borderSide: BorderSide(color: ColorManger.primary),
            ),
            border: OutlineInputBorder(

              borderRadius: BorderRadius.all(Radius.circular(13),
              ),
              borderSide: BorderSide(color: ColorManger.lightGrey),
            ),

          ),
        ),
      ),
    );
  }



}