import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/style/color_manger.dart';

class FavoriteIcon extends StatefulWidget {
  final ProductModel productModel;
  const FavoriteIcon(this.productModel, {Key? key}) : super(key: key);
  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (widget.productModel.isFavorite) {
              //TODO: put change isFavorite
            }
          });
        },
        child: Icon(
          !widget.productModel.isFavorite
              ? Icons.favorite_border
              : Icons.favorite,
          color: ColorManger.red,
        ),
      ),
    );
  }
}

