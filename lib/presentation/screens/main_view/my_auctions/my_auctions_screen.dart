import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_auctions_tab.dart';
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
          if(cubit.myBidsForView.isEmpty && cubit.isFirstBuild ){
            cubit.getMyBid("testmob3",context).then((value){ cubit.isFinish = true ;});
            cubit.isFirstBuild = true ;
          }
          if((state is GetMyBidForViewLoading || state is GetMyBidLoading ) && cubit.myBidsForView.isEmpty  ){
            return const  Center(child:  CircularProgressIndicator(),);
          }
          List<ProductForViewModel> myProducts  = cubit.myProductsForView;
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
                       cubit.myBidsForView.isNotEmpty
                                  ?
                              Padding(
                                padding: const EdgeInsets.only(left: 16 , right: 16 , top: 16 ),
                                child: RefreshIndicator(
                                  onRefresh: () =>  cubit.getMyBid("testmob3", context).then((value){
                                    setState(() {

                                    });
                                  }) ,
                                  child: ListView.separated(
                                        itemBuilder: (context, index) => ProductItem(
                                            isFullWidth: true,
                                            productForViewModel: cubit.myBidsForView[index],
                                        ) ,
                                      separatorBuilder:(context, index) => const SizedBox(
                                        height: 20,
                                      ) ,
                                      itemCount:cubit.myBidsForView.length ,
                                    ),
                                ),
                              )
                                  :
                              Center(
                                child:  ((state is GetMyBidLoading || state is GetMyBidForViewLoading ) && cubit.myBidsForView.isEmpty) ? const CircularProgressIndicator() :  SvgPicture.asset("assets/nobids.svg")  ,
                              ) ,

                            myProducts.isNotEmpty
                            ? MyAuctionsTab(myAuctions: myProducts)
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
