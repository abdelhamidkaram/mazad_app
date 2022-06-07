import 'package:flutter/material.dart';
import 'package:soom/style/color_manger.dart';

Widget profileEditImage({required Image image}) {
  return
    Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: ColorManger.lightGrey),
        shape: BoxShape.circle,
        color: ColorManger.lightGrey,
        image: DecorationImage(
            image: image.image,
            fit: BoxFit.cover,
            colorFilter:
            const ColorFilter.mode(ColorManger.white, BlendMode.colorBurn)),
      ),
      child: Container(
        child: const Icon(Icons.camera_alt_outlined , color: ColorManger.white,),
        decoration: const BoxDecoration(
          color: ColorManger.black_40,
          shape: BoxShape.circle,
        ),
      ),
    );
}