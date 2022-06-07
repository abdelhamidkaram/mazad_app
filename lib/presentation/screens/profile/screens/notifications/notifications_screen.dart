import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/presentation/screens/profile/screens/notifications/no_notification.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        setState(() {
          if (result != ConnectivityResult.none) {
            setState(() {
              isConnect = true;
            });
          } else {
            setState(() {
              isConnect = false;
            });
          }
        });
      },
    );
    super.initState();
  }

  bool isConnect = true;

  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    List<NotificationModel> items = [
      NotificationModel(
          "اشعار رقم 1 ",
          "2022-05-06",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          true),
      NotificationModel(
          "اشعار رقم2 ",
          "2020-06-04",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          false),
      NotificationModel(
          "اشعار رقم 3",
          "2022-05-02",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          true),
      NotificationModel(
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          "2022-06-04 01:01:00",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          false),
      NotificationModel(
          "اشعار رقم 5",
          "2022-06-04 01:03:00",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          true),
      NotificationModel(
          "اشعار رقم 6 ",
          "2022-05-20",
          "هذا النص مثال لنص ممكن ان يستبدل في نفس المساحة ولكنه طويل جدا لتجربة النصوص الطويلة والتجاوب ",
          false),
    ];
    return isConnect ?  Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "الاشعارات",
            cartView: false),
        body:

        items.isEmpty? const NoNotificationScreen() :
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Column(
                children:
                  List.generate(items.length, (index) => NotificationItemsBuilder(notificationModel: items[index])),
              ),
            ],
          ),
        ),
      ),
    ) : const  OfflineScreen();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }
}

class NotificationItemsBuilder extends StatefulWidget {
  final NotificationModel notificationModel;

  const NotificationItemsBuilder({Key? key, required this.notificationModel})
      : super(key: key);

  @override
  State<NotificationItemsBuilder> createState() =>
      _NotificationItemsBuilderState();
}

class _NotificationItemsBuilderState extends State<NotificationItemsBuilder> {
  @override
  Widget build(BuildContext context) {
    NotificationModel notification = widget.notificationModel;
    String convertToAgo(DateTime input){
      Duration diff = DateTime.now().difference(input);
      if(diff.inDays >= 1 && diff.inDays < 30 ){
        return " منذ " +  diff.inDays.toString() + " يوم " ;
      } else if(diff.inHours >= 1 && diff.inHours < 24){
        return " منذ " +  diff.inHours.toString() + " ساعة " ;
      } else if(diff.inMinutes >= 1 && diff.inMinutes < 60 ){
        return " منذ " +  diff.inMinutes.toString() + " دقيقة " ;
      } else if (diff.inSeconds >= 1 && diff.inSeconds < 60){
        return " منذ " +  diff.inSeconds.toString() + " ثانية " ;
      } else if(diff.inDays >= 30  && diff.inDays < 365){
        int  d = diff.inDays ~/ 30;
        return " منذ " +  d.toString() + " شهر " ;
      }else if(diff.inDays > 364){
        int d = diff.inDays ~/ 365 ;
        return " منذ " +  d.toString() + " سنة " ;
      }
      else {
        return 'الان ';
      }
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: (){
          showDialog(context: context, builder:(context)=> Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(notification.title , style: AppTextStyles.titleBlack, maxLines: 4,),
               content: SingleChildScrollView(child: Text(notification.description , style: AppTextStyles.mediumGrey,)),
            ),
          )).then((_){
            //TODO: CHANGE NOTIFICATION STATUS Form SERVER
          });
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: !notification.isRead?  ColorManger.lightGrey : ColorManger.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   CircleAvatar(
                    backgroundColor:  !notification.isRead ? ColorManger.primary : ColorManger.white,
                    radius: 5,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: AppTextStyles.mediumBlackBold_14,
                      maxLines: 1,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    convertToAgo(DateTime.parse(notification.date.toString())),
                    style: AppTextStyles.smallBlue,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: const Text(
                        "هذا مثال لنص يمكن ان يستبدل في نفس المساحةهذا مثال لنص يمكن ان يستبدل في نفس المساحةهذا مثال لنص يمكن ان يستبدل في نفس المساحةهذا مثال لنص يمكن ان يستبدل في نفس المساحةهذا مثال لنص يمكن ان يستبدل في نفس المساحة ",
                        style: AppTextStyles.smallBlack,
                        maxLines: 2,
                      )),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationModel {
  final String title;
  final String date;
  final String description;
  final bool isRead;

  NotificationModel(this.title, this.date, this.description, this.isRead);
}
