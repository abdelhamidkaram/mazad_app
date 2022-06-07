import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoNotificationScreen extends StatelessWidget {
  const NoNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(
      child: SvgPicture.asset("assets/nonotification.svg"),
    ));
  }
}
