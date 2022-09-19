import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import 'package:soom/repository/repository.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../style/color_manger.dart';
import '../../../category/category_model.dart';

class AddAuctionCubit extends Cubit<AddAuctionStates>{
  AddAuctionCubit() : super(InitAddAuctionState());
  static AddAuctionCubit get(context)=> BlocProvider.of(context);
  final Repository _repository = Repository();

  // ------------ image edit ---------------|
List<String> img = [
   "",
   "",
   "",
   "",
   "",
];


List<ImageObj> imagesObj = [];

  XFile? photo;

  final ImagePicker _picker = ImagePicker();

  cropImage(context , int index ) async {
    CroppedFile? cropFile = await ImageCropper().cropImage(
      sourcePath: photo!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'تعديل الصورة ',
          toolbarColor: ColorManger.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          activeControlsWidgetColor: ColorManger.primary,
          backgroundColor: ColorManger.black,
          cropFrameColor: ColorManger.black_40,
        ),
        IOSUiSettings(
          title: 'تعديل الصورة ',
        ),
      ],
    );
    if (cropFile != null) {
      photo = XFile(cropFile.path);
      _uploadImage(File(cropFile.path), context , index);
      emit(AddAuctionImgState());
    }
  }
  pickerCamera(int index , context) async {
     photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      cropImage(context , index ).then((value) {
        final bytes = File(photo!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        img[index] = img64;
      });
      emit(AddAuctionImgState());
    } else {
      return;
    }
  }

//---------------- controllers -----------|
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var detailsController = TextEditingController();
  var initialPriceController = TextEditingController();
  var minPriceController = TextEditingController();
  var targetPriceController = TextEditingController();
  var nameController = TextEditingController();
  var catController = TextEditingController();

  CategoryModel categorySelected = CategoryModel(2, "img", "2ساعات") ;
  String timeSelected = "24ساعات";
 bool customValidate(context){
   if(  dateController.text.isEmpty ){
     AppToasts.toastError("يرجي ادخال تاريخ الانتهاء ", context);
     emit(CheckPriceFieldFormState());
     return false ;
   }else if (
    timeController.text.isEmpty ||
    detailsController.text.isEmpty ||
    initialPriceController.text.isEmpty ||
    nameController.text.isEmpty ||
    nameController.text.isEmpty
    )
    {
      AppToasts.toastError("يرجي ملئ جميع الحقول ", context);
      emit(CheckPriceFieldFormState());
      return false ;
    }else {
      emit(CheckPriceFieldFormState());
      return true;
    }
  }
//---------------- Check Box -------------|
bool isCheckTime = true ;
bool isCheckPrice = false ;
getCheckTime(){
  isCheckTime = !isCheckTime;
  isCheckPrice =!isCheckTime;
  emit(AddAuctionCheckBoxState());
}

//---------------- Check Box -------------|

bool isUploadDetails = false ;
bool isUploadImages = false ;

//---------------- upload product -------------|
//  Future uploadProductDetails (AddAuctionStates state , context)async{
//    emit(UploadDetailsLoading());
//    if(state is UploadDetailsLoading ){
//      AppToasts.toastLoading(context);
//    }
//
//    (
//    await _repository.uploadProductDetails(data:  {
//      "name": nameController.text,
//      "descrption": detailsController.text,
//      "intitalPrice": int.parse(initialPriceController.text).toDouble(),
//      "minPrice": int.parse(minPriceController.text).toDouble(),
//      "endDate": endDate.substring(0,10)+"T"+endDate.substring(11)+"Z",
//      "status": 0,
//      "targetPrice": int.parse(minPriceController.text).toDouble(),
//      "categoryId": categorySelected.index ?? 2 ,
//    })
//    ).fold((error){
//      isUploadDetails = false ;
//      emit(UploadDetailsError());
//      AppToasts.toastError(error.message, context);
//    }, (map){
//      if(kDebugMode){
//        print(map.toString());
//      }
//      isUploadDetails = false ;
//      emit(UploadDetailsSuccess());
//      AppToasts.toastSuccess("تم رفع تفاصيل المنتج بنجاح ", context);
//
//    });
// }
//---------------- upload image  -------------|
   void _uploadImage(File file , BuildContext context, int index  ) async {
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    AppToasts.toastLoading(context);
    String newToken = token;
    await DioFactory(newToken).dio().post("/app/productphotos/uploadphotofile", data: data)
        .then((response){
          if (kDebugMode) {
            print(response.data.toString());
          }
          if (kDebugMode) {
            print(fileName);
          }
          ImageObj imageObj = ImageObj(fileName , response.data["result"]["fileToken"]);
      _addImageToImagesObject(imageObj, index);
     Navigator.pop(context);
     AppToasts.toastSuccess("تم رفع الصورة", context);
     Timer(const Duration(seconds: 2), (){
       Navigator.pop(context);
     });
   }).catchError((error){
      Navigator.pop(context);
          AppToasts.toastError("حدث خطأ ما حاول لاحقا !", context);
      Timer(const Duration(seconds: 1), (){
        Navigator.pop(context);
      });
    });
  }
_addImageToImagesObject (ImageObj imageObj , int index ){
   if(imagesObj.length >= index ){
     imagesObj[index] = imageObj ;
   }else{
     imagesObj.add(imageObj);
   }

}

}

class ImageObj {
  final String name ;
  final String  token ;

  ImageObj(
      this.name,
      this.token,
      );

}