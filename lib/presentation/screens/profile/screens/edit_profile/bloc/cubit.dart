import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/data/cache/prefs.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/states.dart';
import 'package:soom/style/color_manger.dart';
import '../../../../../app_bloc/app_cubit.dart';
import '../../../../../components/toast.dart';
import '../../../widgets/profile_home_header.dart';

class EditCubit extends Cubit<EditStates> {
  EditCubit() : super(InitEditState());

  static EditCubit get(context) => BlocProvider.of(context);

  // ------------ image edit ---------------|
  String img64User = AppCubit().imgProfile.img;
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

  pickerCamera(context) async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      cropImage().then((value) async {
        await _uploadImageProfile(File(photo!.path) , context ).then((value){
          putImage(fileToken ,context).then((value){
            final bytes = File(photo!.path).readAsBytesSync();
            String img64 = base64Encode(bytes);
            img64User = img64;
            getUserImage(context);
          });
          emit(SetImageState());

        }).catchError((err){
          if (kDebugMode) {
            print(err.toString());
          }
        });

      });
      emit(SetImageState());
    } else {
      return;
    }
  }

  img64UserCache() async {
    await SharedPreferences.getInstance().then((value) {
      img64User = value.getString(PrefsKey.img64) ?? "assets/avatar.png";
    });
  }
  //put image 
  Future putImage(String fileToken , context )async {
    await DioFactory(token).updateData("api/services/app/Profile/UpdateProfilePicture", {
      "fileToken": fileToken,
    }).then((value){
      if (kDebugMode) {
        print("success when put img :: "+value.data.toString());
      }
      getUserImage(context).then((value) => null);
   }).catchError((err){
      if (kDebugMode) {
        print("err when put img :: "+err.toString());
      }
    });

  }
  
  
// ------------ update profile  ---------------|

  putUpdateProfile(
      {required BuildContext context,
      required String email,
      required String name,
      required String phone}) {
    String newToken = token ;
    DioFactory(newToken).updateData(ApiEndPoint.updateProfile, {
      "emailAddress": email,
      "name": name,
      "surname": name,
      "userName": email,
      "phoneNumber": phone,
      //TODO:ADD CITY
    }).then((value) {
      if (value.statusCode == 200) {
        AppCubit.get(context).getProfileDetails(context );
      }
    });
  }





// ------------ get image profile  ---------------|


  ImgProfile imgProfile = ImgProfile(img: "assets/avatar.png");
  Future  getUserImage(context)async{
      await DioFactory(token).getData(ApiEndPoint.getUserImage, {}).then((value) {
        if(value.data["result"]["profilePicture"] !=""){
          SharedPreferences.getInstance().then((prefs){
            prefs.setString(PrefsKey.img64, value.data["result"]["profilePicture"]);
          });
          imgProfile = ImgProfile(img: value.data["result"]["profilePicture"].toString());
          AppCubit.get(context).getUserImage().then((value) => null);
        }
        emit(GetImageState());
      }).catchError((err){
        if(kDebugMode){
          print("error when get profile image ::: \n  " + err.toString() , );
        }
        emit(GetImageError());
      });
  }


// ------------ upload image profile  ---------------|

   String fileToken = "";
  Future  _uploadImageProfile(File file , BuildContext context ) async {
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    AppToasts.toastLoading("جاري رفع الصورة");
    await DioFactory(token).dio().post(ApiEndPoint.uploadImage, data: data)
        .then((response){
      if (kDebugMode) {
        print(response.data.toString());
      }
      fileToken = response.data["result"]["fileToken"];
      AppToasts.toastSuccess("تم رفع الصورة");
      emit(UploadSuccess());
    }).catchError((error){
      AppToasts.toastError(kDebugMode ? error.toString() :  "حدث خطأ ما حاول لاحقا !");
      emit(UploadSuccess());
    });
  }


}
