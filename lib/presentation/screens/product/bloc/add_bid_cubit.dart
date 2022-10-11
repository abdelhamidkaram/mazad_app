import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/main.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_states.dart';
class BidCubit extends Cubit<BidStates> {
  BidCubit() : super(InitBidState());

  static BidCubit get(context) => BlocProvider.of(context);
  var controller = TextEditingController();
  bool isAddBid = false;
  int bidCounter = 1;
  String newLastPrice = "" ;

  TextEditingController getController(  context ,   ProductForViewModel productModel) {
    DioFactory(token).getData(ApiEndPoint.getLastBid, {
      "id":productModel.productModel.product!.id ,
    }).then((value){
      if (kDebugMode) {
        print(value.data);
      }
      if(value.data["result"][0]["price"] != 0 && value.data["result"][0]["price"] != null ){
        controller.text = "${double.parse(value.data["result"][0]["price"].toString()).toInt() + bidCounter }";
        emit(GetBidController());
        return controller;
      }
    });
    if(productModel.lasPrice != null ){
      controller.text = (!isAddBid ? "${double.parse(productModel.lasPrice!).toInt() + bidCounter }"
          : controller.text );
    }

    emit(GetBidController());
    return controller;
  }

 Future sendBidToServer({required double price, required int productId, required BuildContext context}) async {
    emit(SendBidToServerLoading());
    AppToasts.toastLoading("...");
    String newToken = token;
   await DioFactory(newToken).postData(ApiEndPoint.addBid, {
     "price": price,
     "userId": int.parse(idUser) ,
     "productId": productId ,
   }).then((value){
     MyAuctionsCubit.get(context).getMyBids(context , isRefresh: true);
     HomeCubit.get(context).getProducts(context,  false).whenComplete((){
       HomeCubit.get(context).getCategoryBlocks( false);
     });
     newLastPrice = price.toInt().toString();
       AppToasts.toastSuccess(" تمت عملية المزايدة بنجاح");
     emit(SendBidToServerSuccess());
   }).catchError((error){
     if(kDebugMode){
       print(error.toString());
       showDialog(context: context, builder: (context )=> Dialog(
         child: Text(error.toString()),
       ),);
     }
     AppToasts.toastError("حدث خطأ ما يرجي اعادة المحاولة لاحقا ! ");
     emit(SendBidToServerError());
   });
 }

 void deleteNewPrice(){
    newLastPrice = "";
    emit(DeleteNewPrice());
 }


}
