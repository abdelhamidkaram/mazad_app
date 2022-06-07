import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/product/bloc/product_states.dart';

class BidCubit extends Cubit<BidStates> {
  BidCubit() : super(InitBidState());

  static BidCubit get(context) => BlocProvider.of(context);
  var controller = TextEditingController();
  bool isAddBid = false;
  int bidCounter = 100;

  TextEditingController getController(ProductModel productModel) {
    controller.text = !isAddBid ? productModel.lasPrice : controller.text;
    emit(GetBidController());
    return controller;
  }

  addBid(ProductModel productModel, context) {
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price < int.parse(productModel.lasPrice)) {
      controller.text = int.parse(productModel.lasPrice).toString();
      emit(AddBidError());
    } else {
      price = int.parse(controller.text) + bidCounter;
      print("add");
      isAddBid = true;
      controller.text = price.toString();
      emit(AddBid());
      //TODO:SEND PRICE TO SERVER
    }
    emit(AddBid());
  }

  removeBid(ProductModel productModel , context ) {
    int price = int.parse(controller.text);
    if (price.isNaN ||
        price.isNegative ||
        price <= int.parse(productModel.lasPrice)) {
      price = int.parse(productModel.lasPrice);
      AppToasts.toastError(
          "لقد ادخلت سعرا اقل من اخر مزايدة يجب ان تزايد بمبلغ اكبر من : ${productModel.lasPrice}",
          context);
      emit(RemoveBid());
    } else {

     controller.text = (int.parse(controller.text) - bidCounter ).toString();
    }
    emit(RemoveBid());
  }


}
