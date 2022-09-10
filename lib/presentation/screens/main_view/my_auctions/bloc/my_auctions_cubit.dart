import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/models/my_bids_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../data/cache/prefs.dart';
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
        "CreatedBy" : id
      }).then((value){
        if(value.data["result"]["totalCount"] >= 0 ){
          List responseList = value.data["result"]["items"] ;
          myProductsForView = responseList.map((e) => ProductForViewModel("00", ProductModel.fromJson(e))).toList();

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
  List<MyBidsModel> myBidsForView = [];

  Future getMyBids (context , {bool isRefresh = false }) async {
    if((myBidsForView.isEmpty && !isEmptyLast) || isRefresh){
      emit(GetMyBidForViewLoading());
      String newToken = token;
      DioFactory(newToken).getData(ApiEndPoint.myBid, {
        "UserId" : id
      }).then((value){
        List responseList = value.data["result"];
        if(responseList.isNotEmpty ){
          myBidsForView = responseList.map((e) => MyBidsModel.fromJson(e)).toList();
          isEmptyLast = false ;
          emit(GetMyBidForViewSuccess());
        }else{
          isEmptyLast = true ;
          emit(GetMyBidForViewSuccess());
        }
      }).catchError((err){
        if (kDebugMode) {
          print(err);
          AppToasts.toastError("$err", context);
        }
        emit(GetMyBidForViewError());
      });
    }else{
      Future.value("") ;
    }
  }



}

