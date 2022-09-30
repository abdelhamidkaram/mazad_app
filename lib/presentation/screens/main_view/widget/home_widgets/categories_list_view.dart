import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/category_item_build.dart';

import '../../bloc/home_states.dart';

class CategoriesListView extends StatelessWidget {
  final HomeCubit homeCubit ;
  const CategoriesListView({Key? key, required this.homeCubit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit , HomeStates>(
      listenWhen: (previous, current) {
        if(current == GetCategoriesBlockSuccess()){
          return true ;
        }else{
          return false ;
        }
      } ,
      listener:(context , state )=>HomeCubit(),
      builder: (context , state ){
        return SizedBox(
          height: 80,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => CategoryItemBuild(isFilter: false, categoryModel: HomeCubit.get(context).categories[index], homeCubit:homeCubit,),
            separatorBuilder: (context, index) => const SizedBox(
              width: 20,
            ),
            itemCount: homeCubit.categories.length,
          ),
        );
      },
    );

  }
}
