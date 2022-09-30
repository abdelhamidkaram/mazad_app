import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/profile/widgets/profile_home_header.dart';
import 'package:soom/style/color_manger.dart';
import '../../../../app_enums.dart';

class ProfileImage extends StatefulWidget {
   final ImgProfile imgProfile ;
  const ProfileImage({Key? key, required this.imgProfile}) : super(key: key);
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 70 ,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image:
            widget.imgProfile.imgProfileType == ImgProfileType.url
            ?  Image.asset(widget.imgProfile.img , width: 70 , height: 70,).image
            :  Image.memory(base64Decode(widget.imgProfile.img) , width: 10,).image
        ),
        border: Border.all(color: ColorManger.lightGrey),
      ),
    );
  }
}
