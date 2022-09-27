import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/main.dart';
import 'package:soom/models/favorite_model.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/states.dart';
import 'package:soom/extension.dart';


class FavoriteCubit extends Cubit<FavoriteStates>{
  FavoriteCubit() : super(InitialFavoriteState());

  static FavoriteCubit get(context)=>BlocProvider.of(context);
  bool isFinish = false ;
  bool isFirstBuild = true ;
  bool isLoading = true ;
  List<FavoriteModel> favoritesItemsResponse = [];
  List<FavoriteModel> favoritesItems = [];
  bool isEmpty = false ;
  List<ProductForViewModel> favoritesItemsForView  = [] ;
  Future getFavorite (context , {bool isRefresh = false }) async {
    if(((favoritesItemsForView.isEmpty && !isEmpty ) || isRefresh) && token.isNotEmpty) {
    emit(GetFavoriteLoading());
    AppCubit.get(context).getProfileDetails(context).then((value){
    DioFactory(token).getData(ApiEndPoint.myFavorite, {
      "UserNameFilter" : AppCubit.get(context).profileEditSuccess.result!.userName
    }).then((value){
      List  response = value.data["result"]["items"] ;
      favoritesItemsResponse = response.map((e) => FavoriteModel.fromJson(e)).toList();
      if(value.data["result"]["totalCount"] > 0 ){
        List responseList = value.data["result"]["items"] ;
       favoritesItemsForView = responseList.map(
               (e) => FavoriteModel.fromJson(e).toProductViewModel(context)).toList() ;
       isEmpty = false ;
       isLoading = false ;
        emit(GetFavoriteSuccess());
      }else{
          isEmpty = true ;
          isLoading = false ;

          emit(GetFavoriteSuccess());
      }
    }).catchError((err){
      if (kDebugMode) {
        print(err);
      AppToasts.toastError(err.toString(), context);
      }
      isLoading = false ;
      emit(GetFavoriteError());
    }
    );
    });
    }else {
      Future.value("") ;
    }

  }

 Future  deleteFavorite(ProductForViewModel productForViewModel , context ) async {
    emit(DeleteFavoriteForViewLoading());
    for(var fav in favoritesItemsResponse){
      if(fav.product!.id == productForViewModel.productModel.product!.id ){
        String newToken = token ;
        await DioFactory(newToken).deleteData(ApiEndPoint.deleteFavorite, {
          "id" : fav.productFavorite!.id,
        }).then((value){
          if (kDebugMode) {
            print(value.toString());
          }
          productForViewModel.isFavorite = false;
          favoritesItemsForView.remove(productForViewModel);
          getFavorite(context);
          emit(DeleteFavoriteForViewSuccess());
        }).catchError((error){
          if (kDebugMode) {
          AppToasts.toastError("message", context);
            print(error.toString());
          }
          emit(DeleteFavoriteForViewError());
        });
      }
    }

  }

 Future  addTOFavorite(ProductForViewModel productForViewModel , context ) async {
   String newToken = token;
       DioFactory(newToken).postData(ApiEndPoint.addToFavorite, {
         "userId" :  id,
         "productId" : productForViewModel.productModel.product!.id.toString()
       }).then((value){
         productForViewModel.isFavorite = true;
         favoritesItemsForView.add(productForViewModel);
         isEmpty = false ;
         getFavorite(context , isRefresh: true );
         emit(AddFavoriteForViewSuccess());
       }).catchError((error){
         emit(AddFavoriteForViewError());
       });
  }

  Future changeFavoriteButton(ProductForViewModel productForViewModel  , context ) async {
    productForViewModel.isFavorite = !productForViewModel.isFavorite ;
    if(productForViewModel.isFavorite){
      addTOFavorite(productForViewModel, context).then((value){
        productForViewModel.isFavorite = true ;
        emit(AddFavoriteForViewSuccess());
      }).catchError((err){
        emit(AddFavoriteForViewError());
        productForViewModel.isFavorite = !productForViewModel.isFavorite ;
      });

    }else{
      deleteFavorite(productForViewModel, context).then((value){
        for (var element in favoritesItemsResponse) {
          if(element.product!.id ==  productForViewModel.productModel.product!.id ){
            favoritesItemsResponse.remove(element);
            break;
          }
        }
        emit(DeleteFavoriteForViewSuccess());
      }).catchError((err){
        emit(DeleteFavoriteForViewError());
        productForViewModel.isFavorite = !productForViewModel.isFavorite ;
      });
    }
    emit(ChangeFavoriteButtonSuccess());
  }

}