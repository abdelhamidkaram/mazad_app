import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/states.dart';
import 'package:soom/style/color_manger.dart';

class FavoriteIcon extends StatefulWidget {
  ProductForViewModel? productModel;

  FavoriteIcon(this.productModel, {Key? key}) : super(key: key);

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteStates>(
      listener: (context, state) => FavoriteCubit(),
      builder: (context, state) {
        return SizedBox(
          height: 30,
          child: InkWell(
            onTap: () async {
              FavoriteCubit.get(context)
                  .changeFavoriteButton(widget.productModel!, context).then((value){
              });
            },
            child: Icon(
              widget.productModel!.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: ColorManger.red,
            ),
          ),
        );
      },
    );
  }
}
