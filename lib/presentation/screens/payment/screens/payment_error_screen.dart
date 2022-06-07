import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/cart/cart_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class PaymentErrorScreen extends StatefulWidget {
  const PaymentErrorScreen({Key? key}) : super(key: key);

  @override
  State<PaymentErrorScreen> createState() => _PaymentErrorScreenState();
}

class _PaymentErrorScreenState extends State<PaymentErrorScreen> {
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
          context, MaterialPageRoute(builder: (context) => const CartScreen()));
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "فشل الدفع",
            cartView: false, backButton: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/paymenterror.svg"),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  " !فشل الدفع ",
                  style: AppTextStyles.titleSmallBlack,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "يرجى التحقق من طريقة الدفع التي تحاول الدفع بها ",
                  style: AppTextStyles.smallBlack,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppButtons.toastButtonBlue(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                }, "العودة الي صفحة الدفع ", true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
