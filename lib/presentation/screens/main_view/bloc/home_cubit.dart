import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/login/login.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/repository/repository.dart';
import 'package:soom/style/text_style.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
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

  // ------------------ get Products  --------------//
  List<ProductForViewModel> products = [];
  Future getProducts (context)async {
    emit(GetProductsLoading());
    (
    await _repository.getProducts()
    ).fold((errorModel){
      emit(GetProductsError());
       if (kDebugMode) {
         print( errorModel.message);
       }
      if(errorModel.statusCode == 401 ){
        AppToasts.toastError("يرجي اعادة تسجيل الدخول " , context);
       }
    }, (productsList) {

      //TODO: GET THE favORiTe  and last price
      products = productsList.map((product)=> ProductForViewModel(false, "2000", product, "200", "12") ).toList();
      emit(GetProductsSuccess());
    });
  }


  // ------------------ get Products  --------------//

  List<CategoryModel> categories = [];
  Future getCategories (context)async {
    emit(GetCategoriesLoading());
    (
        await _repository.getCategories()
    ).fold((errorModel){
      emit(GetCategoriesError());
      AppToasts.toastError("لايمكن جلب المعلومات حاليا (التصنيفات).. حاول لاحقا !", context);
      if (kDebugMode) {
        print( errorModel.message);
      }
      if(errorModel.statusCode == 401 ){
        AppToasts.toastError("يرجي اعادة تسجيل الدخول " , context);
      }
      Timer(const Duration(seconds: 3),() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
      });
    }, (categoriesList) {
      categories = categoriesList;
      emit(GetCategoriesSuccess());
    });
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
  changeFilter(){
    emit(ChangeFilter());
  }

  List<int> filterCategories = [];
   addToFilterCategories(int categoryIndex){
       filterCategories.add(categoryIndex);
   }
   deleteFromFilterCategories(int categoryIndex){
     filterCategories.remove(categoryIndex);
     emit(DeleteFromFilterCategories());
   }
   deleteAllFilterCategories(int categoryIndex){
     filterCategories = [];
     emit(DeleteAllFilterCategories());
   }

  deleteFilter(){
    isMost = true;
    isLess = false;
    isNew = false;
    isOld = false;
    filterCategories = [];
    maxRangeFilter = 6000;
    minRangeFilter = 3000;
    changeRangeValue(RangeValues(minRangeFilter.toDouble(), maxRangeFilter.toDouble()));
    emit(DeleteFilterState());
 }

// ------------------  filter Result --------------//
  List<ProductForViewModel> _filterResult =[];
  List<ProductForViewModel> getFilterResult (){
    emit(GetFilterResultLoading());
    //TODO: GET FILTER RESULT IN SERVER
    List<ProductForViewModel> resultList = [

    ];
    if(resultList.isNotEmpty){
      _filterResult = resultList ;
      emit(GetFilterResultSuccess());
    }
    return _filterResult ;
  }


// ------------------  search Result --------------//

  List<ProductForViewModel> _searchResult =[];
  List<ProductForViewModel> getSearchResult (value){
    _searchResult =[];
    print(value);
    emit(GetFilterResultLoading());
    //TODO: GET SEARCH RESULT IN SERVER
    List<ProductForViewModel> resultList = [
      //TODO: COVERT TO RESULT

    ];
    if(resultList.isNotEmpty){
      _searchResult = resultList ;
      emit(GetFilterResultSuccess());
    }
    return _searchResult ;
  }





}
