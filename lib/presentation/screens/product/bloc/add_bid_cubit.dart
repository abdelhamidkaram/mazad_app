import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/main.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_states.dart';

import '../../../../data/cache/prefs.dart';

class BidCubit extends Cubit<BidStates> {
  BidCubit() : super(InitBidState());

  static BidCubit get(context) => BlocProvider.of(context);
  var controller = TextEditingController();
  bool isAddBid = false;
  int bidCounter = 100;

  TextEditingController getController(  context ,   ProductForViewModel productModel) {
    String newToken = token;
    DioFactory(newToken).getData(ApiEndPoint.getLastBid, {
      "id":productModel.productModel.product!.id ,
    });
    controller.text = (!isAddBid ? productModel.lasPrice : controller.text) ?? 200.toString();
    emit(GetBidController());
    return controller;
  }

  addBid(ProductForViewModel productForViewModel ,  context) {
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price < productForViewModel.minPrice!.toInt() //TODO: CONVERT TO LAST PRICE
    ) {
      controller.text = productForViewModel.minPrice!.toInt().toString();
      emit(AddBidError());
    } else {
      price = int.parse(controller.text) + bidCounter;
      if (kDebugMode) {
        print("add");
      }
      isAddBid = true;
      controller.text = price.toString();
      emit(AddBidSuccess());
    }
    emit(AddBidSuccess());
  }

  removeBid(ProductForViewModel productModel , context ) {
    //TODO LAST PRICE
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price <= productModel.minPrice!.toInt()) {
      price = productModel.minPrice!.toInt();
      AppToasts.toastError(
          "لقد ادخلت سعرا اقل من اخر مزايدة يجب ان تزايد بمبلغ اكبر من : ${productModel.minPrice}",//TODO : LAST PRICE
          context);
      emit(RemoveBid());
    } else {
     controller.text = (int.parse(controller.text) - bidCounter ).toString();
    }
    emit(RemoveBid());
  }

 Future sendBidToServer({required double price, required int productId, required context}) async {
    emit(SendBidToServerLoading());
    AppToasts.toastLoading(context);
    String newToken = token;
   await DioFactory(newToken).postData(ApiEndPoint.addBid, {
     "price": price,
     "userId": int.parse(id) ,
     "productId": productId ,
   }).then((value){
     Navigator.pop(context);
       AppToasts.toastSuccess(" تمت عملية المزايدة بنجاح", context);
       Timer(const Duration(seconds: 2), (){
         Navigator.of(context).pop();
       }
       );

     emit(SendBidToServerSuccess());
   }).catchError((error){
     Navigator.pop(context);
     if(kDebugMode){
       print(error.toString());
       showDialog(context: context, builder: (context )=> Dialog(
         child: Text(error.toString()),
       ));
     }
     AppToasts.toastError("حدث خطأ ما يرجي اعادة المحاولة لاحقا ! ", context);
     Timer(const Duration(seconds: 2 ), (){
       Navigator.of(context).pop();
     });
     emit(SendBidToServerError());
   });
 }
}
