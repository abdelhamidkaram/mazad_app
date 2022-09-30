import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/main.dart';
import 'package:soom/models/system_conf_model.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import '../../../../app_bloc/app_cubit.dart';

class SlideImage extends StatefulWidget {
  const SlideImage({Key? key}) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context, state) => AppCubit(),
      builder: (context, state) {
        if(HomeCubit.get(context).categoriesBlocks.isNotEmpty && AppCubit.get(context).ads.isEmpty){
          AppCubit.get(context).getSystemConf(context);
        }
        return  SizedBox(
          height: 160,
          child: Stack(
            alignment: const Alignment(0.2 , 0.7),
            children: [
              PageView.builder(
                onPageChanged: (index){
                  setState(() {
                    HomeCubit.get(context).slideCount = index ;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemCount:AppCubit.get(context).ads.isEmpty ? 4 : AppCubit.get(context).ads.length ,
                itemBuilder: (context, index){
                  return AppCubit.get(context).ads.isNotEmpty
                      ?
                  ExtendedImage.network(
                      AppCubit.get(context).ads[index].systemConfigration!.link! ,
                      cache: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return const LinearProgressIndicator(
                            color: Colors.white70,
                            backgroundColor: ColorManger.white,
                            minHeight: double.infinity,
                          );
                        }
                        else if (state.extendedImageLoadState == LoadState.failed) {
                          return Image.asset("assets/slid1.png");
                        }

                      }
                  )

                      : Image.asset("assets/slid1.png" );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate( 4 , (index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor:index == HomeCubit.get(context).slideCount ? ColorManger.white :ColorManger.black ,
                        child: CircleAvatar(
                          backgroundColor: index == HomeCubit.get(context).slideCount ? ColorManger.primary : ColorManger.white ,
                          radius: 5,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        )  ;
      },
    );
  }
}
