import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import '../../../../../style/color_manger.dart';

class AddAuctionCubit extends Cubit<AddAuctionStates>{
  AddAuctionCubit() : super(InitAddAuctionState());
  static AddAuctionCubit get(context)=> BlocProvider.of(context);

  // ------------ image edit ---------------|
List<String> img = [
   "",
   "",
   "",
   "",
   "",
];
  XFile? photo;

  final ImagePicker _picker = ImagePicker();

  cropImage() async {
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
      emit(AddAuctionImgState());
    }
  }
  pickerCamera(int index) async {
     photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      cropImage().then((value) {
        final bytes = File(photo!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        img[index] = img64;
      });
      emit(AddAuctionImgState());
    } else {
      return;
    }
  }

  // bool isUploadImage = false;

  // bool getIsUploadImage({bool valueBool = false}) {
  //   emit(AddAuctionImgState());
  //   isUploadImage = valueBool;
  //   if (!valueBool) {
  //       return false;
  //   } else {
  //     emit(AddAuctionImgState());
  //     return isUploadImage;
  //   }
  // }


  //put image
  putImage()async {
    //   TODO:IMAGE PUT TO SERVER

    // await DioFactory().updateData("services/app/Profile/UpdateProfilePicture", {
    //    "fileToken": img64User,
    //  }).then((value){
    //
    //    print(value.data);
    // });

  }
//---------------- controllers -----------|
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var detailsController = TextEditingController();
  var priceController = TextEditingController();
  var nameController = TextEditingController();
 bool customValidate(context){
    if (
     timeController.text.isEmpty ||
     detailsController.text.isEmpty ||
    dateController.text.isEmpty||
    priceController.text.isEmpty ||
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





}