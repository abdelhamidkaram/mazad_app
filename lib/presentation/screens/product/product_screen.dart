import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/product/add_bid.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_cubit.dart';
import 'package:soom/presentation/screens/product/widget/image_product.dart';
import 'package:soom/presentation/screens/product/widget/product_price_box.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

import '../main_view/favorite_screen/bloc/cubit.dart';

class ProductScreen extends StatefulWidget {
  final ProductForViewModel productModel;
  final bool isMyAuction;
  final String lastPrice ;

  const ProductScreen(
      {Key? key, required this.productModel, this.isMyAuction = false, required this.lastPrice})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    if(FavoriteCubit.get(context).favoritesItemsResponse.isNotEmpty){
      for(var fav in FavoriteCubit.get(context).favoritesItemsResponse){
        if(fav.product!.id  == widget.productModel.productModel.product!.id  ){
          setState(() {
            widget.productModel.isFavorite = true ;
          });
          break ;
        }
      }
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          return await Future.value(true);
        },
        child: Scaffold(
          backgroundColor: ColorManger.white,
          appBar: AppBars.appBarGeneral(
            context,
            HomeCubit.get(context),
            _appbarTitle(),
          ),
          bottomNavigationBar: !widget.isMyAuction
              ? BlocProvider<BidCubit>.value(
                  value: BidCubit.get(context),
                  child: AppButtons.toastButtonBlue(
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddBid(productModel: widget.productModel),
                          ));
                      BidCubit.get(context).controller.text =
                          widget.productModel.lasPrice!;
                    },
                    "اضافة مزايدة ",
                    true,
                    icon: SvgPicture.asset(
                      "assets/auction.svg",
                      color: ColorManger.white,
                    ),
                  ),
                )
              : null,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
              child: Column(
                children: [
                  ProductImageBox(
                    productModel: widget.productModel,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Text(
                          widget.productModel.title!,
                          style: AppTextStyles.titleBlue_24,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      const Text(
                        "الرقم التسلسلي :  ",
                        style: AppTextStyles.smallGrey_12,
                      ),
                      Text(
                        "${widget.productModel.tasalsol} ",
                        style: AppTextStyles.smallGreyBold_12,
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ProductPriceBox(productModel: widget.productModel , lastPrice:widget.lastPrice ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/auction.svg",
                        color: ColorManger.primary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "إجمالي المزادات : ",
                        style: AppTextStyles.smallBlack,
                      ),
                      Text(
                        "${widget.productModel.productModel.product?.count ?? 0}" ,
                        style: AppTextStyles.smallBlueBold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  widget.isMyAuction ? _myProductDetails() : _productDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productDetails() {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "تفاصيل المنتج ",
              style: AppTextStyles.titleSmallBlack,
            ),
            Spacer(),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          widget.productModel.details!,
          style: AppTextStyles.mediumGrey,
        ),
      ],
    );
  }

  //TODO: GET BIDS FOR MY AUCTION FORM SERVER
  Widget _myProductDetails() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "الأشخاص المزايدين ",
                style: AppTextStyles.titleSmallBlack,
              ),
              Spacer(),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManger.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle ,
                          border:Border.all(color: ColorManger.lightGrey),
                          image: DecorationImage(
                              image: Image.network("https://www.kau.edu.sa/Files/0016617/Galleries/6608/51617_P1016195%20copy.jpg").image ,
                          ) ,
                        ),

                      ),
                      const SizedBox(width: 8,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           const Text("عماد خليل  " , style: AppTextStyles.mediumBlackBold_17,) ,
                          const  SizedBox(height: 8,),
                            Wrap(
                                children:  const [
                                   Text("سعر المزايدة : " , style: AppTextStyles.smallBlack,),
                                   Text("1200KW" , style:  AppTextStyles.mediumGreen,)
                                ],
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          //TODO : GET TRUE BID
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: ColorManger.green ,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/auction.svg" , color: ColorManger.white,),
                               const Text(" بيع "  , style: AppTextStyles.mediumWhite,),
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _appbarTitle() {
    return widget.productModel.title!.length > 30
        ? "${widget.productModel.title!.substring(0, 30)} ..."
        : widget.productModel.title!;
  }
}
