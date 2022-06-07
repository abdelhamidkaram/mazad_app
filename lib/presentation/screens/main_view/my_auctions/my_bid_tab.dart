import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';

class MyBids extends StatefulWidget {
  final  List<ProductModel> myBids;
  const MyBids({Key? key , required this.myBids} ) : super(key: key);
  @override
  State<MyBids> createState() => _MyBidsState();
}
class _MyBidsState extends State<MyBids> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.separated(
        itemBuilder:(context, index) =>  ProductItem(isTabsScreen: true ,isFullWidth: true, productModel: widget.myBids[index]),
        separatorBuilder:(context , index )=>const  SizedBox(height: 25,),
        itemCount: widget.myBids.length ,
      ),
    );
  }
}
