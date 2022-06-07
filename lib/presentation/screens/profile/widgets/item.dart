import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/screens/profile/screens/profile_home.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ProfileListItem extends StatelessWidget {
  final ProfileItemModel profileItemModel;

  const ProfileListItem({Key? key, required this.profileItemModel })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => profileItemModel.nextScreen,),);
        },
        child: SizedBox(
          height: 22,
          width: double.infinity,
          child: Row(
            children: [
              SvgPicture.asset(profileItemModel.svg, color: ColorManger.primary,
                width: 20,
                height: 20,),
              const SizedBox(width: 10,),
              Text(profileItemModel.title, style: AppTextStyles.mediumBlack,),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios, color: ColorManger.grey, size: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

