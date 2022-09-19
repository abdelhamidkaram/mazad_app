import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Column(
             children: [
               const Text("من"),
               Container(
                 width:  60,
                 decoration: BoxDecoration(
                   border: Border.all(color: ColorManger.lightGrey),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: TextFormField(
                   controller: HomeCubit.get(context).minController,
                   keyboardType: TextInputType.number,
                   decoration: const InputDecoration(
                     border: InputBorder.none,
                   ),
                   textAlign: TextAlign.center,
                 ),
               ) ,
               const  Text("KW" ,style: AppTextStyles.currencyGreen),
             ],
           ),
            const SizedBox(width: 10,),
            const Text(":"),
            const SizedBox(width: 10,),
            Column(
              children: [
                const Text("إلى"),
                Container(
                  width:  60,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManger.lightGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: HomeCubit.get(context).maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ) ,
                const  Text("KW" ,style: AppTextStyles.currencyGreen),
              ],
            ),

          ],
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
