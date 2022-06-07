import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.white,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) => LoginCubit(),
      builder: (context, state) {
        LoginCubit loginCubit = LoginCubit.get(context);
        var resetPasswordController1 = loginCubit.resetPasswordController1;
        var resetPasswordController2 = loginCubit.resetPasswordController2;
        bool isObscureText1 = loginCubit.isObscureText1;
        bool isObscureText2 = loginCubit.isObscureText2;
        var formKey = GlobalKey<FormState>();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const DarkLogo(),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: const [
                          Text("اعادة تعيين كلمة المرور ",
                              style: AppTextStyles.titleBlue),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 25,
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
                          return loginCubit.passwordValidation(value, false);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isObscureText1,
                        controller: resetPasswordController1,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorManger.primaryLight)),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: isObscureText1
                              ? IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword1();
                                  },
                                  icon: const Icon(Icons.visibility_off))
                              : IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword1();
                                  },
                                  icon: const Icon(Icons.visibility)),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text(
                            "تأكيد كلمة المرور",
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
                         if(value != resetPasswordController1.text){
                           return " كلمتي المرور غير متطابقتين " ;
                         }else{
                           return null ;
                         }
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isObscureText2,
                        controller: resetPasswordController2,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorManger.primaryLight)),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: isObscureText2
                              ? IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword2();
                                  },
                                  icon: const Icon(Icons.visibility_off))
                              : IconButton(
                                  onPressed: () {
                                    loginCubit.showPassword2();
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
                          if (formKey.currentState!.validate()) {}
                          //TODO: RESET PASSWORD BUTTON
                        }, "اعادة تعيين  ", true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
