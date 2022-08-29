import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/notification_model.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/toast.dart';
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
  List<NotificationModel> items = [];
  StreamSubscription? subscription;

  Future<List<NotificationModel>> getNotification() async {
    List<NotificationModel> _items = [];
    DioFactory().getData(ApiEndPoint.getNotification, {}).then((value) {
      print(value);
      List itemsResponse = value.data["result"]["items"];
      for (var element in itemsResponse) {
        _items.add(NotificationModel.fromJson(element));
      }
      items = _items;
      return _items;
    }).catchError((err) {
      print("--------------- error ---------------------- ");
      print(err.toString());
      items = _items;
      return _items;
    });
    items = _items;
    return _items;
  }

  @override
  Widget build(BuildContext context){
    if(items.isEmpty){
      getNotification().then((value){
        setState(() {

        });
      });
    }
    return isConnect
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorManger.white,
              appBar: AppBars.appBarGeneral(context, HomeCubit(), "الاشعارات",
                  cartView: false),
              body: items.isEmpty
                  ? const NoNotificationScreen()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            children: List.generate(
                                items.length,
                                (index) => NotificationItemsBuilder(
                                    notificationModel: items[index])),
                          ),
                        ],
                      ),
                    ),
            ),
          )
        : const OfflineScreen();
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
    String convertToAgo(DateTime input) {
      Duration diff = DateTime.now().difference(input);
      if (diff.inDays >= 1 && diff.inDays < 30) {
        return " منذ " + diff.inDays.toString() + " يوم ";
      } else if (diff.inHours >= 1 && diff.inHours < 24) {
        return " منذ " + diff.inHours.toString() + " ساعة ";
      } else if (diff.inMinutes >= 1 && diff.inMinutes < 60) {
        return " منذ " + diff.inMinutes.toString() + " دقيقة ";
      } else if (diff.inSeconds >= 1 && diff.inSeconds < 60) {
        return " منذ " + diff.inSeconds.toString() + " ثانية ";
      } else if (diff.inDays >= 30 && diff.inDays < 365) {
        int d = diff.inDays ~/ 30;
        return " منذ " + d.toString() + " شهر ";
      } else if (diff.inDays > 364) {
        int d = diff.inDays ~/ 365;
        return " منذ " + d.toString() + " سنة ";
      } else {
        return 'الان ';
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: Text(
                        notification.notification?.notificationName ??
                            "غير معنون",
                        style: AppTextStyles.titleBlack,
                        maxLines: 4,
                      ),
                      content: SingleChildScrollView(
                          child: Text(
                        notification.notification?.data?.message?.sourceName
                                .toString() ??
                            ".....",
                        style: AppTextStyles.mediumGrey,
                      )),
                    ),
                  )).then((_) {
                    setState(() {
                      notification.state = 0 ;
                    });
            DioFactory().postData(ApiEndPoint.setNotificationAsRead, {
              "id": notification.id!,
            }).then((value) {
              setState(() {
              });
              print(value.toString());

            }).onError((error, stackTrace)
            {
              print(error);});
          });
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: !(notification.state == 0)
              ? ColorManger.lightGrey
              : ColorManger.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: !(notification.state == 0)
                        ? ColorManger.primary
                        : ColorManger.white,
                    radius: 5,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      notification.notification?.notificationName ??
                          "غير معنون",
                      style: AppTextStyles.mediumBlackBold_14,
                      maxLines: 1,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    convertToAgo(DateTime.parse(
                        notification.notification!.creationTime.toString())),
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
                      child:  Text(
                        notification.notification?.data?.message?.sourceName!.toString() ?? "...." ,
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
