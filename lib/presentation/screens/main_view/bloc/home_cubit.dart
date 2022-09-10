import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/home_screen/categoreis_block_model.dart';
import 'package:soom/repository/repository.dart';
import 'package:soom/style/text_style.dart';

import '../../../../data/cache/prefs.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  bool isFirstBuild = false ;
  final Repository _repository = Repository();
  int cardNumber = 5;
  int slideCount = 0;
  int currentIndex = 0;
  changeBottomNavBar() {
    emit(ChangeBottomNBIndex());
  }


  // ------------------ exit method --------------//
  Future<bool> onWillPop(context,) async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'انت علي وشك الخروخ ',
                style: AppTextStyles.titleBlack,
              ),
              content: const Text(
                'هل حقا تريد الخروج من التطبيق ؟',
                style: AppTextStyles.mediumGrey,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('نعم', style: AppTextStyles.mediumBlack),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'لا',
                    style: AppTextStyles.mediumBlue,
                  ),
                ),
              ],
            ),
          ),
    )) ??
        false;
  }


  // TODO :  ADD LAST PRICE TO PRODUCT MODEL
  List<ProductForViewModel> products = [];

  Future getProducts(context) async {
   await FavoriteCubit.get(context).getFavorite(context);
    emit(GetProductsLoading());
    // await FavoriteCubit.get(context).getFavorite(context).then((value) => null);
    (
        await _repository.getProducts(maxResult: 1000)
    ).fold((errorModel) {
      emit(GetProductsError());
      if (kDebugMode) {
        print(errorModel.message);
      }

    }, (productsResponse) {
      //TODO: GET THE last price  and last price
      List<ProductForViewModel > productsList = productsResponse.map(
              (product)=> ProductForViewModel("2000", product,)).toList().reversed.toList();
      for(var i = 0 ; i < productsList.length ; i++ ){
        for(var fav in FavoriteCubit.get(context).favoritesItemsResponse ){
          if(fav.product!.name == productsList[i].title){
            productsList[i].isFavorite = true ;
          }
        }

      }
      products = productsList ;
      getCategoryBlocks();
      emit(GetProductsSuccess());
    });
  }

//-------------------- get last Price ------------||
  Future<String> getLastPrice(int id) async {
    String newToken = "";
    SharedPreferences.getInstance().then((value){
      newToken =  value.getString(PrefsKey.token)!;
    });
    DioFactory dioFactory = DioFactory(newToken) ;
    dioFactory.getData(ApiEndPoint.getLastBid, {
      "id":id
    }).then((value){
      emit(GetLastPriceSuccess());
      return value.data["result"]["price"].toString();
    }).catchError((erro){
     if (kDebugMode) {
       print(erro.toString());
     }
    });
    return "000" ;
  }

  // ------------------ get category  --------------//

  List<CategoryModel> categories = [];
  bool isGetCatsFinish = false ;

  Future getCategories(context) async {
    emit(GetCategoriesLoading());
    (
        await _repository.getCategories()
    ).fold((errorModel) {
      isGetCatsFinish = true ;
      if (kDebugMode) {
        print(errorModel.message);
      }
      LoginCubit.get(context).logOut(context);
      emit(GetCategoriesError());
    }, (categoriesList) {
      isGetCatsFinish = true ;
      categories = categoriesList;
      emit(GetCategoriesSuccess());
    });
  }

  // ------------------ get categoryBlock  --------------//

   List<CategoryBlockModel> categoriesBlocks = [];
  Future getCategoryBlocks() async {
     emit(GetCategoriesBlockLoading());
     for(var cat in categories ){
       List<ProductForViewModel> productsList = [];
       for(var product in products ){
       if(cat.title == product.productModel.categoryName){
         productsList.add(product);
       }
     }
       categoriesBlocks.add(CategoryBlockModel(cat.title!, productsList , cat ));
   }
     emit(GetCategoriesBlockSuccess());

   }


  // ------------------ filter method --------------//

  int maxRangeFilter = 6000;
  int minRangeFilter = 3000;

  RangeValues getRangeValues() =>
      RangeValues(minRangeFilter.toDouble(), maxRangeFilter.toDouble());

  changeRangeValue(RangeValues value) {
    minRangeFilter = value.start.toInt();
    maxRangeFilter = value.end.toInt();
    getRangeValues();
    emit(ChangeRangeValue());
  }

  bool isMost = true;
  bool isLess = false;
  bool isNew = false;
  bool isOld = false;

  changeFilter() {
    emit(ChangeFilter());
  }

  List<CategoryModel> filterCategories = [];

  addToFilterCategories(CategoryModel categoryModel) {
    filterCategories.add(categoryModel);
  }

  deleteFromFilterCategories(CategoryModel categoryModel) {
    filterCategories.remove(categoryModel);
    emit(DeleteFromFilterCategories());
  }

  deleteAllFilterCategories(CategoryModel categoryModel) {
    filterCategories = [];
    emit(DeleteAllFilterCategories());
  }

  deleteFilter() {
    isMost = true;
    isLess = false;
    isNew = false;
    isOld = false;
    filterCategories = [];
    maxRangeFilter = 6000;
    minRangeFilter = 3000;
    changeRangeValue(
        RangeValues(minRangeFilter.toDouble(), maxRangeFilter.toDouble()));
    emit(DeleteFilterState());
  }

// ------------------  filter Result --------------//
  List<ProductForViewModel> filterResult = [];

  Future<List<ProductForViewModel>> getFilterResult(context) async {
    emit(GetFilterResultLoading());

     (
       await  _repository.getProductsBaseOnFilter(
          maxResult: 200 ,
          categoryModel: filterCategories.isNotEmpty ? filterCategories[0] : categories[0] , //TODO: FILTER LIST NOT STRING
          isMost: isMost,
          isLess: isLess,
          isNew: isNew,
          isOld: isOld,
          minRang: minRangeFilter.toDouble(),
          maxRang: maxRangeFilter.toDouble() ,
        )
    ).fold(
   (error){
      AppToasts.toastError(error.message, context);
      filterResult = [] ;
     },
   (productsList) {
     //TODO :  LAST Auction Counter
     filterResult =  productsList.map((e) => ProductForViewModel( "20", e,)).toList();
     });

      emit(GetFilterResultSuccess());

      if (kDebugMode) {
        print("------------------\n");
      }
      if (kDebugMode) {
        print(filterResult);
      }
    return filterResult;
  }


// ------------------  search Result --------------//

  List<ProductForViewModel> searchResult = [];

  Future<List<ProductForViewModel>> getSearchResult( String searchKeyword , context) async {
    emit(GetSearchLoading());
    searchResult = [];
    (
        await _repository.getProductsBaseOnSearchFilter(
        searchKeywords: searchKeyword,
        maxResult: 100
        )
    ).fold((error){
      emit(GetSearchError());

      AppToasts.toastError(error.message, context);
    }, (productsList){
      //TODO: FAVORITE AND LAST PRICE
     searchResult =  productsList.map((productDetailsModel)=> ProductForViewModel("20", productDetailsModel)).toList();
     emit(GetSearchSuccess());
     return searchResult;
    });
    return searchResult;
  }


}
