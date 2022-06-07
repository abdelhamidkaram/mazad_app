import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoFavoriteScreen extends StatelessWidget {
  const NoFavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset("assets/nofavorite.svg"),
    );
  }
}
