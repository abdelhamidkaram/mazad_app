import 'package:soom/models/favorite_model.dart';
import 'package:soom/models/product_model.dart';

extension ConvertFavoriteModelToProductViewModel on FavoriteModel {

        ProductForViewModel toProductViewModel(){
          return ProductForViewModel("0", ProductModel(product: product), isFavorite: true );
        }
}