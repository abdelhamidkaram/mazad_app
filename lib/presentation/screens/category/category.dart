import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/favorite_icon_widget.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/category/bloc/categories_cubit.dart';
import 'package:soom/presentation/screens/category/bloc/categories_states.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit()
        ..getProductWithCategoryName(
          widget.category.title!,
          context,
        ),
      child: BlocConsumer<CategoriesCubit, CategoriesStates>(
        listener: (context, state) => CategoriesCubit(),
        builder: (context, state) {
          var cubit = CategoriesCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorManger.white,
              appBar: AppBars.appBarGeneral(
                  context, HomeCubit.get(context), widget.category.title!),
              body: RefreshIndicator(
                onRefresh: () => cubit.getProductWithCategoryName(
                    widget.category.title!, context),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child: (state is GetCategoryProductsLoading)
                        ?
                        const Center(child: CircularProgressIndicator(),)
                    :
                    Center(child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: bodyWidget(state, cubit)) ,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    
  }
  Widget? bodyWidget(CategoriesStates state , CategoriesCubit cubit){
    if(state is GetCategoryProductsSuccess ){
      if(cubit.products.isNotEmpty){
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => ProductItem(
            isFullWidth: true,
            productForViewModel: cubit.products[index],

          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 20,
          ),
          itemCount: cubit.products.length,
        ) ;
      }else{
        return const Center(child: Text("لايوجد منتجات لهذا التصنيف بعد ! "),);
      }
    }else{
     return null ; 
    }
}
}
