
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/states.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/no_favorite_screen.dart';
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<FavoriteCubit , FavoriteStates >(
        listener: (context, state) => FavoriteCubit() ,
        builder:(context , state ){
          var cubit = FavoriteCubit.get(context);

          return FutureBuilder(
              future:cubit.getFavorite(context).then((value){setState(() {});}),
              builder: (context , snapShot){
                if( cubit.isLoading ){
                  return const Center(child:  CircularProgressIndicator());
                }
                if(snapShot.hasError){
                  return const Text("حدث خطأ ما .. حاول لاحقا ! ");
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RefreshIndicator(
                    onRefresh:() => cubit.getFavorite(context , isRefresh: true),
                    child: cubit.isEmpty? const NoFavoriteScreen() : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: cubit.favoritesItemsForView.length,
                      itemBuilder: (context , index )=> ProductItem(
                        isFullWidth: false,
                        productForViewModel: cubit.favoritesItemsForView.reversed.toList()[index],
                      ),
                      separatorBuilder: (context , index )=> const SizedBox(height: 16,),
                    ),
                  ),
                );

              }
          );
        } ,

    );

  }
}




