import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/timer.dart';
import 'package:soom/presentation/screens/product/product_screen.dart';
import 'package:soom/presentation/screens/product/widget/product_price_box.dart';
import 'package:soom/style/text_style.dart';
import '../../style/color_manger.dart';

class ProductItem extends StatefulWidget {
  final bool isFullWidth;
  final bool? isTabsScreen;
  final bool? isMyAuction;
  final bool? isFavoriteScreen;
  final ProductForViewModel productModel;

  const ProductItem(
      {Key? key,
      this.isTabsScreen = false,
      this.isMyAuction = false,
      this.isFavoriteScreen = false,
      required this.isFullWidth,
      required this.productModel})
      : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    Widget goToPriceBox() {
      if (widget.isTabsScreen != null && widget.isTabsScreen == true) {
        return LastBidsTabs(productModel: widget.productModel);
      } else if (widget.isMyAuction != null && widget.isMyAuction == true) {
        return LastBidsTabsAndPrice(productModel: widget.productModel);
      } else {
        return LastBidsPrice(productModel: widget.productModel);
      }
    }

    return OpenContainer(
        transitionDuration: const Duration(milliseconds: 800),
        openBuilder: (context, action) => ProductScreen(
              productModel: widget.productModel,
              isMyAuction: widget.isMyAuction ?? false ,
            ),
        closedBuilder: (context, action) => Container(
              width: !widget.isFullWidth ? 221 : 500,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorManger.lightGrey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Image.network(
                              widget.productModel.thumbnail,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          right: 5,
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                             widget.isFavoriteScreen! ? IconButton(onPressed: (){
                                //TODO: DELETE FAVORITE
                              }, icon:const Icon(Icons.favorite , color: ColorManger.red,)) : const SizedBox(),
                              const Spacer(),
                              Container(
                                height: 30,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: ColorManger.lightGrey.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(4)),
                                child: TimerDownDate(time: widget.productModel.time!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          widget.productModel.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleProductBlue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: (widget.isTabsScreen != null &&
                            widget.isTabsScreen == true || (widget.isMyAuction != null &&
                        widget.isMyAuction == true ))
                        ? double.infinity
                        : 180,
                    height: 35,
                    margin: const EdgeInsets.all(10),
                    color: ColorManger.green_10,
                    child: goToPriceBox(),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ));
  }
}

class LastBidsPrice extends StatefulWidget {
  final ProductForViewModel productModel;

  const LastBidsPrice({Key? key, required this.productModel}) : super(key: key);

  @override
  State<LastBidsPrice> createState() => _LastBidsPriceState();
}

class _LastBidsPriceState extends State<LastBidsPrice> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Text(
          "آخر مزايدة",
          style: AppTextStyles.titlePriceBlack,
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SizedBox(
          width: 80,
          child: PriceAndCurrencyGreen(
            productModel: widget.productModel,
          ),
        ),
      ),
    ]);
  }
}

class LastBidsTabs extends StatefulWidget {
  final ProductForViewModel productModel;

  const LastBidsTabs({Key? key, required this.productModel}) : super(key: key);

  @override
  State<LastBidsTabs> createState() => _LastBidsTabsState();
}

class _LastBidsTabsState extends State<LastBidsTabs> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            " آخر مزايدة",
            style: AppTextStyles.titlePriceBlack,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: SizedBox(
            width: 80,
            child: PriceAndCurrencyRed(
              productModel: widget.productModel,
            ),
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            "مزايدتي",
            style: AppTextStyles.titlePriceBlack,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: SizedBox(
            width: 90,
            child: PriceAndCurrencyGreen(
              productModel: widget.productModel,
            ),
          ),
        ),
      ],
    );
  }
}




class LastBidsTabsAndPrice extends StatefulWidget {
  final ProductForViewModel productModel;

  const LastBidsTabsAndPrice({Key? key, required this.productModel}) : super(key: key);

  @override
  State<LastBidsTabsAndPrice> createState() => _LastBidsTabsAndPriceState();
}

class _LastBidsTabsAndPriceState extends State<LastBidsTabsAndPrice> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              " آخر مزايدة",
              style: AppTextStyles.titlePriceBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              width: 80,
              child: PriceAndCurrencyGreen(
                productModel: widget.productModel,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              "سعر الشراء",
              style: AppTextStyles.titlePriceBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              width: 90,
              child: PriceAndCurrencyRed(
                productModel: widget.productModel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

