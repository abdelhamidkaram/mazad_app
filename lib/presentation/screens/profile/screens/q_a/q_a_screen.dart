import 'package:flutter/material.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class QAScreen extends StatefulWidget {
   const QAScreen({Key? key}) : super(key: key);
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<ItemModel> itemData = <ItemModel>[];
@override
  void initState() {
    super.initState();
    if(itemData.isEmpty) {
      DioFactory().getData(ApiEndPoint.getFQA, {}).then((value) {
        List itemResponse = value.data["result"]["items"];
        int count = 0;
        for (var element in itemResponse) {
          itemData.add(ItemModel(headerItem: element["faq"]["qustion"],
              discription: element["faq"]["answer"],
              expanded: count == 0));
          ++count;
        }
setState(() {
itemData = itemData.reversed.toList();
});
      }).catchError((err) {
        print(err.toString());
      });
    }
  }
@override
Widget build(BuildContext context) {




  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: ColorManger.white,
      appBar: AppBars.appBarGeneral(context, HomeCubit(), "الأسئلة الشائعة" , cartView: false),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: itemData.isNotEmpty ?  ListView.builder(
            itemCount: itemData.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionPanelList(
                animationDuration: const Duration(milliseconds: 1000),
                dividerColor: Colors.red,
                elevation: 1,
                children: [
                  ExpansionPanel(
                    body: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            itemData[index].discription,
                            style: AppTextStyles.smallGrey,
                            maxLines: 30,
                          ),
                        ],
                      ),
                    ),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding:const  EdgeInsets.all(10),
                        child: Text(
                          itemData[index].headerItem,
                          style: AppTextStyles.mediumBlackBold_17,
                        ),
                      );
                    },
                    isExpanded: itemData[index].expanded,
                  )
                ],
                expansionCallback: (int item, bool status) {
                     setState(() {
                       itemData[index].expanded = !itemData[index].expanded;
                     });
                },
              );
            },
          )
          :
          const Center(child: CircularProgressIndicator(),),
        ),
      ),
    ),
  );
}
}

class ItemModel {
  bool expanded;
  String headerItem;
  String discription;

  ItemModel(
      {required this.headerItem,
      required this.discription,
      required this.expanded});
}
