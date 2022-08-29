import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/auction_model.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_cubit.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_states.dart';

class BidCubit extends Cubit<BidStates> {
  BidCubit() : super(InitBidState());

  static BidCubit get(context) => BlocProvider.of(context);
  var controller = TextEditingController();
  bool isAddBid = false;
  int bidCounter = 100;

  TextEditingController getController(  context ,   ProductForViewModel productModel) {
    MyAuctionsCubit.get(context).myBidsForView.add(productModel);
    controller.text = (!isAddBid ? productModel.lasPrice : controller.text) ?? 200.toString();
    emit(GetBidController());
    return controller;
  }

  addBid(ProductForViewModel productForViewModel ,  context) {
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price < int.parse(productForViewModel.lasPrice!)) {
      controller.text = int.parse(productForViewModel.lasPrice!).toString();
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
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price <= int.parse(productModel.lasPrice!)) {
      price = int.parse(productModel.lasPrice!);
      AppToasts.toastError(
          "لقد ادخلت سعرا اقل من اخر مزايدة يجب ان تزايد بمبلغ اكبر من : ${productModel.lasPrice}",
          context);
      emit(RemoveBid());
    } else {

     controller.text = (int.parse(controller.text) - bidCounter ).toString();
    }
    emit(RemoveBid());
  }

 Future sendBidToServer(AuctionForViewModel auctionForViewModel ,  context ) async {
    emit(SendBidToServerLoading());
    AppToasts.toastLoading(context);
   await DioFactory().postData(ApiEndPoint.addBid, {
     "price": auctionForViewModel.price,
     "userId": auctionForViewModel.userModel.userId,
     "productId": auctionForViewModel.productModel.product!.id,
   }).then((value){
     Navigator.pop(context);
     if(kDebugMode){
       AppToasts.toastSuccess(value.data["success"].toString() , context);
     }else{
       AppToasts.toastSuccess(" تمت عملية المزايدة بنجاح", context);
       Timer(const Duration(seconds: 2), (){
         Navigator.of(context).pop();
       }
       );
     }
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
