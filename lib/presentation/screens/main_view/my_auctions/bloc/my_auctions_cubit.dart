import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../models/product_model.dart';

class MyAuctionsCubit extends Cubit<MyAuctionsStates>{
  MyAuctionsCubit() : super(InitAuctionState());

  static MyAuctionsCubit get(context) => BlocProvider.of(context);
  List<ProductForViewModel> myBidsForView = [];
  List<ProductForViewModel> myProductsForView = [];
  List myBidsDetails = [] ;
  bool isFirstBuild = false ;
  bool isFinish = false ;
  Future getMyBid (String userName , context )async{
    emit(GetMyBidLoading());
    await DioFactory().getData(ApiEndPoint.myBid, {
      "UserNameFilter": "testmob3",//TODO: USER NAME
    }).then((value){
      myBidsDetails = value.data["result"]["items"];
      getMyBidForView(context , counter: myBidsDetails.length ).then((value) => null);
      emit(GetMyBidSuccess());
    }).catchError((error){
      emit(GetMyBidError());
    });
  }
  Future getMyBidForView(context , {bool deleteOldList = false , int counter = 0  })async {
       emit(GetMyBidForViewLoading());
       if(deleteOldList){
         myBidsForView = [];
         deleteOldList = false ;
       }
      if(myBidsForView.isEmpty || counter == 0 ){
        for(Map bid in myBidsDetails ){
          --counter;
          DioFactory().getData(ApiEndPoint.getAllProducts, {
            "NameFilter" : bid["productName"]
          }).then((value){
            //TODO: LAST PRICE
            ProductForViewModel productForViewModel = ProductForViewModel(
                "20 ",
                ProductModel.fromJson(value.data["result"]["items"][0]),
                "12" );
            productForViewModel.lasPrice =bid["productAuaction"]["price"].toString() ;
            myBidsForView.add(productForViewModel );
          }).catchError((error){
            if (kDebugMode) {
              print(error.toString()) ;
            }
            emit(GetMyBidForViewError());
          });
        }
        myBidsForView = myBidsForView.reversed.toList() ;
        if (kDebugMode) {
          print("=========================================");
          print(myBidsForView.length);
          print("=========================================");
        }

        emit(GetMyBidForViewSuccess());
      }
     }

}