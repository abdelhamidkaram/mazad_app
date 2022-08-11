import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_auctions_tab.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_bid_tab.dart';
import 'package:soom/style/color_manger.dart';

class MyAuctions extends StatefulWidget {
  const MyAuctions({Key? key}) : super(key: key);

  @override
  State<MyAuctions> createState() => _MyAuctionsState();
}

class _MyAuctionsState extends State<MyAuctions> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAuctionsCubit(),
      child: BlocConsumer<MyAuctionsCubit, MyAuctionsStates>(
          listener: (context, state) => MyAuctionsCubit(),
          builder: (context, state) {
             List<ProductForViewModel> myBids = [
            //   ProductModel(false , "assets/pro2.png","view", "منزل متكامل مع حديقة ", "123456875", "900565", "2022-05-29", "3000", "8500", "120", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(false , "assets/pro1.png","view", "جهاز لاب توب ابل ", "123456875", "500000", "2022-05-25", "500000", "100200", "74", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(false , "assets/pro2.png","view", "عقار يطل علي البحر ", "123456875", "9565", "2022-05-24", "800", "1500", "37", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(true , "assets/pro2.png","view", "سيارة هونداي ", "123456875", "9565", "2022-06-13", "900", "3900", "95", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(false , "assets/pro1.png","view", "ساعة روليكس  ", "123456875", "9565", "2022-05-22", "9845", "63215", "85", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(true , "assets/pro2.png","view", "مجوهرات أثرية ", "123456875", "9565", "2022-05-21", "232", "520", "23", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
            //   ProductModel(true , "assets/pro1.png","view", "عنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويل ","123456875", "9565", "2022-05-22", "800", "1500", "20", "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
             ];
            List<ProductForViewModel> myAuctions = [
              ProductForViewModel(
                false,
                "200",
                ProductModel(
                    product: Product(
                        status: 0,
                        targetPrice: 300,
                        minPrice: 200,
                        name: "تجربة ",
                        endDate: "2022-05-29",
                        categoryId: 1,
                        descrption:
                        "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما.",
                        id: 100,
                      intitalPrice: 1000


                    ),
                categoryName: "test1"
                ),
                "1000",
                "12",
              ),
            ];
            return  DefaultTabController(length: 2, child: Scaffold(
              backgroundColor: ColorManger.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  decoration:const BoxDecoration(
                    border:  Border(bottom: BorderSide(color: ColorManger.lightGrey)),
                  ),
                  child: const TabBar(tabs: [
                    Tab(child: Text("مزادات زايدت عليها "),),
                    Tab(child: Text("مزادات أضفتها "),),
                  ]),
                ) ,
              ),
              body:  TabBarView(children: [
                myBids.isNotEmpty ? MyBids(myBids: myBids, ) : 
                Center(child: SvgPicture.asset("assets/nobids.svg"),)
                ,
               myAuctions.isNotEmpty ? MyAuctionsTab(myAuctions: myAuctions) :
               Center(child: SvgPicture.asset("assets/nobids.svg"),)
                ,
              ]),
            ));
          }),
    );
  }

}
