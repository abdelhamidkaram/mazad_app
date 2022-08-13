
import 'package:soom/presentation/screens/category/category_model.dart';

import '../../../../models/product_model.dart';

class CategoryBlockModel {
  String categoryName   ;
  CategoryModel categoryModel ;
  List<ProductForViewModel> products ;
  CategoryBlockModel(this.categoryName , this.products , this.categoryModel );
}