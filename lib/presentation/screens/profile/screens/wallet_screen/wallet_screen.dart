import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/offline_screen/offline_screen.dart';
import 'package:soom/presentation/screens/profile/widgets/wallet_widget/wallet_widget.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {

    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        setState(() {
          if (result != ConnectivityResult.none) {
            setState(() {
              isConnect = true;
            });
          } else {
            setState(() {
              isConnect = false;
            });
          }
        });
      },
    );
    super.initState();
  }

  bool isConnect = true;

  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    
    List<BalanceModel> items = [
      BalanceModel("15000", "لاب توب ابل ماك برو1 ", "29-10-2022", false,),
      BalanceModel("600", "لاب توب ابل ماك برو2 ", "28-10-2022", true,),
      BalanceModel("51244", "لاب توب ابل ماك برو3 ", "27-10-2022", false,),
      BalanceModel("500", "لاب توب ابل ماك برو4 ", "26-10-2022", true,),
      BalanceModel("15000", "لاب توب ابل ماك برو5 ", "25-10-2022", false,),
      BalanceModel("50", "لاب توب ابل ماك برو6 ", "24-10-2022", true,),
      BalanceModel("7000", "لاب توب ابل ماك برو7 ", "23-10-2022", false,),
      BalanceModel("15000", "لاب توب ابل ماك برو8 ", "22-10-2022", true,),
      BalanceModel("8500", "لاب توب ابل ماك برو9 ", "21-10-2022", false,),
      BalanceModel("15000", "لاب توب ابل ماك برو10 ", "20-10-2022", true,),
    ];
    return isConnect ?  Directionality(
      textDirection: TextDirection.rtl ,
      child: Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "المحفظة" , cartView: false , ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24),
            child: Column(
              children:  [
                //TODO: GET BALANCE FORM SERVER
                const Center(child: BalanceWidget(balance: "1500",)),
               const SizedBox(height: 24,),
               InkWell(
                 onTap: (){
                   //TODO: RE BALANCE
                 },
                 child:
                 Container(
                   height: 50,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(color: ColorManger.green)
                   ),
                   child:const Center(child:  Text("سحب الرصيد " , style: AppTextStyles.mediumGreen,)) ,
                 ),
               ),
               const SizedBox(height: 10,),
               InkWell(
                 onTap: (){
                   //TODO: ADD BALANCE
                 },
                 child:
                 Container(
                   height: 50,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(color: ColorManger.green)
                   ),
                   child:const Center(child:  Text("إضافة رصيد " , style: AppTextStyles.mediumGreen,)) ,
                 ),
               ),
               const SizedBox(height: 12,),
               Column(
                 children: List.generate(10, (index) =>  BalanceItemBuilder(balanceModel: items[index])),
               ),
              ],
            ),
          ),
        ),
      ),
    ) : const OfflineScreen();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     subscription?.cancel();
  }
}

class BalanceItemBuilder extends StatefulWidget {
  final BalanceModel balanceModel ;
  const BalanceItemBuilder({Key? key, required this.balanceModel}) : super(key: key);

  @override
  State<BalanceItemBuilder> createState() => _BalanceItemBuilderState();
}

class _BalanceItemBuilderState extends State<BalanceItemBuilder> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.balanceModel.data),
             const Spacer()
            ],
          ),
          const SizedBox(height: 16,),
          Row(
              children:   [
                  Icon(widget.balanceModel.isAdd ? Icons.add_circle : Icons.remove_circle, color: widget.balanceModel.isAdd ? ColorManger.green : ColorManger.red, size:  30,) ,
                const SizedBox(width:8,),
                 Text(widget.balanceModel.name , style: AppTextStyles.mediumBlackBold,),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  const  Text("KW", style: AppTextStyles.currencyGreen,),
                    Text(widget.balanceModel.isAdd ?widget.balanceModel.balance + " + "  : widget.balanceModel.balance + " - "  , style: AppTextStyles.titleGreen,),
                  ],),
              ]
          ),
        ],
      ),
    );
  }
}

class BalanceModel {
  final String data ;
  final String name ;
  final String balance ;
  final bool isAdd ;
  BalanceModel(this.balance , this.name , this.data , this.isAdd );
}