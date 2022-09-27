import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/repository/request_models.dart';

import '../../../style/text_style.dart';
import '../../components/buttons/buttons.dart';

class PrivacyScreen extends StatefulWidget {
  final RegisterRequest registerRequest;
  const PrivacyScreen({Key? key, required this.registerRequest}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
   String  text = LoginCubit.get(context).privacyPolicy;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: ()async{
          showDialog(context: context, builder:(context)=>AlertDialog(
            content: const Text("يجب الموافقة علي الشروط والاحكام حتي تكتمل عملية التسجيل .."),
            actions: [
              TextButton(onPressed: ()async{
                return await  Future.value(true);
              }, child: const Text("عودة")),
              TextButton(onPressed: ()async{
                await LoginCubit.get(context).register(widget.registerRequest, context);
                return await  Future.value(false);
              },
                child: const Text("الموافقة والاستمرار"),
              ),
            ],
          ));
          return await  Future.value(false);
        },
        child: Scaffold(
          body: Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("الشروط والأحكام" , style: AppTextStyles.titleBlue,),
                    SizedBox(
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            Text(text),
                          ],
                        )),
                    Center(
                      child: AppButtons.appButtonBlue(() async {
                        await LoginCubit.get(context).register(widget.registerRequest, context);
                      }, "الموافقة والاستمرار", true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
