import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/screens/category/category.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';



class CategoryItemBuild extends StatefulWidget {
  final bool isFilter;
  final CategoryModel? categoryModel ;
  final HomeCubit homeCubit;
    CategoryItemBuild({Key? key , required this.isFilter , this.categoryModel, required this.homeCubit}) : super(key: key);
  late bool isSelected = false ;

  @override
  State<CategoryItemBuild> createState() => _CategoryItemBuildState();
}
class _CategoryItemBuildState extends State<CategoryItemBuild> {
  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: (){
       widget.isFilter ?  setState(() {
         widget.isSelected = !widget.isSelected;
         widget.isSelected
             ? widget.homeCubit.addToFilterCategories(widget.categoryModel?.index ?? 00)
             :  widget.homeCubit.deleteFromFilterCategories(widget.categoryModel?.index ?? 00 );
       }) :  Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => CategoryScreen(
               category: widget.categoryModel ?? CategoryModel(000 ,"assets/r.png", "غير معروف "),
             ),
           )) ;
      },
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:widget.isSelected ?  Border.all(color: ColorManger.black , width: 2) : null,
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: ColorManger.primaryLight_10,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child:
                    widget.categoryModel!.img!.substring(widget.categoryModel!.img.toString().length - 3 ) == "svg"
                        ?
                    SvgPicture.network(widget.categoryModel!.img! , color: ColorManger.primary,)
                        :
                    Image.network(widget.categoryModel!.img!)
                    ,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.categoryModel!.title!,
              style: widget.isSelected ? AppTextStyles.mediumBlue  : AppTextStyles.smallBlack,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

