import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/presentation/screens/profile/screens/support/new_report_tab.dart';
import 'package:soom/presentation/screens/profile/screens/support/old_reports.dart';
import 'package:soom/style/color_manger.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
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
    return isConnect ?  Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(length: 2, child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.supportAppBar(),
        body: const TabBarView(children:  [
          NewReport(),
          OldReports(),
        ]),
      )),
    ) : const OfflineScreen();
  }
  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
