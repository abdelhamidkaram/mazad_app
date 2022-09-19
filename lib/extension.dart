import 'package:soom/models/favorite_model.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';

extension ConvertFavoriteModelToProductViewModel on FavoriteModel {

        ProductForViewModel toProductViewModel(context){
          for(var bid in HomeCubit.get(context).allLastBids){
            if(bid.productId == product!.id){
              return ProductForViewModel("0",
                  ProductModel(product: product),
                  isFavorite: true ,
                  lasPrice: bid.price!.toInt().toString()
              );
            }
          }
          return ProductForViewModel("0", ProductModel(product: product), isFavorite: true  );
        }

}