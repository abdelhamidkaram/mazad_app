import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/bloc/categories_states.dart';
import 'package:soom/repository/repository.dart';

class CategoriesCubit extends Cubit<CategoriesStates> {
  CategoriesCubit() : super(InitCategoriesState());

  static CategoriesCubit get(context)=> BlocProvider.of(context);
  final Repository _repository = Repository();
  List<ProductForViewModel> products = [];
    Future getProductWithCategoryName(String categoryName , context )  async {
      emit(GetCategoryProductsLoading());
      (
      await _repository.getProductsBaseOnCategoryName(categoryName: categoryName)
      ).fold((error){
        AppToasts.toastError("خطأ في جلب المعلومات حتول لا حقا !", context);
        emit(GetCategoryProductsError());
      }, (productsList) {
        //TODO: GET THE favORiTe  and last price
        products = productsList.map((product)=> ProductForViewModel(false, "2000", product, "200", "12") ).toList();
       emit(GetCategoryProductsSuccess());
      });
    }
}