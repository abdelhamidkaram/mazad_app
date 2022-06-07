import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/category_item_build.dart';

class CategoriesListView extends StatelessWidget {
  final CategoryModel categoryModel ;
  final HomeCubit homeCubit ;
  const CategoriesListView({Key? key,required this.categoryModel, required this.homeCubit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => CategoryItemBuild(isFilter: false, categoryModel: categoryModel, homeCubit:homeCubit,),
          separatorBuilder: (context, index) => const SizedBox(
                width: 20,
              ),
          itemCount: 10),
    );
  }
}
