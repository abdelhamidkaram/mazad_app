import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/main.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/login/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/home_screen/categoreis_block_model.dart';
import 'package:soom/repository/repository.dart';
import 'package:soom/style/text_style.dart';
import '../../../../models/bids_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  bool isFirstBuild = false;

  final Repository _repository = Repository();
  int cardNumber = 5;
  int slideCount = 0;
  int currentIndex = 0;

  changeBottomNavBar() {
    emit(ChangeBottomNBIndex());
  }

  // ------------------ exit method --------------//
  Future<bool> onWillPop(
    context,
  ) async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
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

  // ------------------ products  --------------//
  // TODO :  ADD LAST PRICE TO PRODUCT MODEL
  List<ProductForViewModel> products = [];
  List<BidsModel> allLastBids = [];

  Future getProducts(context) async {
    await getAllLastBids(context).then((value) async {
      await FavoriteCubit.get(context).getFavorite(context);
      emit(GetProductsLoading());
      (await _repository.getProducts(maxResult: 1000, lastBids: value)).fold(
          (errorModel) {
        emit(GetProductsError());
        if (kDebugMode) {
          print(errorModel.message);
        }
        return;
      }, (productsResponse) {
        List<ProductForViewModel> productsList =
            productsResponse.reversed.toList();
        for (var i = 0; i < productsList.length; i++) {
          for (var fav in FavoriteCubit.get(context).favoritesItemsResponse) {
            if (fav.product!.name == productsList[i].title) {
              productsList[i].isFavorite = true;
            }
          }
        }
        products = productsList.map((e) {
          for (var bid in allLastBids) {
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
        emit(GetProductsSuccess());
        getCategoryBlocks();
      });
      emit(GetProductsSuccess());
    });
  }

  Future<List<BidsModel>> getAllLastBids(context) async {
    emit(GetAllLastBidsLoading());
    DioFactory(token).getData(ApiEndPoint.getAllLastBids, {}).then((value) {
      emit(GetAllLastBidsSuccess());
      List responseList = value.data["result"];
      allLastBids = responseList.map((e) => BidsModel.fromJson(e)).toList();
    }).catchError((err) {
      if (kDebugMode) {
        print(err.toString());
      }
      emit(GetAllLastBidsError());
      LoginCubit.get(context).logOut(context);
    });
    return allLastBids;
  }

//-------------------- get last Price ------------||
  Future<String> getLastPrice(int id) async {
    String newToken = token;
    DioFactory dioFactory = DioFactory(newToken);
    dioFactory.getData(ApiEndPoint.getLastBid, {"id": id}).then((value) {
      emit(GetLastPriceSuccess());
      return value.data["result"]["price"].toString();
    }).catchError((erro) {
      if (kDebugMode) {
        print(erro.toString());
      }
    });
    return "000";
  }

  // ------------------ get category  --------------//

  List<CategoryModel> categories = [];
  bool isGetCatsFinish = false;

  Future getCategories(context) async {
    emit(GetCategoriesLoading());
    (await _repository.getCategories()).fold((errorModel) {
      isGetCatsFinish = true;
      if (kDebugMode) {
        print(errorModel.message);
      }
      LoginCubit.get(context).logOut(context);
      emit(GetCategoriesError());
    }, (categoriesList) async {
      isGetCatsFinish = true;
      categories = categoriesList;
      emit(GetCategoriesSuccess());
    });
  }

  // ------------------ get categoryBlock  --------------//

  List<CategoryBlockModel> categoriesBlocks = [];

  Future getCategoryBlocks() async {
    emit(GetCategoriesBlockLoading());
    for (var cat in categories) {
      List<ProductForViewModel> productsList = [];
      for (var product in products) {
        if (cat.title == product.productModel.categoryName) {
          productsList.add(product);
        }
      }
      categoriesBlocks.add(CategoryBlockModel(cat.title!, productsList, cat));
    }

    emit(GetCategoriesBlockSuccess());
  }

  // ------------------ filter method --------------//

  int maxRangeFilter = 6000;
  int minRangeFilter = 3000;
  var minController = TextEditingController();
  var maxController = TextEditingController();

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

    (await _repository.getProductsBaseOnFilter(
      maxResult: 200,
      categoryModel:
          filterCategories.isNotEmpty ? filterCategories[0] : categories[0],
      //TODO: FILTER LIST NOT STRING
      isMost: isMost,
      isLess: isLess,
      isNew: isNew,
      isOld: isOld,
      minRang: double.parse(
          minController.text.isNotEmpty ? minController.text : "0.0"),
      maxRang: double.parse(
          maxController.text.isNotEmpty ? maxController.text : "10000.0"),
    ))
        .fold((error) {
      AppToasts.toastError(error.message, context);
      filterResult = [];
    }, (productsList) {
      //TODO :  LAST Auction Counter
      filterResult = productsList.map((e) {
      var ele =   ProductForViewModel(
          "",
          e,
        );
      for(var bid in allLastBids ){
        if(bid.id == e.product!.id){
          ele.lasPrice = bid.price!.toInt().toString();
          return ele ;
        }
      }
      ele.lasPrice = e.product!.minPrice!.toInt().toString();
      return ele ;
      }).toList();
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

  Future<List<ProductForViewModel>> getSearchResult(
      String searchKeyword, context) async {
    emit(GetSearchLoading());
    searchResult = [];
    (await _repository.getProductsBaseOnSearchFilter(
            searchKeywords: searchKeyword, maxResult: 100))
        .fold((error) {
      emit(GetSearchError());

      AppToasts.toastError(error.message, context);
    }, (productsList) {
      searchResult = productsList.map((productDetailsModel) {
        if (FavoriteCubit.get(context).favoritesItemsResponse.isNotEmpty) {
          for (var fav in FavoriteCubit.get(context).favoritesItemsResponse) {
            if (fav.product!.id == productDetailsModel.product!.id) {
              return ProductForViewModel("20", productDetailsModel,
                  isFavorite: true);
            }
          }
        }
        var ele =  ProductForViewModel("20", productDetailsModel);
        for(var bid in allLastBids ){
          if(bid.id == productDetailsModel.product!.id){
            ele.lasPrice = bid.price!.toInt().toString();
            return ele ;
          }
        }
        ele.lasPrice = productDetailsModel.product!.minPrice!.toInt().toString();
        return ele ;
      }).toList();
      emit(GetSearchSuccess());

      return searchResult;
    });
    return searchResult;
  }
}
