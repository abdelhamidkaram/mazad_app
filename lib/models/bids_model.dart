class BidsModel {
  double? price;
  int? userId;
  int? productId;
  String? productName;
  int? id;

  BidsModel(
      {this.price, this.userId, this.productId, this.productName, this.id});

  BidsModel.fromJson(Map<String, dynamic> json) {
    price = json['productAuaction']['price'];
    userId = json['productAuaction']['userId'];
    productId = json['productAuaction']['productId'];
    productName = json['productName'];
    id = json['productAuaction']['id'];
  }

}