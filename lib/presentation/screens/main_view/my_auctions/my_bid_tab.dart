import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/my_bids_model.dart';

import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/product_show_screen.dart';
import 'package:soom/presentation/screens/product/product_screen.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class MyBids extends StatefulWidget {
  const MyBids({Key? key,}) : super(key: key);

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAuctionsCubit , MyAuctionsStates >(
      listener: (context , state )=> MyAuctionsCubit(),
      builder: (context, state) {
        var cubit = MyAuctionsCubit.get(context);
        return FutureBuilder(
            future: cubit.getMyBids(context),
            builder: (context, snapShot) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  onRefresh: () => cubit.getMyBids(context , isRefresh: true),
                  child: cubit.isEmptyLast
                      ?
                  SvgPicture.asset("assets/nobids")
                      :
                  ListView.separated(
                    itemCount: cubit.myBidsForView.length,
                    itemBuilder: (context, index) =>
                       MyBidItemBuilder(myAuctionModel: cubit.myBidsForView.reversed.toList()[index]),
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 16,),
                  ),
                ),
              );
            }
        );
      },
    );
  }
}

class MyBidItemBuilder extends StatelessWidget {
  const MyBidItemBuilder({
    Key? key,
    required this.myAuctionModel,
  }) : super(key: key);

  final MyBidsModel myAuctionModel;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorManger.lightGrey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) {
                  return ProductShowScreen(title: "  " , productId: myAuctionModel.productId,) ;
            },));
          },
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward_ios),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text( "مزايدتك :  ${myAuctionModel.price ?? " غير معروف " }" , style: AppTextStyles.mediumBlue,),
          ),
            subtitle:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( " المزاد :  ${myAuctionModel.productName ?? "غير معروف"}", style: AppTextStyles.mediumBlack,),
            ),
        ),
      ),
    );
  }
}
