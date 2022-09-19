class BidsModel {
  double? price;
  int? userId;
  int? productId;
  String? productName;
  int? id;

  BidsModel(
      {this.price, this.userId, this.productId, this.productName, this.id});

  BidsModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    userId = json['userId'];
    productId = json['productId'];
    productName = json['productName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['userId'] = userId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['id'] = id;
    return data;
  }
}