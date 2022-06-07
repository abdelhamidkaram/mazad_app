import 'package:flutter/material.dart';

class DarkLogo extends StatelessWidget {
  const DarkLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logodark.png",
      width: 300,
    );
  }
}
class LightLogo extends StatelessWidget {
  const LightLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logo.png",
      width: 300,
    );
  }
}
