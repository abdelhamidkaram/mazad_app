import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/favorite_icon.dart';
import 'package:soom/presentation/screens/main_view/favorite_screen/bloc/cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class ProductImageBox extends StatefulWidget {
   ProductForViewModel? productModel;

   ProductImageBox({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductImageBox> createState() => _ProductImageBoxState();
}

class _ProductImageBoxState extends State<ProductImageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorManger.lightGrey),
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Center(
              child: ExtendedImage.network(
                  widget.productModel!.thumbnail,
                  // width: ScreenUtil.instance.setWidth(400),
                  // height: ScreenUtil.instance.setWidth(400),
                  // fit: BoxFit.fill,
                  cache: true,
                  //border: Border.all(color: Colors.red, width: 1.0),
                  // shape: boxShape,
                  // borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  //cancelToken: cancellationToken,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return const LinearProgressIndicator(
                        color: Colors.white70,
                        backgroundColor: ColorManger.white,
                        minHeight: double.infinity,
                      );
                    }
                    else if (state.extendedImageLoadState == LoadState.failed) {
                      return Image.asset("assets/noimg.png");

                    }

                  }
              )
            ),
            Row(
              children:  [
                FavoriteIcon(widget.productModel!),
               const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
