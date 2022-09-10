import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/product/widget/product_price_box.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) => HomeCubit(),
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        //TODO: GET CART PRODUCTS
        List<ProductForViewModel> products = [
          ProductForViewModel(
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

          ),
        ];
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            bottomNavigationBar: products.isEmpty
                ? null
                : AppButtons.appButtonBlue(() {
                    // TODO : GET PAYMENT
                  }, "دفع", true),
            backgroundColor: ColorManger.white,
            appBar: AppBars.appBarGeneral(context, cubit, "السلة ",
                cartView: false),
            body: products.isEmpty
                ? Center(
                    child: SvgPicture.asset("assets/nocartitem.svg"),
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(
                        products.length,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorManger.lightGrey),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            width: 105,
                                            height: 105,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: ColorManger
                                                          .lightGrey)),
                                            ),
                                            child: Image.network(
                                                products[index].thumbnail.toString())),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  products[index].title!,
                                                  style: AppTextStyles
                                                      .mediumBlackBold_17,
                                                  maxLines: 3,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                PriceAndCurrencyGreen(
                                                    productModel:
                                                        products[index] ,
                                                lastPrice: "",//TODO:
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: IconButton(
                                            onPressed: () {
                                              //TODO: REMOVE ITEM CART IN SERVER
                                            },
                                            icon: SvgPicture.asset(
                                                "assets/x.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                  ),
          ),
        );
      },
    );
  }
}
