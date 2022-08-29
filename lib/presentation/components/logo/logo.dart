import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/style/color_manger.dart';

class DarkLogo extends StatelessWidget {
  const DarkLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/logoo.svg" , width: 300 ,color: ColorManger.primary,);
  }

}
class LightLogo extends StatelessWidget {
  const LightLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/logoo.svg" , width: 300 ,color: ColorManger.white,);
  }
}
