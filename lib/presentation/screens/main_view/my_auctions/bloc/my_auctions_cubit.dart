import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/models/bids_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../main.dart';
import '../../../../../models/product_model.dart';

class MyAuctionsCubit extends Cubit<MyAuctionsStates>{
  MyAuctionsCubit() : super(InitAuctionState());

  static MyAuctionsCubit get(context) => BlocProvider.of(context);


  List myBidsDetails = [] ;
  bool isFirstBuild = false ;
  bool isFinish = false ;



  bool isLoading = true ;
  bool isEmpty = false ;
  List<ProductForViewModel> myProductsForView = [];
  Future getMyProducts (context , {bool isRefresh = false }) async {
    if((myProductsForView.isEmpty && !isEmpty) || isRefresh){
      emit(GetMyProductForViewLoading());
      String newToken = token;
      DioFactory(newToken).getData(ApiEndPoint.getAllProducts, {
        "MaxResultCount" : 10000,
        "CreatedBy" : id
      }).then((value){
        if(value.data["result"]["totalCount"] > 0 ){
          List responseList = value.data["result"]["items"] ;
          myProductsForView = responseList.map((ele){
            var e = ProductForViewModel("", ProductModel.fromJson(ele));
            for (var bid in HomeCubit.get(context).allLastBids) {
              if (bid.productId == e.productModel.product!.id) {
                if (bid.price != null) {
                  e.lasPrice = bid.price!.toInt().toString();
                  return e;
                } else {
                  e.lasPrice =
                      e.productModel.product!.minPrice!.toInt().toString();
                  return e;
                }
              }
            }
            e.lasPrice = e.productModel.product!.minPrice!.toInt().toString();
            return e;
          }).toList();

          isEmpty = false ;
          isLoading = false ;
          emit(GetMyProductForViewSuccess());
        }else{
          isEmpty = true ;
          isLoading = false ;
          emit(GetMyProductForViewSuccess());
        }
      }).catchError((err){
        isLoading = false ;
        if (kDebugMode) {
          print(err);
          AppToasts.toastError("$err", context);
        }
        emit(GetMyProductForViewError());
      }) ;
    }else{
      isLoading = false ;
    return Future.value("") ;
    }

  }


  bool isEmptyLast = false ;
  List<BidsModel> myBidsForView = [];

  Future<Response?> getMyBids (context , {bool isRefresh = false }) async {
    if(((myBidsForView.isEmpty && !isEmptyLast) || isRefresh) && token.isNotEmpty){
      emit(GetMyBidForViewLoading());
     await DioFactory(token).getData(ApiEndPoint.myBid, {
        "UserId" : id
      }).then((value){

        if (kDebugMode) {
          print(value.data["result"]);
        }
        List responseList = value.data["result"]["items"];
        if(value.data["result"]["totalCount"] != 0 ){
          myBidsForView = responseList.map((e) => BidsModel.fromJson(e)).toList();
          isEmptyLast = false ;
          emit(GetMyBidForViewSuccess());
          return value;
        }else{
          isEmptyLast = true ;
          emit(GetMyBidForViewSuccess());
          return Response(requestOptions: RequestOptions(path:"0" , data: "empty") , statusCode: -1);
        }
      }).catchError((err){
        if (kDebugMode) {
          print(err);
          AppToasts.toastError("$err", context);
        }
        emit(GetMyBidForViewError());
      });
    }
  }



}

