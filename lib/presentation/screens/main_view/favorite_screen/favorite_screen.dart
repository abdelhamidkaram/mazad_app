import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/states.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  List<ProductForViewModel>  items = FavoriteCubit().favoritesItems ;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FavoriteCubit , FavoriteStates>(
          builder: (context, state){
            if(FavoriteCubit.get(context).favoritesItems.isEmpty && FavoriteCubit.get(context).isFirstBuild){
              FavoriteCubit.get(context).getFavoriteForView(context);
              FavoriteCubit.get(context).isFinish = true ;
              FavoriteCubit.get(context).isFirstBuild = true ;
            }
            if(state is GetFavoriteForViewLoading && FavoriteCubit.get(context).favoritesItems.isEmpty ){
              return const  Center(child:  CircularProgressIndicator(),);
            }
           return FavoriteCubit.get(context).isFinish
               ? RefreshIndicator(
             onRefresh: () => FavoriteCubit.get(context).getFavoriteForView(context).then((value){
               setState(() {

               });
             }),
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: ListView.separated(
                 physics: const BouncingScrollPhysics(),
                 itemCount: FavoriteCubit.get(context).favoritesItems.length,
                 itemBuilder: (BuildContext context, int index) {
                   return ProductItem(
                     isFullWidth: true,
                     productForViewModel: FavoriteCubit.get(context).favoritesItems[index] ,
                     isFavoriteScreen: true,
                   );
                 },
                 separatorBuilder: (BuildContext context, int index) {
                   return const SizedBox(height: 16,);
                 },
               ),
             ),
           )
               : const Center(child: CircularProgressIndicator(),);
          },

       );
  }
}
