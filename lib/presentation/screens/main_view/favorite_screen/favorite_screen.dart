import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isFinish = false ;
  List<ProductForViewModel>  items = FavoriteCubit().favoritesItems ;
  @override
  void initState() {
    if(FavoriteCubit.get(context).isFirstBuild){
      items = [];
      FavoriteCubit.get(context).getFavoriteForView(context).then((value){
        setState(() {
          isFinish = true ;
          FavoriteCubit.get(context).isFirstBuild = false ; 
          items =  value ;
        });
      });
    }else{
      isFinish = true ;
      setState(() {
        items = FavoriteCubit.get(context).favoritesItems ;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
         return isFinish ? RefreshIndicator(
           onRefresh: () => FavoriteCubit.get(context).getFavoriteForView(context).then((value){
             setState(() {
               items = value ;
             });
           }),
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: ListView.separated(
               itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                 return ProductItem(
                   isFullWidth: true,
                   productForViewModel: items[index] ,
                   isFavoriteScreen: true,

                 );
              },
              separatorBuilder: (BuildContext context, int index) {
                 return const SizedBox(height: 16,);
              },
        ),
           ),
         ) : const Center(child: CircularProgressIndicator(),);
  }
}
