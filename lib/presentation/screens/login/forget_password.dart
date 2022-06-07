import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/confirm.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  PhoneNumber number = PhoneNumber(isoCode: 'KW');
  final TextEditingController controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        setState(() {
          if (result != ConnectivityResult.none) {
            setState(() {
              isConnect = true;
            });
          } else {
            setState(() {
              isConnect = false;
            });
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: isConnect ?  Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 50),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    const DarkLogo(),
                    const SizedBox(height: 20,),
                    const Text(
                      "استرجاع كلمة المرور  ",
                      style: AppTextStyles.titleBlue,
                    ),
                    const SizedBox(height: 15,),
                   Row(
                     children:const [
                        Text(
                          "رقم الهاتف ",
                          style: AppTextStyles.mediumGrey,
                        ),

                       Spacer(),
                     ],
                   ),
                    const  SizedBox(height: 10,),
                     InternationalPhoneNumberInput(
                       searchBoxDecoration:const InputDecoration(
                           hintText: "البحث باسم الدولة ..."
                       ),
                       errorMessage: "رقم هاتف غير صالح",
                       inputDecoration: const InputDecoration(
                         focusedErrorBorder:OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Colors.red,
                           ),) ,
                         errorBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                             color: Colors.red,
                           ),),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                             color: ColorManger.primaryLight,
                           ),
                         ),
                         enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.grey)
                         ),
                         prefixIcon: Icon(Icons.phone),
                         border: InputBorder.none,

                       ),
                       hintText: "",

                       onInputChanged: (PhoneNumber number) {
                        LoginCubit.get(context).phone.text = number.toString();
                       },

                       selectorConfig: const SelectorConfig(
                         selectorType: PhoneInputSelectorType.DIALOG,
                       ),
                       ignoreBlank: false,
                       autoValidateMode: AutovalidateMode.disabled,
                       selectorTextStyle: const TextStyle(color: Colors.black),
                       // initialValue: number,
                       textFieldController: controller,
                       formatInput: false,
                       keyboardType: const TextInputType.numberWithOptions(
                           signed: true, decimal: true),


                     )
                    ,
                    const Spacer(),
                    AppButtons.appButtonBlue(() {
                      if(formKey.currentState!.validate()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmScreen(phone: LoginCubit.get(context).phone.text),));
                      }
                    }, " إرسال ", true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ) : const OfflineScreen(),
    );
  }
  @override
  void dispose() {
    super.dispose();
  subscription!.cancel();
  }
}
