import 'package:flutter/material.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AppThemeStyles{


  //------------  tab bar theme
  static TabBarTheme tabBarTheme = const TabBarTheme(
  unselectedLabelColor: ColorManger.black,
  unselectedLabelStyle: AppTextStyles.mediumGrey,
  labelStyle: AppTextStyles.titleSmallBlue,
  labelColor: ColorManger.primary,
  indicator: BoxDecoration(
  border: Border(bottom: BorderSide(color: ColorManger.primary , width: 2))
  )
  );







}