import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/constants/app_string.dart';
import 'package:soom/main.dart';
import 'package:soom/models/auction_model.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/login_required_widget.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_cubit.dart';
import 'package:soom/presentation/screens/product/bloc/add_bid_states.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AddBid extends StatefulWidget {
  final ProductForViewModel productModel;

  const AddBid({Key? key, required this.productModel}) : super(key: key);

  @override
  State<AddBid> createState() => _AddBidState();
}

class _AddBidState extends State<AddBid> {
  @override
  void initState() {
    super.initState();
    BidCubit.get(context).getController(context, widget.productModel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BidCubit, BidStates>(
      listener: (context, state) => BidCubit(),
      builder: (context, state) {
        //TODO: Get Last Price With SIGNAL R
        String lastPrice = widget.productModel.lasPrice!;
        var bidCubit = BidCubit.get(context);
        var controller = bidCubit.controller;
        var bidPriceKey = GlobalKey<FormFieldState>();
        List<int> bidCounter = [1, 2, 3, 4, 5, 6, 7, 8,9, 10, 20, 30, 40, 50];
         _replaceController() {
          setState(() {
            if (controller.text.contains(",") ||
                controller.text.contains(".") ||
                controller.text.contains(" ")) {
              controller.text = controller.text.replaceAll(",", "");
              controller.text = controller.text.replaceAll(".", "");
              controller.text = controller.text.replaceAll(" ", "");
            }
          });
        }

        _checkRangeBidOrCheckAndSendDataToServer(value,
            {AuctionForViewModel? auctionForViewModel}) {
          if (value.isNotEmpty) {
            _replaceController();
            if ((int.parse(value) <= int.parse(lastPrice))) {
              controller.text = lastPrice;
              AppToasts.toastError(
                  "لقد ادخلت سعرا أقل من أو يساوي آخر مزايدة يجب ان تزايد بمبلغ أكبر من  : $lastPrice",
                  context);
            } else {
              if (auctionForViewModel != null) {
                bidCubit
                    .sendBidToServer(
                        productId:
                            auctionForViewModel.productModel.product!.id!,
                        price: int.parse(value).toDouble(),
                        context: context)
                    .then((value) {});
              }
            }
          }
        }

        return  Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: ColorManger.white,
                  appBar: AppBars.appBarGeneral(
                      context, HomeCubit.get(context), "اضافة مزايدة ",
                      cartView: false),
                  body:token.isNotEmpty
                      ?
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child:ExtendedImage.network(
                                  widget.productModel.thumbnail,
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
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("اسم المنتج : ", style: AppTextStyles.titleBlack,),
                                Text(
                                 widget.productModel.title!,
                                  style: AppTextStyles.titleBlue_24,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("اضافة مزايدة : ", style: AppTextStyles.titleBlack,),
                                Center(
                                  child: SizedBox(
                                    width: 160,
                                    height: 60,
                                    child: TextFormField(
                                      key: bidPriceKey,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return " ادخل قيمة المزايدة ";
                                        } else {
                                          _replaceController();
                                          _checkRangeBidOrCheckAndSendDataToServer(
                                              value);
                                        }
                                        return null;
                                      },
                                      onEditingComplete: () {
                                        _replaceController();
                                      },
                                      onFieldSubmitted: (value) {
                                        _replaceController();
                                        _checkRangeBidOrCheckAndSendDataToServer(
                                            value);
                                      },
                                      controller: controller,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.titleGreen_30,
                                      keyboardType:
                                      const TextInputType.numberWithOptions(),
                                      decoration:  InputDecoration(
                                        prefix: const Text("kw" , style: AppTextStyles.currencyGreen,),
                                        hintStyle: AppTextStyles.titleGreen_30,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 110,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          bidCubit.bidCounter =
                                          bidCounter[index];
                                          controller.text = (int.parse(lastPrice) + bidCounter[index]).toString();
                                        });
                                      },
                                      child: Center(
                                          child: Text(
                                            bidCounter[index].toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: AppString.fontName,
                                            ),
                                          )),
                                    ),
                                    separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    itemCount: bidCounter.length,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: ColorManger.lightGrey,
                                  foregroundColor: ColorManger.black,
                                  onPressed: () {
                                    int index = 0 ;
                                    for(int count in bidCounter){
                                      index++;
                                      if(bidCubit.bidCounter == count && index != bidCounter.length ){
                                        setState(() {
                                          bidCubit.bidCounter = bidCounter[index];
                                          controller.text = (int.parse(lastPrice) + bidCubit.bidCounter).toString();
                                        });
                                        break;
                                      }


                                    }
                                  },
                                  child: const Icon(Icons.arrow_back_ios),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text(
                                        "KW",
                                        style: TextStyle(
                                        ),
                                      ),
                                      Text(
                                        bidCubit.bidCounter.toString(),
                                        style: AppTextStyles.titleSmallBlack,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: ColorManger.lightGrey,
                                  foregroundColor: ColorManger.black,
                                  onPressed: () {
                                    //TODO: DELETE removeBid FUN FORM BID CUBIT
                                   //   bidCubit.removeBid(
                                  //       widget.productModel, context);
                                    for(int i =0 ;i < bidCounter.length ; i++){
                                        if(bidCounter[i] == bidCubit.bidCounter){
                                          setState((){
                                          if(i != 0){
                                            bidCubit.bidCounter = bidCounter[i-1];
                                          }
                                          controller.text = (int.parse(lastPrice) + bidCubit.bidCounter).toString();
                                          });
                                        }

                                    }
                                  },
                                  child: const Icon(Icons.arrow_forward_ios),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            AppButtons.toastButtonBlue(() {
                              _replaceController();
                              if (controller.text.isNotEmpty) {
                                AuctionForViewModel auctionForViewModel =
                                AuctionForViewModel(
                                  price: int.parse(controller.text),
                                  productModel:
                                  widget.productModel.productModel,
                                  userModel: UserModel(
                                      userId:
                                      int.parse(id)),
                                );
                                _checkRangeBidOrCheckAndSendDataToServer(
                                    controller.text,
                                    auctionForViewModel: auctionForViewModel);
                              } else {
                                AppToasts.toastError(
                                    "ادخل قيمة المزايدة ", context);
                                controller.text = lastPrice;
                              }
                            }, "اضافة مزايدة ", true,
                                icon: SvgPicture.asset(
                                  "assets/auction.svg",
                                  color: ColorManger.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                      : const LoginRequiredWidget(message: "يرجي تسجيل الدخول لإضافة مزايدة "),
                ),
              );

      },
    );
  }
}
