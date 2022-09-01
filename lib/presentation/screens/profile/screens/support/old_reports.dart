import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/profile/screens/support/report_screen.dart';
import 'package:soom/style/text_style.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../components/toast.dart';
import '../q_a/q_a_screen.dart';

class OldReports extends StatefulWidget {
  const OldReports({Key? key}) : super(key: key);

  @override
  State<OldReports> createState() => _OldReportsState();
}


class _OldReportsState extends State<OldReports> {
  List<ReportModel> itemData =[];
  int cont = -1 ;
@override
  void initState() {
    super.initState();
    if(itemData.isEmpty ) {
      DioFactory().getData(ApiEndPoint.getAllSupportCass, {}).then((value) {
        List itemResponse = value.data["result"]["items"];

        for (var element in itemResponse) {
          itemData.add(
              ReportModel(element["supportCase"]["title"],
                  DateTime.now().toString() , element["supportCase"]["body"],
                  "لم يتم الرد بعد ",
                  element["userName"],
              )
          );
        }
        setState(() {
          itemData = itemData.reversed.toList();
         cont = value.data["result"]["totalCount"] ;
        });

      }).catchError((err) {
        setState(() {
          cont = -3 ;
        });
        AppToasts.toastError("$err", context);
        if (kDebugMode) {
          print(err.toString());
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24),
      child: (cont != -1 && cont != -3 && cont != 0)
          ?
      ListView.separated(
        itemCount: itemData.length  ,
        itemBuilder:(context, index) => GestureDetector(
          onTap: ()async {
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportScreen(reportModel: itemData[index]),));
          },
          child: Column(
            children: [
              Row(
                children:  [
                  Expanded(child: Text(
                    itemData[index].title ,
                    style: AppTextStyles.mediumBlackBold, maxLines: 1,)),
                 const Text("2022-10-05" , style: AppTextStyles.smallBlue,),
                ],
              ),
              const SizedBox(height: 16,),
              Text(
                itemData[index].body,
              maxLines: 2,
                style:  AppTextStyles.smallGrey,
              ),

            ],
          ),
        ),
        separatorBuilder: (context , index)=> const Divider(),
      )
          :
      (cont == -1)
         ?
     const Center(child: CircularProgressIndicator(),)
         :
         cont == -3 ? const Center(child: Text("حدث خطأ اثناء جلب البلاغات "))
             :
         const Center(child: Text("لايوجد بلاغات من قبلكم حتي الان  "))
      ,

    );
  }
}

class ReportModel {
  String title ;
  String body ;
  String date ;
  String reply ;
  String userName ;

  ReportModel(this.title , this.date , this.body , this.reply , this.userName);
}