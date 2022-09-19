import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/timer.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ProductPriceBox extends StatefulWidget {
  final ProductForViewModel productModel ;
  final String lastPrice ;
  const ProductPriceBox({Key? key, required this.productModel, required this.lastPrice}) : super(key: key);

  @override
  State<ProductPriceBox> createState() => _ProductPriceBoxState();
}

class _ProductPriceBoxState extends State<ProductPriceBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorManger.lightGrey),
      ),
      height: 85,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("الوقت" , style: AppTextStyles.mediumBlack,),
                ),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 8),
                  height: 30,
                  color: ColorManger.primaryLight_10,
                  child: TimerDownDate(time: widget.productModel.time!,),
                ),
              ],
            ),
            Padding(
                padding: const  EdgeInsets.symmetric(vertical: 8.0 ,horizontal: 5.0),
                child:  Container(
                  width: 1,
                  color: ColorManger.lightGrey,
                )

            )  ,
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("سعر الشراء" , style: AppTextStyles.mediumBlack,),
                ),
               PriceAndCurrencyRed(productModel: widget.productModel),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0 ,horizontal: 5.0),
              child:   Container(
                width: 1,
                color: ColorManger.lightGrey,
              ) ,
            )  ,
            Column(
              children: [
                const     Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("آخر مزايدة" , style: AppTextStyles.mediumBlack,),
                ),
                PriceAndCurrencyGreen(
                  productModel: widget.productModel,
                  lastPrice: widget.lastPrice,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}



class PriceAndCurrencyGreen extends StatefulWidget {
  final ProductForViewModel  productModel ;
  final String  lastPrice ;

  const PriceAndCurrencyGreen({Key? key, required this.productModel, required this.lastPrice}) : super(key: key);

  @override
  State<PriceAndCurrencyGreen> createState() => _PriceAndCurrencyGreenState();
}

class _PriceAndCurrencyGreenState extends State<PriceAndCurrencyGreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("KW", style: AppTextStyles.currencyGreen,),
        Text(widget.lastPrice.length > 6 ? widget.lastPrice.substring(0,6)  : widget.lastPrice , style: AppTextStyles.titleGreen,),
      ],
    );
  }
}


class PriceAndCurrencyRed extends StatefulWidget {
  final ProductForViewModel  productModel ;
  const PriceAndCurrencyRed({Key? key, required this.productModel}) : super(key: key);

  @override
  State<PriceAndCurrencyRed> createState() => _PriceAndCurrencyRedState();
}

class _PriceAndCurrencyRedState extends State<PriceAndCurrencyRed> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("KW", style: AppTextStyles.currencyRed,),
        Text(widget.productModel.targetPrice.toString().substring(0 , widget.productModel.initialPrice.toString().length >=6 ?  6 : widget.productModel.initialPrice.toString().length), style: AppTextStyles.titleRed,),
      ],
    );
  }
}
