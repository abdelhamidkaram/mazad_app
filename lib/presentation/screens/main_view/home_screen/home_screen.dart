import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/category/category.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/home_screen/all_products_view.dart';
import 'package:soom/presentation/screens/main_view/home_screen/categoreis_block_model.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/categories_list_view.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/search_an_filter.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/slider_image.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/title_category.dart';
import '../../../components/product_item.dart';

class HomeScreen extends StatefulWidget {
  final HomeCubit homeCubit;
  final HomeStates state ;

  const HomeScreen({Key? key, required this.homeCubit, required this.state}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>HomeCubit.get(context).getProducts(context , true).then((value){
        setState(() {

        });
      }),
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
              CategoriesListView(homeCubit: widget.homeCubit),
               const SlideImage(),
              HomeProductsView(homeCubit: widget.homeCubit,state: widget.state),

            ],
          ),
        ),
      ),
    );
  }
}

class HomeProductsView extends StatefulWidget {
  const HomeProductsView({
    Key? key, required this.homeCubit, required this.state,

  }) : super(key: key);
final HomeCubit homeCubit ;
final HomeStates  state ;
  @override
  State<HomeProductsView> createState() => _HomeProductsViewState();
}

class _HomeProductsViewState extends State<HomeProductsView> {
  @override
  Widget build(BuildContext context ) {

     if(widget.state is GetProductsError ){
      return const Center(child: Text("حدث خطأ ما اثناء جلب المنتجات حاول لاحقا ! "),);
    }
     if(widget.state is GetProductsLoading && widget.homeCubit.products.isEmpty ){
       return const Center(child: CircularProgressIndicator(),);
    }
    if(widget.state is GetProductsSuccess){
      return widget.homeCubit.products.isNotEmpty ? Column(
        children: [
          TitleCategory(title: "آخر المزادات ", onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AllProductsScreen(),));
          }),
          const SizedBox(height: 10),
          SizedBox(
            height: 255,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ProductItem(
                productForViewModel: widget.homeCubit.products[index],
                isFullWidth: false,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 20,
              ),
              itemCount: widget.homeCubit.products.length,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children:
            widget.homeCubit.categories.isNotEmpty ?
            List.generate(widget.homeCubit.categories.length, (index) {
              return  widget.homeCubit.categoriesBlocks.isNotEmpty ? CategoryBlock(
                categoryBlockModel: HomeCubit.get(context).categoriesBlocks[index],
                homeCubit: widget.homeCubit,
              ) :const SizedBox();
            }) : [const SizedBox()],
          ),
        ],
      ) : const SizedBox();
    }
    return widget.homeCubit.products.isNotEmpty ?
    Column(
      children: [
        TitleCategory(title: "آخر المزادات ", onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AllProductsScreen(),));
        }),
        const SizedBox(height: 10),
        SizedBox(
          height: 255,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ProductItem(
              productForViewModel: widget.homeCubit.products[index],
              isFullWidth: false,
            ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 20,
            ),
            itemCount: widget.homeCubit.products.length,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children:
          widget.homeCubit.categories.isNotEmpty ?
          List.generate(widget.homeCubit.categories.length, (index) {
            return  HomeCubit.get(context).categoriesBlocks.isNotEmpty ? CategoryBlock(
              categoryBlockModel: HomeCubit.get(context).categoriesBlocks[index],
              homeCubit: widget.homeCubit,
            ) :const SizedBox();
          }) : [const SizedBox()],
        ),
      ],
    ) : const Text("");

  }
}

class CategoryBlock extends StatefulWidget {
  final CategoryBlockModel categoryBlockModel;
  final HomeCubit homeCubit;

  const CategoryBlock(
      {Key? key, required this.categoryBlockModel, required this.homeCubit})
      : super(key: key);

  @override
  State<CategoryBlock> createState() => _CategoryBlockState();
}

class _CategoryBlockState extends State<CategoryBlock> {
  @override
  Widget build(BuildContext context){
    List<ProductForViewModel> products = widget.categoryBlockModel.products ;
    return   products.isEmpty ? const SizedBox() :  Column(
      children: [
        TitleCategory(
            title: widget.categoryBlockModel.categoryName,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  CategoryScreen(
                    category: widget.categoryBlockModel.categoryModel,
                )
              ));
            }),
        const SizedBox(height: 10),
        SizedBox(
          height: 255,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ProductItem(
              productForViewModel: products[index],
              isFullWidth: false,
            ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 20,
            ),
            itemCount: products.length,
          ),
        ),
      ],
    ) ;
  }
}
