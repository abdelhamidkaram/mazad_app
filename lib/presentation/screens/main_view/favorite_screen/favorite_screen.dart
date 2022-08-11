import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/product_item.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/no_favorite_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<ProductForViewModel> items = [
      ProductForViewModel(
        false,
        "200",
        ProductModel(
            product: Product(
                status: 0,
                targetPrice: 300,
                minPrice: 200,
                name: "تجربة ",
                endDate: "2022-05-29",
                categoryId: 1,
                descrption:
                "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما.",
                id: 100)),
        "1000",
        "12",
      ),
      ProductForViewModel(
        false,
        "200",
        ProductModel(
            product: Product(
                status: 0,
                targetPrice: 300,
                minPrice: 200,
                name: "تجربة ",
                endDate: "2022-05-29",
                categoryId: 1,
                descrption:
                "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما.",
                id: 100)),
        "1000",
        "12",
      ),
    ];
    return items.isNotEmpty ? ListView.separated(
      separatorBuilder: (context, index) => const  SizedBox(height: 2,),
      itemCount: items.length,
      itemBuilder: (context , index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 13),
        child: ProductItem(isFullWidth: true, productModel: items[index] , isFavoriteScreen: true, ),
      ),
    ): const NoFavoriteScreen() ;
  }
}
