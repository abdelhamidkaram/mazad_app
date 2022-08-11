import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soom/constants/app_string.dart';
import 'package:soom/style/color_manger.dart';

class AppTextStyles {
  // ---- small  ---------//
  static const TextStyle smallGrey = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.grey,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallGrey_12 = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.grey,
    fontSize: 11,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallGreyBold_12 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.grey,
    fontSize: 11,
  );
  static const TextStyle smallGreyBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.grey,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallBlue = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle smallBlue_12 = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 12,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallBlack = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallBlueBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.primaryLight,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallWhite = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.white,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle smallGreen = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  // ---- medium ---------//
  static const TextStyle mediumGrey = TextStyle(
      fontFamily: AppString.fontName,
      color: ColorManger.grey,
      fontSize: 18,
      height: 1.5);
  static const TextStyle mediumWhite = TextStyle(
      fontFamily: AppString.fontName,
      color: ColorManger.white,
      fontSize: 18,
      height: 1.5);
  static const TextStyle mediumBlue = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle mediumBlack = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle mediumBlackBold_14 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle mediumBlackBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle mediumBlackBold_17 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle mediumGreen = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  //--------- Buttons ---------//
  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.white,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );

  //--------- title ------------ //
  static const TextStyle titleBlack = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleBlue = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleGrey = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.grey,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleWhite = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.white,
    fontSize: 24,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleRed = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.red,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleGreen = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleGreen_30 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 30,
    overflow: TextOverflow.ellipsis,
  );

  //small title
  static const TextStyle titleSmallBlue = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleSmallBlue_18 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.primary,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleSmallBlack = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 20,
    overflow: TextOverflow.ellipsis,
  );

  //product box
  static const TextStyle titleProductBlue = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.productTitle,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleSmallGreen = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titlePriceBlack = TextStyle(
    fontFamily: AppString.fontName,
    color: ColorManger.black,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle currencyRed = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.red,
    fontSize: 12,
    textBaseline: TextBaseline.alphabetic,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle currencyGreen = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.green,
    fontSize: 12,
    textBaseline: TextBaseline.alphabetic,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle titleBlue_24 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontName,
    color: ColorManger.productTitle,
    fontSize: 24,
    overflow: TextOverflow.ellipsis,
  );
}
