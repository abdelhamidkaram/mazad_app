import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/states.dart';
import 'package:soom/style/color_manger.dart';

import '../../../../../app_bloc/app_cubit.dart';

class EditCubit extends Cubit<EditStates> {
  EditCubit() : super(InitEditState());

  static EditCubit get(context) => BlocProvider.of(context);

  // ------------ image edit ---------------|
  String img64User = "";
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
          initAspectRatio: CropAspectRatioPreset.square,
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
      emit(SetImageState());
    }
  }

  pickerCamera() async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      cropImage().then((value) {
        final bytes = File(photo!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        img64User = img64;
        getIsUploadImage(valueBool: true);
        //TODO: upload image to server
        putImage();
      });
      emit(SetImageState());
    } else {
      return;
    }
  }

  img64UserCache() async {
    await SharedPreferences.getInstance().then((value) {
      img64User = value.getString(PrefsKey.img64) ?? "";
    });
  }

  bool isUploadImage = false;

  bool getIsUploadImage({bool valueBool = false}) {
    emit(SetImageState());
    isUploadImage = valueBool;
    if (!valueBool) {
      SharedPreferences.getInstance().then((value) {
        isUploadImage = value.getBool(PrefsKey.isUploadImage) ?? false;
      });
      emit(SetImageState());
      return isUploadImage;
    } else {
      SharedPreferences.getInstance().then((value) {
        isUploadImage = value.getBool(PrefsKey.isUploadImage) ?? true;
      });
      emit(SetImageState());
      return isUploadImage;
    }
  }
  
  
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
  
  
// ------------ update profile  ---------------|

  putUpdateProfile(
      {required BuildContext context,
      required String email,
      required String name,
      required String phone}) {
    DioFactory().updateData(ApiEndPoint.updateProfile, {
      "emailAddress": email,
      "name": name,
      "surname": name,
      "userName": email,
      "phoneNumber": phone,
      //TODO:ADD CITY
    }).then((value) {
      if (value.statusCode == 200) {
        AppCubit.get(context).getProfileDetails();
        Navigator.pop(context);
      }
    });
  }
}
