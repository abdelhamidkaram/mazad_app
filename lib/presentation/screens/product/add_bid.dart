import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/constants/app_string.dart';
import 'package:soom/models/auction_model.dart';
import 'package:soom/models/product_model.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
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
    BidCubit.get(context).getController( context , widget.productModel);
  }
  @override
  Widget build(BuildContext context) {

 return  BlocConsumer<BidCubit , BidStates>(
   listener: (context, state) => BidCubit(),
   builder: (context , state ){
      String lastPrice =   widget.productModel.minPrice!.toInt().toString() ; //TODO : CONVERT min PRICE TO LAST PRICE
     var bidCubit = BidCubit.get(context);
     var controller = bidCubit.controller;
     var bidPriceKey = GlobalKey<FormFieldState>();
     List<int> bidCounter = [10 , 20 , 30 , 40 , 50 , 70 , 80 , 100 , 150 , 200 ,250 ,  300 , 350 , 400 , 450 , 500 , 600 , 700 , 800 , 900 , 1000 ];
     _replaceController(){
          setState(() {
            if(controller.text.contains(",") || controller.text.contains(".") || controller.text.contains(" ") )
            {
              controller.text = controller.text.replaceAll(",", "");
              controller.text = controller.text.replaceAll(".", "");
              controller.text = controller.text.replaceAll(" ", "");
            }
          });
       }
     _checkRangeBidOrCheckAndSendDataToServer(value ,{AuctionForViewModel?  auctionForViewModel}   ){
       if(value.isNotEmpty){
         _replaceController();
         if((int.parse(value) <= int.parse(lastPrice))){
           controller.text = lastPrice ;
           AppToasts.toastError("لقد ادخلت سعرا أقل من أو يساوي آخر مزايدة يجب ان تزايد بمبلغ أكبر من  : $lastPrice", context);
         }else{
          if(auctionForViewModel !=null ){
            bidCubit.sendBidToServer(auctionForViewModel, context).then((value){});
          }
         }
       }
     }
     return Directionality(
       textDirection: TextDirection.rtl,
       child: Scaffold(
         backgroundColor: ColorManger.white,
         appBar: AppBars.appBarGeneral(context , HomeCubit.get(context), "اضافة مزايدة " , cartView: false),
         body: SingleChildScrollView(
           physics:const  BouncingScrollPhysics(),
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 20),
             child: Center(
               child: Column(
                 children: [
                   SizedBox(
                     height: 200,
                     child: Image.network(widget.productModel.thumbnail),
                   ),
                   const SizedBox(height: 25,),
                   Text(
                     widget.productModel.title! ,
                     style: AppTextStyles.titleBlue_24,
                     maxLines: 3,
                     overflow: TextOverflow.ellipsis,),
                   const SizedBox(height: 10,),
                   Center(
                     child: SizedBox(
                       width: 150,
                       child: TextFormField(
                         key: bidPriceKey,
                         validator: (value) {
                           if(value!.isEmpty){
                             return " ادخل قيمة المزايدة " ;
                           }else{
                             _replaceController();
                             _checkRangeBidOrCheckAndSendDataToServer(value);
                           }
                           return null ;
                         },
                         onEditingComplete: (){
                           _replaceController();
                         },
                         onFieldSubmitted: (value){
                           _replaceController();
                           _checkRangeBidOrCheckAndSendDataToServer(value);
                         },
                         controller: controller,
                         textAlign: TextAlign.center,
                         style: AppTextStyles.titleGreen_30,
                         keyboardType:  const TextInputType.numberWithOptions(),
                         decoration: const InputDecoration(
                           hintStyle: AppTextStyles.titleGreen_30,
                           border: InputBorder.none,
                         ),
                       ),
                     ),
                   ),
                   const SizedBox(height: 15,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       SizedBox(
                         height: 20 ,
                         width: 110,
                         child: ListView.separated(
                           shrinkWrap: true,
                           scrollDirection: Axis.horizontal,
                             itemBuilder: (context, index) => InkWell(
                               onTap: (){
                                  setState(() {
                                    bidCubit.bidCounter =  bidCounter[index] ;
                                  });
                               },
                               child: Center(
                                   child: Text(bidCounter[index].toString() ,
                                     style:const TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: AppString.fontName,
                                     ),)),
                             ),
                             separatorBuilder: (context , index)=>const SizedBox(width: 20,),
                             itemCount:  bidCounter.length,

                         ),
                       ),
                       const SizedBox(width: 3,),
                       FloatingActionButton(
                         mini: true,
                         backgroundColor: ColorManger.lightGrey,
                         foregroundColor: ColorManger.black,
                         onPressed: (){
                           bidCubit.addBid(widget.productModel , context);
                         } ,
                         child:const Icon(Icons.add), ),
                       const SizedBox(width: 10,),
                        Text(bidCubit.bidCounter.toString() , style: AppTextStyles.titleSmallBlack,),
                       const SizedBox(width: 10,),
                       FloatingActionButton(
                         mini: true,
                         backgroundColor: ColorManger.lightGrey,
                         foregroundColor: ColorManger.black,
                         onPressed: (){
                            bidCubit.removeBid(widget.productModel , context);
                         } ,
                         child:const Icon(Icons.remove), ),
                      const Spacer(),
                     ],),
                   const SizedBox(height: 40,),
                   AppButtons.toastButtonBlue(() {
                     _replaceController();
                     if(controller.text.isNotEmpty){
                       AuctionForViewModel auctionForViewModel = AuctionForViewModel(
                         price:int.parse( controller.text),
                         productModel: widget.productModel.productModel,
                         userModel: UserModel(userId: 5 ) , //TODO : USER MODEL
                       );
                       _checkRangeBidOrCheckAndSendDataToServer(controller.text, auctionForViewModel: auctionForViewModel);
                     }else{
                       AppToasts.toastError("ادخل قيمة المزايدة ", context);
                       controller.text = lastPrice;
                     }
                   }, "اضافة مزايدة ", true ,
                       icon: SvgPicture.asset("assets/auction.svg" , color: ColorManger.white,)),
                 ],
               ),
             ),
           ),
         ),
       ),
     );
   },
 );


  }


}
