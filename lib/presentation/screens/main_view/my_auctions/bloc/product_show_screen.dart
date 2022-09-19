import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soom/main.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/product/product_screen.dart';
import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';

class ProductShowScreen extends StatefulWidget {
  final String  title ;
  final int?  productId ;
  const ProductShowScreen({Key? key,required this.title , required this.productId}) : super(key: key);

  @override
  State<ProductShowScreen> createState() => _ProductShowScreenState();
}

class _ProductShowScreenState extends State<ProductShowScreen> {
  @override
  Widget build(BuildContext context) {
    String newToken = token ;
return FutureBuilder(
  future: DioFactory(newToken).getData(ApiEndPoint.getProductById, {
    "id":widget.productId
  }),
  builder: (context, snapshot) {
    if(snapshot.hasData){
      Response? response = snapshot.data as Response ;
      String lastPrice = ProductModel.fromJson(response.data["result"]).product!.minPrice.toString();
      for(var bid in HomeCubit.get(context).allLastBids){
        if(bid.productId ==ProductModel.fromJson(response.data["result"]).product!.id ){
          lastPrice = bid.price.toString();
        }
      }
      return
      ProductScreen(
          productModel: ProductForViewModel(
              "", ProductModel.fromJson(response.data["result"])), lastPrice: lastPrice
          ,
      );
    }else{
   return Scaffold(
    appBar: AppBars.appBarGeneral(context, HomeCubit(), widget.title , cartView: false ),
    body: (!snapshot.hasError)
    ?
    const  Center(child: CircularProgressIndicator())
        :
    const Center(
    child: Text("حدث خطأ ما .. حاول لاحقا !"),
    ) ,);
    }
  });
  }
}
