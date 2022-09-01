import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/states.dart';
import 'package:soom/style/color_manger.dart';

class FavoriteIcon extends StatefulWidget {
  final ProductForViewModel productModel;
  const FavoriteIcon(this.productModel, {Key? key}) : super(key: key);
  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<FavoriteCubit , FavoriteStates>(
      listener: (context, state) => FavoriteCubit(),
      builder: (context, state) {
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
            child: InkWell(
              onTap: ()async{
                if(isFavorite(context , widget.productModel)){

                  await FavoriteCubit.get(context).deleteFavorite(widget.productModel, context);
                  setState(() {

                  });
                }else{
                  await FavoriteCubit.get(context).addTOFavorite(widget.productModel, context);
                  setState(() {

                  });
                }
              },
              child: Icon(
                isFavorite( context , widget.productModel  )
                    ? Icons.favorite
                    : Icons.favorite_border  ,
                color: ColorManger.red,
              ),
            ),
          ),
        );
      },
    );
  }
}

bool isFavorite (context , ProductForViewModel productForViewModel ){
  for(var item in FavoriteCubit.get(context).favoritesItemsResponse ){
    if(productForViewModel.productModel.product!.name == item["productName"]){
      return true ;
    }
  }
  return false ;
}