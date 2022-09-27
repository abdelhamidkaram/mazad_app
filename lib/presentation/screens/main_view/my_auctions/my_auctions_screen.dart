import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_auctions_tab.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_bid_tab.dart';
import 'package:soom/style/color_manger.dart';
import '../../../components/login_required_widget.dart';


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
          if(cubit.myBidsForView.isEmpty && !cubit.isEmptyLast ){
            cubit.getMyBids(context).then((value){
              cubit.isFirstBuild = true ;
            });
          }
          if((state is GetMyBidForViewLoading || state is GetMyBidLoading ) && cubit.myBidsForView.isEmpty  ){
            return const  Center(child:  CircularProgressIndicator(),);
          }

          return token.isNotEmpty
              ?
          DefaultTabController(
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
                    // ignore: prefer_const_constructors
                    body: TabBarView(
                      // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
                          children:  [
                           // ignore: prefer_const_constructors
                           MyBids() ,
                            // ignore: prefer_const_constructors
                            MyAuctionsTab() , 
                      ],
                      ),
                    ),

              )
          :
          const LoginRequiredWidget(message: "يرجي تسجيل الدخول لعرض مزاداتك  ");



        });
  }
}

