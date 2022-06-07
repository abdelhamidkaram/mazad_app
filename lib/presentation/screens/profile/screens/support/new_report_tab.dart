
import 'package:flutter/material.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/style/text_style.dart';

class NewReport extends StatefulWidget {
  const NewReport({Key? key}) : super(key: key);

  @override
  State<NewReport> createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder:(context, index) => Column(
          children: [
            Row(
              children:const  [
                Text("سبب التواصل " , style: AppTextStyles.titleSmallBlack,),
                Spacer()
              ],
            ),
            const SizedBox(height: 16,),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "ادخل سبب التواصل " ;
                }else{
                  return null ;
                }
              },
              decoration: const InputDecoration(
                hintText: "يمكنك كتابة سبب التواصل " ,
                border: OutlineInputBorder(),
                hintStyle: AppTextStyles.smallGrey,

              ),
            ),
            const SizedBox(height: 24,),
            Row(
              children:const  [
                Text("التفاصيل " , style: AppTextStyles.titleSmallBlack,),
                Spacer()
              ],
            ),
            const SizedBox(height: 16,),
            TextFormField(
              maxLines: 10,
              validator: (value){
                if(value!.isEmpty){
                  return "ادخل تفاصيل البلاغ " ;
                }else{
                  return null ;
                }
              },
              decoration: const InputDecoration(
                hintText: "يمكنك كتابة التفاصيل هنا " ,
                border: OutlineInputBorder(),
                hintStyle: AppTextStyles.smallGrey,

              ),
            ),
            const SizedBox(height: 16,),
            AppButtons.appButtonBlue(() {
              //TODO: SEND TO SERVER
            }, "ارسال ", true )
          ],
        ),
      ),
    );
  }
}


