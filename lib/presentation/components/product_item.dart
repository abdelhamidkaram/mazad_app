import 'package:animations/animations.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/timer.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/product/product_screen.dart';
import 'package:soom/presentation/screens/product/widget/product_price_box.dart';
import 'package:soom/style/text_style.dart';
import '../../style/color_manger.dart';

class ProductItem extends StatefulWidget {
  final bool isFullWidth;
  final bool? isTabsScreen;
  final bool? isMyAuction;
  final bool? isFavoriteScreen;
  final ProductForViewModel productForViewModel;

  const ProductItem({
    Key? key,
    this.isTabsScreen = false,
    this.isMyAuction = false,
    this.isFavoriteScreen = false,
    required this.isFullWidth,
    required this.productForViewModel,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) => HomeCubit(),
        builder: (context, sate) {
          Widget goToPriceBox() {
            if (widget.isTabsScreen != null && widget.isTabsScreen == true) {
              return LastBidsTabs(productModel: widget.productForViewModel);
            } else
            if (widget.isMyAuction != null && widget.isMyAuction == true) {
              return LastBidsTabsAndPrice(
                  productModel: widget.productForViewModel);
            } else {
              return LastBidsPrice(productModel: widget.productForViewModel);
            }
          }
          var year = int.parse(
              widget.productForViewModel.productModel.product!.endDate!
                  .substring(0, 4));
          var month = int.parse(
              widget.productForViewModel.productModel.product!.endDate!
                  .substring(5, 7));
          var day = int.parse(
              widget.productForViewModel.productModel.product!.endDate!
                  .substring(8, 10));
          Duration difference = DateTime.now().difference(
              DateTime.utc(year, month, day));

          return OpenContainer(
              transitionDuration: const Duration(milliseconds: 800),
              openBuilder: (context, action) =>
                  ProductScreen(
                    lastPrice: widget.productForViewModel.lasPrice!, //TODO: LAST PRICE
                    productModel: widget.productForViewModel,
                    isMyAuction: widget.isMyAuction ?? false,
                  ),
              closedBuilder: (context, action) =>
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: (difference.inSeconds > 0) ? Banner(
                      color: ColorManger.red,
                      message: "منتهي",
                      textStyle: AppTextStyles.smallWhite,
                      location: BannerLocation.bottomStart,
                      child: _buildContainer(goToPriceBox),
                    ) : _buildContainer(goToPriceBox),
                  ));
        });



  }
  Container _buildContainer(Widget Function()
  goToPriceBox
      ) {
    return Container(
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
                    child:ExtendedImage.network(
                      widget.productForViewModel.thumbnail,
                      // width: ScreenUtil.instance.setWidth(400),
                      // height: ScreenUtil.instance.setWidth(400),
                      // fit: BoxFit.fill,
                      cache: true,
                      //border: Border.all(color: Colors.red, width: 1.0),
                      // shape: boxShape,
                      // borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState == LoadState.loading) {
                            return const LinearProgressIndicator(
                              color: ColorManger.primaryLight_10,
                              backgroundColor: ColorManger.white,
                              minHeight: double.infinity,
                            );
                          }
                          else if (state.extendedImageLoadState == LoadState.failed) {
                            return Image.asset("assets/noimg.png");
                          }

                        }
                    )

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
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                            color:
                            ColorManger.lightGrey.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(4)),
                        child: TimerDownDate(
                            time: widget.productForViewModel.time!),
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
                  widget.productForViewModel.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleProductBlue,
                ),
              ),
            ),
          ),
          Container(
            width: (widget.isTabsScreen != null &&
                widget.isTabsScreen == true ||
                (widget.isMyAuction != null &&
                    widget.isMyAuction == true))
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
    );
  }}

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
          "أخر مزايدة",
          style: AppTextStyles.titlePriceBlack,
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SizedBox(
          width: 82,
          child: PriceAndCurrencyGreen(
            lastPrice: widget.productModel.lasPrice! ,
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
            "اخر مزايدة",
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
              lastPrice: widget.productModel.lasPrice!, //TODO: GET MY BID
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

  const LastBidsTabsAndPrice({Key? key, required this.productModel})
      : super(key: key);

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
              width: 120,
              child: PriceAndCurrencyGreen(
              productModel: widget.productModel,
                lastPrice:widget.productModel.lasPrice!,//TODO : GET LAST PRICE
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
