import 'package:soom/models/product_model.dart';

class FavoriteModel {
  ProductFavorite? productFavorite;
  String? userName;
  String? productName;
  Product? product;

  FavoriteModel(
      {this.productFavorite, this.userName, this.productName, this.product});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    productFavorite = json['productFavorite'] != null
        ? ProductFavorite.fromJson(json['productFavorite'])
        : null;
    userName = json['userName'];
    productName = json['productName'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productFavorite != null) {
      data['productFavorite'] = productFavorite!.toJson();
    }
    data['userName'] = userName;
    data['productName'] = productName;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class ProductFavorite {
  int? userId;
  int? productId;
  int? id;

  ProductFavorite({this.userId, this.productId, this.id});

  ProductFavorite.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    productId = json['productId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['productId'] = productId;
    data['id'] = id;
    return data;
  }
}

