import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/favorite_icon.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ProductImageBox extends StatefulWidget {
  final ProductModel productModel;

  const ProductImageBox({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductImageBox> createState() => _ProductImageBoxState();
}

class _ProductImageBoxState extends State<ProductImageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorManger.lightGrey),
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Center(
              child: Image.asset(widget.productModel.img ),
            ),
            Row(
              children:  [
                FavoriteIcon(widget.productModel),
               const Spacer(),
               const Icon(Icons.visibility , color: ColorManger.primaryLight,),
              const  SizedBox(width: 5,),
               const Text("20K" , style: AppTextStyles.smallBlueBold,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
