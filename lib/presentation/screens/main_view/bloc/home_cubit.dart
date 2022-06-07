import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/style/text_style.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
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
                  onPressed: () => Navigator.of(context).pop(true),
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
  List<ProductModel> _filterResult =[];
  List<ProductModel> getFilterResult (){
    emit(GetFilterResultLoading());
    //TODO: GET FILTER RESULT IN SERVER
    List<ProductModel> resultList = [
      ProductModel(
          false,
          "assets/pro1.png",
          "view",
          "ساعة روليكس  ",
          "123456875",
          "9565",
          "2022-05-22",
          "9845",
          "63215",
          "85",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
      ProductModel(
          true,
          "assets/pro2.png",
          "view",
          "مجوهرات أثرية ",
          "123456875",
          "9565",
          "2022-05-21",
          "232",
          "520",
          "23",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
      ProductModel(
          true,
          "assets/pro1.png",
          "view",
          "عنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويل ",
          "123456875",
          "9565",
          "2022-05-22",
          "800",
          "1500",
          "20",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
    ];
    if(resultList.isNotEmpty){
      _filterResult = resultList ;
      emit(GetFilterResultSuccess());
    }
    return _filterResult ;
  }


// ------------------  search Result --------------//

  List<ProductModel> _searchResult =[];
  List<ProductModel> getSearchResult (value){
    _searchResult =[];
    print(value);
    emit(GetFilterResultLoading());
    //TODO: GET SEARCH RESULT IN SERVER
    List<ProductModel> resultList = [
      //TODO: COVERT TO RESULT
      ProductModel(
          false,
          "assets/pro1.png",
          "view",
          "ساعة روليكس  ",
          "123456875",
          "9565",
          "2022-05-22",
          "9845",
          "63215",
          "85",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
      ProductModel(
          true,
          "assets/pro2.png",
          "view",
          "مجوهرات أثرية ",
          "123456875",
          "9565",
          "2022-05-21",
          "232",
          "520",
          "23",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
      ProductModel(
          true,
          "assets/pro1.png",
          "view",
          "عنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويلعنوان طويل ",
          "123456875",
          "9565",
          "2022-05-22",
          "800",
          "1500",
          "20",
          "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما."),
    ];
    if(resultList.isNotEmpty){
      _searchResult = resultList ;
      emit(GetFilterResultSuccess());
    }
    return _searchResult ;
  }





}
