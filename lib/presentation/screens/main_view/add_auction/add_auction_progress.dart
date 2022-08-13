
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_cubit.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';

class AddAuctionProgress extends StatefulWidget {
  const AddAuctionProgress({Key? key}) : super(key: key);

  @override
  State<AddAuctionProgress> createState() => _AddAuctionProgressState();
}

class _AddAuctionProgressState extends State<AddAuctionProgress> {
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBars.appBarGeneral(context, HomeCubit(), "اضافة المنتج"),
        body: BlocConsumer<AddAuctionCubit , AddAuctionStates>(
          listener: (context, state) => AddAuctionCubit()..uploadProductDetails(state, context),
          builder: (context, state) {
            var cubit = AddAuctionCubit.get(context);
            return Column(
              children: [
                Row(
                  children:const  [
                  Icon( Icons.check_circle , color: ColorManger.green, ),
                    Text("تم اضافة كتابة بيانات المنتج بنجاح ") ,
                ],),
                cubit.isUploadDetails
                    ?
                Row(
                  children:  const [
                 Icon( Icons.check_circle , color: ColorManger.green, ),
                    Text("تم رفع بيانات المنتج بنجاح ") ,

                ],) :
                Row(
                  children:  const [
                    Icon( Icons.file_upload , color: ColorManger.grey, ),
                    Text("جاري رفع تفاصيل المنتج .. ") ,

                  ],),
                cubit.isUploadImages
                    ?
                Row(
                  children:  const [
                    Icon( Icons.check_circle , color: ColorManger.green, ),
                    Text("تم رفع صور المنتج بنجاح ") ,

                  ],) :
                Row(
                  children:  const [
                    Icon( Icons.file_upload , color: ColorManger.grey, ),
                    Text("جاري رفع صور المنتج .. ") ,

                  ],),
              ],
            );
          },
        ),
      ),
    );
  }
  @override
  void dispose() {
    AddAuctionCubit.get(context).isUploadImages = false ;
    AddAuctionCubit.get(context).isUploadDetails = false ;
    super.dispose();
  }
}
