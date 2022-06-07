import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/custom_field.dart';
import 'package:soom/presentation/components/logo/logo.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/bloc/states.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ConfirmScreen extends StatefulWidget {
  final String phone;

  const ConfirmScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  var formCodeKey = GlobalKey<FormState>();

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
    return BlocConsumer<LoginCubit, LoginStates>(
      builder: (context, state) {
        var loginCubit = LoginCubit.get(context);
        bool _finsh = loginCubit.finsh;
        var confirmController1 = loginCubit.confirmController1;
        var confirmController2 = loginCubit.confirmController2;
        var confirmController3 = loginCubit.confirmController3;
        var confirmController4 = loginCubit.confirmController4;
        var endTime = DateTime.now().add(const Duration(seconds: 30));

        return isConnect?  Scaffold(
          backgroundColor: ColorManger.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const DarkLogo(),
                    Column(
                      children: [
                        const Text(
                          "الرمز السري",
                          style: AppTextStyles.titleBlue,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "قم يادخال الرمز الذي وصل لجوالك ",
                          style: AppTextStyles.mediumGrey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Form(
                            key: formCodeKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomFields.confirmField(
                                    context, 1, confirmController1),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomFields.confirmField(
                                    context, 2, confirmController2),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomFields.confirmField(
                                    context, 3, confirmController3),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomFields.confirmField(
                                    context, 4, confirmController4),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "تنتهي صلاحية الرمز خلال : ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TimerCountdown(
                                  enableDescriptions: false,
                                  secondsDescription: "ثانية",
                                  timeTextStyle: AppTextStyles.mediumBlue,
                                  format: CountDownTimerFormat.secondsOnly,
                                  endTime: endTime,
                                  onEnd: () {
                                    setState(() {
                                      LoginCubit.get(context).finsh = true;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Center(
                                  child: Text(
                                _finsh ? "انتهت الصلاحية" : "ثواني ",
                                style: AppTextStyles.mediumGrey,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "لم تتلقي رمزا ؟ ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      //TODO : RE SEND CODE
                                      endTime = DateTime.now()
                                          .add(const Duration(seconds: 30));
                                    });
                                  },
                                  child: const Text(
                                    "اعادة ارسال الرمز ؟ ",
                                    style: AppTextStyles.mediumBlue,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: AppButtons.appButtonBlue(() {
                        loginCubit.checkConfirmCode(context);
                      }, " إرسال ", true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) : const OfflineScreen();
      },
      listener: (context, state) => LoginCubit(),
    );
  }
  @override
  void dispose() {
        super.dispose();
  subscription!.cancel();
  }
}
