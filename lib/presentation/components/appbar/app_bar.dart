import 'package:flutter/material.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/screens/main_view/cart/cart_screen.dart';
import 'package:soom/presentation/screens/profile/widgets/profile_home_header.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import '../../screens/main_view/bloc/home_cubit.dart';

class AppBars {
  static AppBar appBarGeneral(context , HomeCubit homeCubit , String title , {bool cartView = true ,bool backButton = false , bool isProfile = false , }) {
    return  AppBar(
      automaticallyImplyLeading: backButton,
      leadingWidth: 100,
      leading: !backButton ? GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
            FocusScope.of(context).unfocus();
          },
      child:const Icon(Icons.arrow_back)) : const SizedBox(),
      iconTheme:const IconThemeData(color: ColorManger.black),
      backgroundColor: ColorManger.white,
      title:  Text(title),
      titleTextStyle: AppTextStyles.titleBlack,
      centerTitle: true,
      elevation:  0.9  ,
      //TODO: ADD CART VIWE

      // actions: [
      //    cartView ? Padding(
      //     padding: const EdgeInsets.only(bottom: 4, left: 4, top: 1),
      //     child: Stack(alignment: const Alignment((0.8), (5.0)), children: [
      //       IconButton(
      //           onPressed: () {
      //             Navigator.push(context, MaterialPageRoute(builder: (context)=> const  CartScreen()));
      //           },
      //           icon: const Icon(
      //             Icons.shopping_cart_outlined,
      //             size: 25,
      //             color: ColorManger.black,
      //           )),
      //       Center(
      //         child: Container(
      //           padding: const EdgeInsets.all(2),
      //           width: 15,
      //           height: 15,
      //           decoration:const  BoxDecoration(
      //             color: ColorManger.red,
      //             shape: BoxShape.circle,
      //
      //           ),
      //           child: Center(
      //             child: Text(
      //               homeCubit.cardNumber.toString(),
      //               style: AppTextStyles.smallWhite,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ]),
      //   ) :const SizedBox(),
      // ],
      bottom: isProfile ?  PreferredSize(
        child: Padding(
          padding:  const EdgeInsets.only(left: 16.0 , right: 16.0 , bottom: 5.0 , top: 0),
          child: ProfileHomeHeader(profile: AppCubit.get(context).profileEditSuccess),),
        preferredSize:const Size.fromHeight(120),
      ): null ,
    );
  }
static AppBar supportAppBar(){
    return AppBar(
      iconTheme: const IconThemeData(
          color: ColorManger.black
      ),
      centerTitle: true,
      backgroundColor: ColorManger.white,
      elevation: 0.0,
      title:const  Text("الدعم الفني ", style: AppTextStyles.titleBlack,),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration:const BoxDecoration(
            border:  Border(bottom: BorderSide(color: ColorManger.lightGrey)),
          ),
          child: const TabBar(tabs: [
            Tab(child: Text("بلاغ جديد"),),
            Tab(child: Text("متابعة البلاغات"),),
          ]),
        ) ,
      ),
    );
}


}


