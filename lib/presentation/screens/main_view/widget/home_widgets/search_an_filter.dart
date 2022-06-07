import 'package:flutter/material.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/main_view/search.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class SearchAndFilter extends StatefulWidget {
  final HomeCubit homeCubit;

  const SearchAndFilter({Key? key, required this.homeCubit}) : super(key: key);

  @override
  State<SearchAndFilter> createState() => _SearchAndFilterState();
}

class _SearchAndFilterState extends State<SearchAndFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: ColorManger.lightGrey)),
          child: TextFormField(
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                //TODO : SEARCH
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(
                      products: widget.homeCubit.getSearchResult(value),
                    ),
                  ),
                );
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            cursorColor: ColorManger.primary,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintStyle: AppTextStyles.smallGrey,
                hintText: "ابحث من هنا ",
                border: InputBorder.none),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
              color: ColorManger.primaryLight,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: InkWell(
              onTap: () {
                AppToasts.toastFilter(
                  widget.homeCubit,
                  context,
                );
              },
              child: const Icon(
                Icons.filter_list_sharp,
                color: ColorManger.white,
                size: 40,
              )),
        ),
      ],
    );
  }
}
