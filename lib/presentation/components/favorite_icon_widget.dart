import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import '../../style/color_manger.dart';

class FavoriteIconWidget extends StatefulWidget {
  final ProductForViewModel productForViewModel;
  final VoidCallback onPressedForDelete ;
  final VoidCallback onPressedForAdd ;

  const FavoriteIconWidget({Key? key, required this.productForViewModel,required this.onPressedForDelete,required this.onPressedForAdd})
      : super(key: key);

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  Widget build(BuildContext context) {
          return widget.productForViewModel.isFavorite
              ? IconButton(
                  onPressed: widget.onPressedForDelete,
                  icon: const Icon(
                    Icons.favorite,
                    color: ColorManger.red,
                  ),
                )
              : IconButton(
                  onPressed: widget.onPressedForAdd,
                  icon: const Icon(
                    Icons.favorite_border,
                    color: ColorManger.grey,
                  ),
                );

  }
}
