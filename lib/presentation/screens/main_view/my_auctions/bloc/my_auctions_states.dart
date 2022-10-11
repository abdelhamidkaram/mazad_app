import 'package:soom/models/product_model.dart';

class MyAuctionsStates{}
class InitAuctionState extends MyAuctionsStates{}

class GetMyBidLoading extends MyAuctionsStates {}
class GetMyBidSuccess extends MyAuctionsStates {}
class GetMyBidError extends MyAuctionsStates {}

class GetMyBidForViewLoading extends MyAuctionsStates {}
class GetMyBidForViewSuccess extends MyAuctionsStates {}
class GetMyBidForViewError extends MyAuctionsStates {}

class GetMyProductForViewLoading extends MyAuctionsStates {}
class GetMyProductForViewSuccess extends MyAuctionsStates {}
class GetMyProductForViewError extends MyAuctionsStates {}

class GetProductShowLoading extends MyAuctionsStates {}
class GetProductShowSuccess extends MyAuctionsStates {
  late  ProductForViewModel productForViewModel ;
  GetProductShowSuccess(this.productForViewModel);

}
class GetProductShowError extends MyAuctionsStates {}

class ClearDataSuccess extends MyAuctionsStates {}