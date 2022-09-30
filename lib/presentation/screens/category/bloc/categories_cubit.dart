import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/bloc/categories_states.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/repository/repository.dart';

class CategoriesCubit extends Cubit<CategoriesStates> {
  CategoriesCubit() : super(InitCategoriesState());

  static CategoriesCubit get(context)=> BlocProvider.of(context);
  final Repository _repository = Repository();
  List<ProductForViewModel> products = [];
    Future<List<ProductForViewModel>> getProductWithCategoryName(String categoryName , context )  async {
      emit(GetCategoryProductsLoading());
      (
      await _repository.getProductsBaseOnCategoryName(categoryName: categoryName , maxResult: 1000)
      ).fold((error){
        emit(GetCategoryProductsError());
      }, (productsList) {
        products = productsList.map((e) {
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
       emit(GetCategoryProductsSuccess());
      });
      return products ;
    }

}