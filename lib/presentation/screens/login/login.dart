import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/presentation/screens/login/forget_password.dart';
import 'package:soom/presentation/screens/login/register.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/repository/request_models.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import '../main_view/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorManger.white,
      statusBarBrightness: Brightness.light,
    ));
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
    return WillPopScope(
      onWillPop: () => Future(
        () {
          SystemNavigator.pop();
          return Future.value(true);
        },
      ),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) => [LoginCubit(), AppCubit()],
        builder: (context, state) {
          LoginCubit loginCubit = LoginCubit.get(context);
          var emailController = loginCubit.emailController;
          var passwordController = loginCubit.passwordController;
          bool isRemember = loginCubit.isRemember;
          bool isObscureText = loginCubit.isObscureText;
          var formKey = GlobalKey<FormState>();
          return isConnect
              ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const DarkLogo(),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: const [
                                    Text("تسجيل الدخول ",
                                        style: AppTextStyles.titleBlue),
                                    Spacer()
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      "بريدك الالكتروني ",
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
                                    return loginCubit.passwordValidation(
                                        value, true);
                                  },
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isObscureText,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorManger.primaryLight)),
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: isObscureText
                                        ? IconButton(
                                            onPressed: () {
                                              loginCubit.showPassword();
                                            },
                                            icon: const Icon(
                                                Icons.visibility_off))
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
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            loginCubit.changeIconRemember();
                                          },
                                          icon: isRemember
                                              ? const Icon(
                                                  Icons.check_box_outline_blank)
                                              : const Icon(
                                                  Icons.check_box,
                                                  color: ColorManger.primary,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "تذكرني ",
                                          style: AppTextStyles.smallGrey,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgetPassword(),
                                            ));
                                      },
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgetPassword(),
                                              ));
                                        },
                                        child: const Text(
                                          "نسيت كلمة المرور ؟ ",
                                          style: AppTextStyles.smallBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: BlocConsumer<HomeCubit, HomeStates>(
                                    listener: (context, state) => HomeCubit(),
                                    builder: (context, state) {
                                      return AppButtons.appButtonBlue(() {
                                        if (formKey.currentState!.validate()) {
                                          AppToasts.toastLoading(context);
                                          LoginRequest loginRequest =
                                              LoginRequest(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                          LoginCubit.get(context)
                                              .loginUser(loginRequest, context)
                                              .then((value) => null);
                                        }
                                      }, "تسجيل الدخول ", true);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "ليس لديك حساب ؟ ",
                                      style: AppTextStyles.mediumGrey,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        emailController.text = "";
                                        passwordController.text = "";
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterScreen(),
                                            ));
                                      },
                                      child: const Text(
                                        "انشاء حساب ",
                                        style: AppTextStyles.mediumBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                AppButtons.appButtonBlue(
                                    () {
                                      HomeCubit.get(context).currentIndex = 0 ;

                                      Navigator.pushReplacement(
                                          context,MaterialPageRoute(
                                        builder: (context) => const MainScreen(),),
                                      );
                                    }, "الدخول كزائر", true,
                                    isVisitor: true),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const OfflineScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription!.cancel();
  }
}

Future getHomeData(context) async {
  await AppCubit.get(context).getProfileDetails(context).then((value) async {
   await MyAuctionsCubit.get(context).getMyBids(context).then((value)async{
     await HomeCubit.get(context).getCategories(context).then((value) async {
       await HomeCubit.get(context).getProducts(context,  false).then((value) async {
         await HomeCubit.get(context).getCategoryBlocks(false).then((value) async {
           AppCubit.get(context).getSystemConf(context);
         });
       });
     });
   });
  }).catchError((err) {
    if (kDebugMode) {
      AppToasts.toastError("error when : get home data method ", context);
      print(err.toString());
    }
  });
}
