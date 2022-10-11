import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_states.dart';
import 'package:soom/presentation/screens/main_view/filter.dart';
import 'package:soom/presentation/screens/main_view/widget/home_widgets/category_item_build.dart';
import 'package:soom/presentation/screens/main_view/widget/filter_widgets/filter_componants.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AppToasts {
  static toastError(String message) {
    EasyLoading.showError(message);
  }

  static toastSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  static toastLoading(String text, { bool dismissOnTap = true }) {
    EasyLoading.show(
      status: text,
      dismissOnTap: dismissOnTap,
    );
  }

  static toastFilter(HomeCubit homeCubit, context) {
    showDialog(
      context: context,
      builder: (context) =>
          Center(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) =>
                    Dialog(
                      backgroundColor: ColorManger.white,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    const Text(
                                      "الفلتر",
                                      style: AppTextStyles.titleBlue,
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          homeCubit.deleteFilter();
                                        });
                                      },
                                      child: const Text(
                                        "مسح الكل ",
                                        style: AppTextStyles.mediumGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "النوع",
                                          style: AppTextStyles.titleSmallBlue,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 215,
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          spacing: 8,
                                          runSpacing: 10,
                                          verticalDirection: VerticalDirection
                                              .down,
                                          children: List.generate(
                                              homeCubit.categories.length,
                                                  (index) =>
                                                  CategoryItemBuild(
                                                    isFilter: true,
                                                    homeCubit: homeCubit,
                                                    categoryModel: homeCubit
                                                        .categories[index],
                                                  )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 15),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "التصنيف ",
                                          style: AppTextStyles.titleSmallBlue,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ignore: prefer_const_constructors
                                  ChangeFilterCategory(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      children: const [
                                        Text(
                                          " حسب السعر ",
                                          style: AppTextStyles.titleSmallBlue,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  // ignore: prefer_const_constructors
                                  RangePriceFilter(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  AppButtons.toastButtonBlue(() {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FilterResultScreen(
                                              homeCubit: homeCubit,
                                            ),
                                      ),

                                    );
                                  }, "فلترة", true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            ),
          ),
    );
  }
}

class DeleteFilter extends StatefulWidget {
  const DeleteFilter({Key? key}) : super(key: key);

  @override
  State<DeleteFilter> createState() => _DeleteFilterState();
}

class _DeleteFilterState extends State<DeleteFilter> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) => HomeCubit(),
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            setState(() {
              HomeCubit.get(context).deleteFilter();
            });
          },
          child: const Text(
            "مسح الكل ",
            style: AppTextStyles.mediumGrey,
          ),
        );
      },
    );
  }
}
