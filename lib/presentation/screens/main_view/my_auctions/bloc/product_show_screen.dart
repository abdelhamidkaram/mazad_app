import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
return FutureBuilder(
  future: getData(),
  builder: (context, snapshot)  {
    if(snapshot.hasData){
      ProductForViewModel productForViewModel = snapshot.data as ProductForViewModel;
      var year = int.parse(
          productForViewModel.productModel.product!.endDate!
              .substring(0, 4));
      var month = int.parse(
          productForViewModel.productModel.product!.endDate!
              .substring(5, 7));
      var day = int.parse(
          productForViewModel.productModel.product!.endDate!
              .substring(8, 10));
      var hour = int.parse(
          productForViewModel.productModel.product!.endDate!
              .substring(11, 13));
      var minute = int.parse(
          productForViewModel.productModel.product!.endDate!
              .substring(14, 16));
      int difference = DateTime.now().toUtc().difference(DateTime.utc(year, month, day , hour ,minute )).inSeconds;
      return ProductScreen(
        productModel: productForViewModel,
        lastPrice: productForViewModel.lasPrice!,
        isFinished: difference >= 0 ,
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

  Future<ProductForViewModel> getData() async {
    Response response = await  DioFactory(token).getData(ApiEndPoint.getProductById, {
  "id":widget.productId
});
    if (kDebugMode) {
      print(response.data);
    }
    String  lastPrice = "1" ;
    ProductModel productModel = ProductModel.fromJson(response.data["result"]);
    await DioFactory(token).getData(ApiEndPoint.getLastBid, {
      "id":productModel.product!.id!
    }).then((value){
      lastPrice = double.parse(value.data["result"][0]["price"].toString()).toInt().toString();
      if (kDebugMode) {
        print(lastPrice);
      }
    });
    return ProductForViewModel(
        "",
        productModel ,
        lasPrice: lastPrice ,
    );
  }
}
