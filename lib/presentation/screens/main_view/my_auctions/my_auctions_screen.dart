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
    return BlocConsumer<MyAuctionsCubit, MyAuctionsStates>(
        listener: (context, state) => MyAuctionsCubit(),
        builder: (context, state) {
          var cubit = MyAuctionsCubit.get(context);
          List<ProductForViewModel> myBids  = cubit.myBidsForView;
          cubit.getMyBidForView(context).then((value){
            myBids = value ;
          });
          return  DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: ColorManger.white,
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: ColorManger.lightGrey)),
                        ),
                        child: const TabBar(tabs: [
                          Tab(
                            child: Text("مزادات زايدت عليها "),
                          ),
                          Tab(
                            child: Text("مزادات أضفتها "),
                          ),
                        ]),
                      ),
                    ),
                    body: TabBarView(
                          children: [
                            MyBids(myBids: myBids),
                            myBids.isNotEmpty
                            ? MyAuctionsTab(myAuctions: myBids)
                            : Center(
                                child: SvgPicture.asset("assets/nobids.svg"),
                              ),
                      ],
                      ),
                    ),

              );
        });
  }
}
