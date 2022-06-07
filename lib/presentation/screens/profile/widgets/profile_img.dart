import 'package:flutter/material.dart';
import 'package:soom/style/color_manger.dart';

class ProfileImage extends StatefulWidget {
  final imageUrl;
  const ProfileImage({Key? key, required this.imageUrl}) : super(key: key);

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
        image: DecorationImage(image: Image.network(widget.imageUrl , width: 70 , height: 70,).image),
        border: Border.all(color: ColorManger.lightGrey),
      ),
    )
    ;
  }
}
