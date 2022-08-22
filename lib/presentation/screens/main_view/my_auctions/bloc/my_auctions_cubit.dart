import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';
import '../../../../../constants/api_constants.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../models/product_model.dart';
import '../../../../components/toast.dart';

class MyAuctionsCubit extends Cubit<MyAuctionsStates>{
  MyAuctionsCubit() : super(InitAuctionState());

  static MyAuctionsCubit get(context) => BlocProvider.of(context);
  List<ProductForViewModel> myBidsForView = [];
  List myBidsDetails = [] ;
  bool isFirstBuild = false ;
  Future getMyBid (String userName , context )async{
    emit(GetMyBidLoading());
    await DioFactory().getData(ApiEndPoint.myBid, {
      "UserNameFilter": userName ,
    }).then((value){
      myBidsDetails = value.data["result"]["items"];
      getMyBidForView(context).then((value) => null);
      emit(GetMyBidSuccess());
    }).catchError((error){
      emit(GetMyBidError());
      AppToasts.toastError("حدث حطأ اثناء جلب مزايداتك حاول لاحقا ! ", context);
    });
  }
  Future<List<ProductForViewModel>> getMyBidForView(context)async {
       List<ProductForViewModel> _myProductsActions = [];
       emit(GetMyBidForViewLoading());
       for(Map bid in myBidsDetails ){
         DioFactory().getData(ApiEndPoint.getAllProducts, {
           "NameFilter" : bid["productName"]
         }).then((value){
           //TODO: LAST PRICE
           _myProductsActions.add(ProductForViewModel(
            "20 ",
             ProductModel.fromJson(value.data["result"]["items"][0]),
             bid["productAuaction"]["price"].toString(), "12" , ) ,
           );
         }).catchError((error){
           kDebugMode ? print(error.toString()): null ;
           emit(GetMyBidForViewError());
         });
       }
       myBidsForView = _myProductsActions.reversed.toList() ;
       emit(GetMyBidForViewSuccess());
       return _myProductsActions ;
     }

}