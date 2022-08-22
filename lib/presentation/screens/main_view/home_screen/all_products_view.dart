import 'package:flutter/material.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/favorite_icon_widget.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/product/widget/image_product.dart';

import '../../../../models/product_model.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "جميع المنتجات"),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(
            HomeCubit.get(context).products.length,
            (index) => ProductItem(
                 productForViewModel: HomeCubit.get(context).products[index], isFullWidth: true,),
          ),
        ),
      ),
    );
  }
}
