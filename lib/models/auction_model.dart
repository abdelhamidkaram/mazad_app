
import 'package:soom/models/product_model.dart';
import 'package:soom/models/profile_detalis_success.dart';

import '../main.dart';

class AuctionForViewModel{
  final ProductModel productModel ;
  final UserModel userModel ;
  final int price ;
  String ? userName  ;
  String ? productName ;
  AuctionModel? auctionModel ;
  AuctionForViewModel({required this.price, required this.productModel, required this.userModel}){
    auctionModel = AuctionModel(price: price  , productId: productModel.product!.id!.toInt() , userId: int.parse(id));
    productName = productModel.product!.name ;
    userName = userModel.userName ;
  }
}
class AuctionModel {
  final int price ;
  final int userId;
  final int productId ;
  AuctionModel({required this.price, required this.userId, required this.productId});
}