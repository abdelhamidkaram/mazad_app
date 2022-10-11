import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/extension.dart';
import 'package:soom/main.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import 'package:soom/repository/repository.dart';
import '../../../../../data/api/dio_factory.dart';
import '../../../../../style/color_manger.dart';
import '../../../category/category_model.dart';

class AddAuctionCubit extends Cubit<AddAuctionStates> {
  AddAuctionCubit() : super(InitAddAuctionState());

  static AddAuctionCubit get(context) => BlocProvider.of(context);
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

  cropImage(context, int index) async {
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
      _uploadImage(File(cropFile.path), context, index);
      emit(AddAuctionImgState());
    }
  }

  pickerCamera(int index, context) async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      cropImage(context, index).then((value) {

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

  CategoryModel categorySelected = CategoryModel(2, "img", "2ساعات");

  String timeSelected = "24ساعات";

  bool customValidate(context) {
    if (dateController.text.isEmpty) {
      AppToasts.toastError("يرجي ادخال تاريخ الانتهاء ");
      emit(CheckPriceFieldFormState());
      return false;
    } else if (
        timeController.text.isEmpty ||
        detailsController.text.isEmpty ||
        initialPriceController.text.isEmpty ||
        nameController.text.isEmpty ||
        nameController.text.isEmpty) {
      AppToasts.toastError("يرجي ملئ جميع الحقول ");
      emit(CheckPriceFieldFormState());
      return false;
    } else {
      emit(CheckPriceFieldFormState());
      return true;
    }
  }

//---------------- Check Box -------------|
  bool isCheckTime = true;

  bool isCheckPrice = false;

  getCheckTime() {
    isCheckTime = !isCheckTime;
    isCheckPrice = !isCheckTime;
    emit(AddAuctionCheckBoxState());
  }

//---------------- Check Box -------------|

  bool isUploadDetails = false;

  bool isUploadImages = false;

//---------------- upload product -------------|


//---------------- upload image  -------------|
  void _uploadImage(File file, BuildContext context, int index) async {
    if (file.size > 25.0) {
      AppToasts.toastError(
          "يجب ان لا يزيد حجم الصورة عن 25 ميجا بايت !");
      return null;
    }
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    await DioFactory( token)
        .dio()
        .post(ApiEndPoint.uploadImage, data: data ,

        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            print('progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
          }
          String pres = "${(sent / total * 100).toStringAsFixed(0)}%";
          EasyLoading.showProgress(
              sent / total,
            status: ((sent / total * 100 ) != 100) ? ("جاري رفع الصورة \n" + pres) : "تم الرفع وجاري المعالجة"
          );
        }
    )
        .then((response) async {
      if (kDebugMode) {
        print(response.data.toString() + "\n");
        print(fileName + "\n");
      }
      ImageObj imageObj = ImageObj(
        name: fileName,
        token: response.data["result"]["fileToken"],);
      _addImageToImagesObject(imageObj, index);
      _addImageToImg64(file, index);
      AppToasts.toastSuccess("تم رفع الصورة");
    }).catchError((error) async {
      AppToasts.toastError(kDebugMode ? error : "حدث خطأ ما حاول مرة أخري ! ");
    });
  }

  void _addImageToImg64(File file, int index) {
    final bytes = File(file.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    img[index] = img64;
    emit(AddImages64Success());
  }

  _addImageToImagesObject(ImageObj imageObj, int index) {
    if (imagesObj.isEmpty) {
      imagesObj.add(imageObj);
    } else {
      if (imagesObj.length >= index + 1) {
        imagesObj[index] = imageObj;
      } else {
        imagesObj.add(imageObj);
      }
    }
  }
}
class ImageObj {
  final String name;
  final String token;
  ImageObj({required this.name, required this.token});
}
