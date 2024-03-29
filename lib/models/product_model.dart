import 'package:soom/constants/app_string.dart';

class ProductForViewModel{
   bool isFavorite = false ;
  final String view ;
   String?  lasPrice ;
   String? auctionCounter ;
  final ProductModel productModel ;
   String thumbnail = "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png" ;
   List? photos ;
   int? categoryId ;
   String? title ;
   String? tasalsol ;
   String? pand ;
   String? time ;
   double? initialPrice ;
   double? minPrice ;
   double? targetPrice ;
   String? details ;
ProductForViewModel(
    this.view,
    this.productModel,
   {
     this.isFavorite = false  ,
     this.lasPrice ,
   }
    ){
  title = productModel.product?.name ?? "غير معروف ";
  photos = productModel.product?.photo ?? ["https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"];
  tasalsol = productModel.product?.id.toString() ?? 0.toString() ;
  pand = productModel.product?.id.toString() ?? 0.toString() ;
  time = productModel.product?.endDate ?? DateTime.now().toString();
  initialPrice = productModel.product?.intitalPrice ?? 0.0 ;
  minPrice = productModel.product?.minPrice ?? 0.0 ;
  targetPrice = productModel.product?.targetPrice ?? 0.0 ;
  details = productModel.product?.descrption ?? "لا يوجد وصف " ;
  categoryId = productModel.product?.categoryId ?? 0 ;
  if(photos!.isNotEmpty && thumbnail != photos![0]){
    thumbnail = "${AppString.getImageBaseUrl}${photos![0]}";
  }
  if(productModel.product!.count != null ){
    auctionCounter = productModel.product!.count.toString() ;
  }else {
    auctionCounter = 0.toString() ;
  }
  lasPrice ??= minPrice!.toInt().toString();
}

}


class ProductModel {
  Product? product;
  String? categoryName;
  ProductModel({this.product, this.categoryName});
  ProductModel.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['categoryName'] = categoryName;
    return data;
  }
}

class Product {
  String? name;
  String? descrption ;
  double? intitalPrice ;
  double? minPrice;
  String? endDate;
  int? status;
  int? count;
  double? targetPrice;
  int? categoryId;
  List? photo;
  int? id;

  Product(
      {this.name,
        this.descrption,
        this.intitalPrice,
        this.minPrice,
        this.endDate,
        this.status,
        this.targetPrice,
        this.categoryId,
        this.photo,
        this.count,
        this.id});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    descrption = json['descrption'];
    intitalPrice = json['intitalPrice'];
    minPrice = json['minPrice'];
    endDate = json['endDate'];
    status = json['status'];
    targetPrice = json['targetPrice'];
    categoryId = json['categoryId'];
    photo = json['photo'];
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['descrption'] = descrption;
    data['intitalPrice'] = intitalPrice;
    data['minPrice'] = minPrice;
    data['endDate'] = endDate;
    data['status'] = status;
    data['targetPrice'] = targetPrice;
    data['categoryId'] = categoryId;
    data['photo'] = photo;
    data['id'] = id;
    return data;
  }
}