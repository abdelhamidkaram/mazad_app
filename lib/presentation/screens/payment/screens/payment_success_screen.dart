import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/main_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
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
    Future<bool> _onPop() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "نجح الدفع",
            cartView: false, backButton: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/paymentsuccess.svg"),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  " !نجح الدفع ",
                  style: AppTextStyles.titleSmallBlack,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "سيتم ارسال تفاصيل الدفع عبر البريد الالكتروني ",
                  style: AppTextStyles.smallBlack,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButtons.toastButtonBlue(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                }, "الإنتقال إلى الصفحة الرئيسية ", true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
