import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class RangePriceFilter extends StatefulWidget {
  const RangePriceFilter({Key? key}) : super(key: key);

  @override
  State<RangePriceFilter> createState() => _RangePriceFilterState();
}

class _RangePriceFilterState extends State<RangePriceFilter> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          width: 250,
          child: RangeSlider(
              activeColor: ColorManger.primary,
              inactiveColor: ColorManger.lightGrey,
              max: 10000,
              min: 50 ,
              values: HomeCubit.get(context).getRangeValues() ,
              onChanged: (value){
                setState(() {
                  HomeCubit.get(context).changeRangeValue(value);
                });
              }),
        ),
        SizedBox(
          width: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:  [
              Row(
                children: [
                  const  Text("KW" ,style: AppTextStyles.currencyGreen),
                  Text(HomeCubit.get(context).minRangeFilter.toString(), style : AppTextStyles.titleGreen),
                  const SizedBox(width: 5,),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const  Text("KW" ,style: AppTextStyles.currencyGreen),
                  Text(HomeCubit.get(context).maxRangeFilter.toString(), style : AppTextStyles.titleGreen),
                  const SizedBox(width: 5,),
                ],
              ),
            ],),
        ),

      ],
    );
  }
}

class ChangeFilterCategory extends StatefulWidget {
  const ChangeFilterCategory({Key? key}) : super(key: key);

  @override
  State<ChangeFilterCategory> createState() => _ChangeFilterCategoryState();
}

class _ChangeFilterCategoryState extends State<ChangeFilterCategory> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              HomeCubit.get(context).isMost = true;
              HomeCubit.get(context).isLess = false;
              HomeCubit.get(context).isNew = false;
              HomeCubit.get(context).isOld = false;
              HomeCubit.get(context).changeFilter();
            });
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: 30,
              width: 80,
              decoration:  BoxDecoration(
                  borderRadius:
                 const BorderRadius.all(Radius.circular(8)),
                  color:HomeCubit.get(context).isMost ? ColorManger.primary : ColorManger.primaryLight_10),
              child:  Center(
                child: Text(
                  "الأكثر مزايدة ",
                  style: HomeCubit.get(context).isMost ? AppTextStyles.smallWhite : AppTextStyles.smallGrey,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              HomeCubit.get(context).isMost = false;
              HomeCubit.get(context).isLess = true;
              HomeCubit.get(context).isNew = false;
              HomeCubit.get(context).isOld = false;
              HomeCubit.get(context).changeFilter();
            });
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: 30,
              width: 80,
              decoration:  BoxDecoration(
                  borderRadius:
                 const  BorderRadius.all(Radius.circular(8)),
                  color: HomeCubit.get(context).isLess ? ColorManger.primary : ColorManger.primaryLight_10),
              child:  Center(
                child: Text(
                  "الأقل مزايدة ",
                  style: HomeCubit.get(context).isLess ? AppTextStyles.smallWhite : AppTextStyles.smallGrey,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              HomeCubit.get(context).isMost = false;
              HomeCubit.get(context).isLess = false;
              HomeCubit.get(context).isNew = true;
              HomeCubit.get(context).isOld = false;
              HomeCubit.get(context).changeFilter();
            });
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: 30,
              width: 65,
              decoration: BoxDecoration(
                  borderRadius:
                 const  BorderRadius.all(Radius.circular(8)),
                  color:  HomeCubit.get(context).isNew ? ColorManger.primary : ColorManger.primaryLight_10),
              child:  Center(
                child: Text(
                  "الأحدث ",
                  style: HomeCubit.get(context).isNew ? AppTextStyles.smallWhite : AppTextStyles.smallGrey,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(

          onTap: (){
            setState(() {
              HomeCubit.get(context).isMost = false;
              HomeCubit.get(context).isLess = false;
              HomeCubit.get(context).isNew = false;
              HomeCubit.get(context).isOld = true;
              HomeCubit.get(context).changeFilter();
            });
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 30,
              width: 65,
              decoration:  BoxDecoration(
                  borderRadius:
                const  BorderRadius.all(Radius.circular(8)),
                  color:  HomeCubit.get(context).isOld ? ColorManger.primary : ColorManger.primaryLight_10),
              child:  Center(
                child: Text(
                  "الأقدم ",
                  style:HomeCubit.get(context).isOld ? AppTextStyles.smallWhite : AppTextStyles.smallGrey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
