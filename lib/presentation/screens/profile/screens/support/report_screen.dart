import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/profile/screens/support/old_reports.dart';
import 'package:soom/style/color_manger.dart';

import '../../../../../data/cache/prefs.dart';
import '../../../../../main.dart';
import '../../../../../style/text_style.dart';

class ReportScreen extends StatefulWidget {
  final ReportModel reportModel ;
  const ReportScreen({Key? key, required this.reportModel}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int count = -1 ;
  String msg = "";
  @override
  void initState() {
    super.initState();
    String newToken = token;
    DioFactory(newToken).getData(ApiEndPoint.getCommentForSupportCase, {
      "SupportCaseTitleFilter" : widget.reportModel.title,
    }).then((value){
       setState(() {
         if(value.data["result"]["totalCount"] == 0 ){
           count = -2 ;
           msg = "لايوجد رد حتي الان .. عادة ما يتم الرد علي البلاغات في غضون اسبوع عمل ";
         }else{
           count = 0 ;
           msg = value.data["result"]["items"][0]["supoortCaseComments"]["body"];
         }

       });
    }).catchError((err){
      print(err.toString());
      setState(() {
        count = -3 ;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
   Widget  _replay(){
      switch(count){
        case -1 :
          return const CircularProgressIndicator();
        case -3 :
          return const Text("حدث خطأ في جلب الرد حاول لاحقا " ,
            style: AppTextStyles.mediumBlack, textDirection: TextDirection.rtl , maxLines: 50,);
        case 0 :
          return  Text(msg  , style: AppTextStyles.mediumBlack,
            textDirection: TextDirection.rtl , maxLines: 50,);
          case -2 :
          return  Text(msg  , style: AppTextStyles.mediumBlack,
            textDirection: TextDirection.rtl , maxLines: 50,);
      }
      return const Text("لا يوجد رد حتي الان .. عادة ما يتم الرد خلال اسبوع عمل  " ,
        style: AppTextStyles.smallGrey, textDirection: TextDirection.rtl ,
        maxLines: 50,);
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.appBarGeneral(context, HomeCubit(), widget.reportModel.title.length > 10 ? widget.reportModel.title.substring(0,10) :  widget.reportModel.title  , cartView: false),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const  Text("المشكلة  " , style: AppTextStyles.titleBlue,) ,
                 const SizedBox(height: 20,),
                  Text(widget.reportModel.body , style: AppTextStyles.mediumBlack, maxLines: 50,),
                  const SizedBox(height: 20,),
                  const   Text("الرد  " , style: AppTextStyles.titleBlue) ,
                  const SizedBox(height: 20,),
                  _replay(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
