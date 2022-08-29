
import 'package:flutter/material.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/style/text_style.dart';

import '../../../../../constants/api_constants.dart';

class NewReport extends StatefulWidget {
  const NewReport({Key? key}) : super(key: key);

  @override
  State<NewReport> createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  var titleController = TextEditingController();
  var detailsController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder:(context, index) => Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children:const  [
                  Text("سبب التواصل " , style: AppTextStyles.titleSmallBlack,),
                  Spacer()
                ],
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: titleController,
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
                controller: detailsController,
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
                if(formKey.currentState!.validate()){
                  AppToasts.toastLoading(context);
                  DioFactory().postData(ApiEndPoint.createSupportCass,
                      {
                        "title": titleController.text,
                        "body": detailsController.text,
                        "createdByUserId": AppCubit.get(context).profileEditSuccess.result?.userId,
                      }).then((value){
                        Navigator.pop(context);
                        AppToasts.toastSuccess("تم الارسال بنجاح ", context);
                        titleController.clear();
                        detailsController.clear();

                  }).catchError((err){ Navigator.pop(context); AppToasts.toastError("حدث خطأ ما .. حاول لاحقا  !", context); });
                }

              }, "ارسال ", true )
            ],
          ),
        ),
      ),
    );
  }
}


