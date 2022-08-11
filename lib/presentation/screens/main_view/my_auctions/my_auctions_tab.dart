import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';

class MyAuctionsTab extends StatefulWidget {
  final  List<ProductForViewModel> myAuctions;
  const MyAuctionsTab({Key? key , required this.myAuctions} ) : super(key: key);
  @override
  State<MyAuctionsTab> createState() => _MyAuctionsTabState();
}

class _MyAuctionsTabState extends State<MyAuctionsTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.separated(
        itemBuilder:(context, index) =>  ProductItem(isMyAuction: true ,isFullWidth: true, productModel: widget.myAuctions[index]),
        separatorBuilder:(context , index )=> const  SizedBox(height: 25,),
        itemCount: widget.myAuctions.length ,
      ),
    );
  }
}
