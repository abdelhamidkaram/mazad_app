import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/categories_list_view.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/search_an_filter.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/slider_image.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/title_category.dart';
import '../../../components/product_item.dart';

class HomeScreen extends StatefulWidget {
  final HomeCubit homeCubit;

  const HomeScreen({Key? key, required this.homeCubit})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState()  {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
          onRefresh: () => widget.homeCubit.getProducts(context),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchAndFilter(homeCubit: widget.homeCubit),
                    const SizedBox(
                      height: 10,
                    ),
                    //TODO: CATEGORY  LIST
                    CategoriesListView(
                        homeCubit: widget.homeCubit),
                    SlideImage(homeCubit: widget.homeCubit),
                    TitleCategory(title: "آخر المزادات ", onPressed: () {}),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 255,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ProductItem(
                          productModel: widget.homeCubit.products[index],
                          isFullWidth: false,
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                        itemCount: widget.homeCubit.products.length,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TitleCategory(title: "العقارات  ", onPressed: () {}),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 255,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ProductItem(
                          productModel: widget.homeCubit.products[index],
                          isFullWidth: false,
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                        itemCount: widget.homeCubit.products.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}
