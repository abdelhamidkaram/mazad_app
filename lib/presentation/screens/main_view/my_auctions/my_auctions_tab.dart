import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';


class MyAuctionsTab extends StatefulWidget {

  const MyAuctionsTab({Key? key}) : super(key: key);

  @override
  State<MyAuctionsTab> createState() => _MyAuctionsTabState();
}

class _MyAuctionsTabState extends State<MyAuctionsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAuctionsCubit , MyAuctionsStates >(
      listener: (context , state )=> MyAuctionsCubit(),
      builder: (context, state) {
      var cubit = MyAuctionsCubit.get(context);

      return FutureBuilder(
          future: cubit.getMyProducts(context).then((value){
            setState(() {

            });
          }),
          builder: (context, snapShot) {
            if( cubit.isLoading ){
              return const Center(child:  CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () => cubit.getMyProducts(context , isRefresh: true),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: cubit.isEmpty ? SvgPicture.asset("assets/nobids") : ListView
                    .separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cubit.myProductsForView.length,
                  itemBuilder: (context, index) =>
                      ProductItem(
                        isFullWidth: true,
                        productForViewModel: cubit.myProductsForView.reversed.toList()[index],
                      ),
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
