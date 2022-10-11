import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/presentation/components/favorite_icon.dart';
import 'package:soom/style/color_manger.dart';

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
            GestureDetector(
              onTap: (){
                showDialog(

                    context: context, builder: (context)=>Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0 , horizontal: 16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -100,
                    width: MediaQuery.of(context).size.width-32,
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          child: Dialog(
                            child: ExtendedImage.network(
                                widget.productModel!.thumbnail,
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
                                    return Image.asset("assets/noimg.png");

                                  }

                                }
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar( backgroundColor: Colors.black, child: Icon(Icons.close , color: Colors.white,))),
                      ],
                    ),
                  ),
                ));
              },
              child: Center(
                child: ExtendedImage.network(
                    widget.productModel!.thumbnail,
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
                        return Image.asset("assets/noimg.png");

                      }

                    }
                )
              ),
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
