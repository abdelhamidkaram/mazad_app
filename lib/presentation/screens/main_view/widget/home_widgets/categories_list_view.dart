import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/category_item_build.dart';

class CategoriesListView extends StatelessWidget {
  final HomeCubit homeCubit ;
  const CategoriesListView({Key? key, required this.homeCubit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => CategoryItemBuild(isFilter: false, categoryModel: homeCubit.categories[index], homeCubit:homeCubit,),
          separatorBuilder: (context, index) => const SizedBox(
                width: 20,
              ),
          itemCount: homeCubit.categories.length,
      ),
    );
  }
}
