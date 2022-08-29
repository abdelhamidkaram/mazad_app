import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/repository/request_models.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.white,
      statusBarBrightness: Brightness.light,
    ));
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        if(result != ConnectivityResult.none){
          setState(() {
            isConnect = true;
          });
        }else {
          setState(() {
            isConnect = false;
          });
        }
      });
    } , );
    super.initState();
  }
  bool isConnect = true ;
  StreamSubscription ?  subscription ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) => LoginCubit(),
      builder: (context, state) {
        LoginCubit loginCubit = LoginCubit.get(context);
        var emailController = loginCubit.emailController;
        var passwordController = loginCubit.passwordController;
        var phoneController = loginCubit.phone;
        bool isObscureText = loginCubit.isObscureText;
        var formKey = GlobalKey<FormState>();
        final TextEditingController controller = TextEditingController();
        PhoneNumber number = PhoneNumber(isoCode: 'KW');
        return isConnect ? Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const DarkLogo(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text("تسجيل حساب جديد ", style: AppTextStyles.titleBlue),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Text(
                            "بريدك الالكتروني ",
                            style: AppTextStyles.mediumGrey,
                          ),
                          Spacer() ,
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          return loginCubit.emailValidation(value);
                        },
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManger.primaryLight)),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text(
                            "رقم الهاتف ",
                            style: AppTextStyles.mediumGrey,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: InternationalPhoneNumberInput(
                          inputBorder:const OutlineInputBorder(),
                          searchBoxDecoration:const InputDecoration(
                            hintText: "البحث باسم الدولة ..."
                          ),
                          errorMessage: "رقم هاتف غير صالح",
                          hintText: "" ,
                          onInputChanged: (PhoneNumber number) {
                           loginCubit.phone.text = number.toString();
                          },
                          selectorConfig: const  SelectorConfig(
                            leadingPadding: 10,
                            trailingSpace: true,
                            setSelectorButtonAsPrefixIcon: true,
                            selectorType: PhoneInputSelectorType.DIALOG,
                          ),
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: controller,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true ,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "كلمة المرور",
                            style: AppTextStyles.mediumGrey,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          return loginCubit.passwordValidation(value , false);
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: isObscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorManger.primaryLight)),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: isObscureText
                              ? IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword();
                                  },
                                  icon: const Icon(Icons.visibility_off))
                              : IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword();
                                  },
                                  icon: const Icon(Icons.visibility)),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppButtons.appButtonBlue(() {
                          RegisterRequest registerRequest = RegisterRequest(
                            email: emailController.text,
                            password: passwordController.text,
                            name: emailController.text ,
                            phone: phoneController.text,
                            surName: emailController.text,
                            userName: emailController.text,
                          );
                          if (formKey.currentState!.validate()) {
                            loginCubit.register(registerRequest, context);
                          }
                        }, "إنشاء حساب", true),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            " لديك حساب ؟ ",
                            style: AppTextStyles.mediumGrey,
                          ),
                          TextButton(
                              onPressed: () {
                                emailController.text = "" ;
                                passwordController.text = "" ;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen(),
                                    ));
                              },
                              child: const Text(
                                "تسجيل الدخول ",
                                style: AppTextStyles.mediumBlue,
                              )),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ) : const OfflineScreen();
      },
    );

  }
  @override
  void dispose() {
    super.dispose();
    subscription!.cancel();
  }
}
