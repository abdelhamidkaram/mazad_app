import 'package:flutter/material.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';

class SlideImage extends StatefulWidget {
  final HomeCubit homeCubit ;
  const SlideImage({Key? key, required this.homeCubit}) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 160,
      child: Stack(
        alignment: const Alignment(0.2 , 0.7),
        children: [
          PageView.builder(
            onPageChanged: (index){
              setState(() {
                widget.homeCubit.slideCount = index ;
              });
            },
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index){
              return Image.asset("assets/slid1.png" );
            },),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor:index == widget.homeCubit.slideCount ? ColorManger.white :ColorManger.black ,
                    child: CircleAvatar(
                      backgroundColor: index == widget.homeCubit.slideCount ? ColorManger.primary : ColorManger.white ,
                      radius: 5,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
