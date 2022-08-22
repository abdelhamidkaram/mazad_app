import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/my_auctions_screen.dart';

class MyBids extends StatefulWidget {
  final List<ProductForViewModel> myBids;
  const MyBids({Key? key, required this.myBids}) : super(key: key);

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyAuctionsCubit , MyAuctionsStates>(
      listener: (context, state) => MyAuctionsCubit(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: widget.myBids.isNotEmpty
            ? ListView.separated(
              itemBuilder: (context, index) => ProductItem(
                  isTabsScreen: true,
                  isFullWidth: true,
                  productForViewModel: widget.myBids[index]),
              separatorBuilder: (context, index) => const SizedBox(
                height: 25,
              ),
              itemCount: widget.myBids.length,
            )
            :  Center(
                child: SvgPicture.asset("assets/nobids.svg"),
              ),
      ),
    );
  }
}
