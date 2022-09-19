import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/components/toast.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_cubit.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

import '../../../../data/cache/prefs.dart';
import '../../../../main.dart';

class AddAuctionScreen extends StatefulWidget {
  const AddAuctionScreen({Key? key}) : super(key: key);

  @override
  State<AddAuctionScreen> createState() => _AddAuctionScreenState();
}

class _AddAuctionScreenState extends State<AddAuctionScreen> {
  List<String> buildClockList() {
    return List.generate(24, (int num) {
      String clock = "ساعة";
      if ((num+1) >= 3 && (num+1) <= 10) {
        clock = "ساعات";
        return (num+1) == 10 ?  (num+1).toString() + clock : "0" + (num+1).toString() + clock ;
      } else {
        if ((num+1) == 2) {
          return "ساعتين";
        }
        if ((num+1) == 1) {
          return clock;
        }
      }
      return (num+1).toString() + clock;
    });
  }

  InkWell popUpItemBuilder(AddAuctionCubit cubit, List<String> list, int index,
      BuildContext context) {
    return InkWell(
      onTap: () {
        cubit.dateController.text = list[index];
        cubit.timeSelected = list[index];
        Navigator.pop(context);
      },
      child: Text(
        list[index],
        style: AppTextStyles.mediumBlack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var addProductKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AddAuctionCubit(),
      child: BlocConsumer<AddAuctionCubit, AddAuctionStates>(
        listener: (context, state) => AddAuctionCubit(),
        builder: (context, state) {
          var cubit = AddAuctionCubit.get(context);
          if (cubit.catController.text.isEmpty) {
            cubit.catController.text =
                HomeCubit.get(context).categories[0].title.toString();
          }
          if (cubit.dateController.text.isEmpty) {
            cubit.dateController.text =
                cubit.timeSelected;
          }
          List<CategoryModel> cats = HomeCubit.get(context).categories;

          _replaceController() {
            setState(() {
              cubit.initialPriceController.text =
                  cubit.initialPriceController.text.replaceAll(",", "");
              cubit.initialPriceController.text =
                  cubit.initialPriceController.text.replaceAll(".", "");
              cubit.initialPriceController.text =
                  cubit.initialPriceController.text.replaceAll(" ", "");
              cubit.initialPriceController.text =
                  cubit.initialPriceController.text.replaceAll("-", "");
            });
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 24.0),
                child: Form(
                  key: addProductKey,
                  child: Column(
                    children: [
                      AddProductImages(cubit: cubit),
                      const CustomFieldTitle(title:    "اسم المنتج "),
                      TextFormField(
                        controller: cubit.nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل اسم المنتج  ";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: cubit.nameController.text.isEmpty
                              ? "اسم المنتج هنا   "
                              : cubit.nameController.text,
                          border: const OutlineInputBorder(),
                          hintStyle: AppTextStyles.smallGrey,
                        ),
                      ),
                      const CustomFieldTitle(title:    "التصنيف "),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: ListView.separated(
                                          itemCount: cats.length,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () {
                                              cubit.catController.text =
                                                  cats[index].title.toString();
                                              cubit.categorySelected =
                                                  cats[index];
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              cats[index].title.toString(),
                                              style: AppTextStyles.mediumBlack,
                                            ),
                                          ),
                                          separatorBuilder:
                                              (BuildContext context, int index) {
                                            return const Divider();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "اختر التصنيف ";
                            }
                            return null;
                          },
                          controller: cubit.catController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabled: false,
                              hintText: "اختر التصنيف ",
                              prefixIcon: Icon(
                                Icons.apps,
                                color: ColorManger.primary,
                              )),
                        ),
                      ),
                      const CustomFieldTitle(title:    "السعر"),
                      TextFormField(
                        controller: cubit.initialPriceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        decoration: const InputDecoration(
                          hintText: " 5000 kw ",
                          border: OutlineInputBorder(),
                          hintStyle: AppTextStyles.smallGrey,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "يرجي ادخال السعر";
                          }
                          return null;
                        },
                      ),
                      const CustomFieldTitle(title:    "أقل سعر"),
                      TextFormField(
                          controller: cubit.minPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          decoration: const InputDecoration(
                            hintText: " 5000 kw ",
                            border: OutlineInputBorder(),
                            hintStyle: AppTextStyles.smallGrey,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يرجي ادخال السعر";
                            }
                            return null;
                          }),
                      const CustomFieldTitle(title:    "السعر المستهدف"),
                      TextFormField(
                          controller: cubit.targetPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          decoration: const InputDecoration(
                            hintText: " 5000 kw ",
                            border: OutlineInputBorder(),
                            hintStyle: AppTextStyles.smallGrey,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يرجي ادخال السعر";
                            }
                            return null;
                          }),
                      const CustomFieldTitle(title:    "وقت المزاد"),
                      GestureDetector(
                        onTap: () {
                          showDialog(

                            context: context,
                            builder: (context) {
                              List<String> num = buildClockList();
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: ListView.separated(
                                          itemCount: num.length,
                                          itemBuilder: (context, index) =>
                                              popUpItemBuilder(
                                                  cubit, num, index, context),
                                          separatorBuilder:
                                              (BuildContext context, int index) {
                                            return const Divider();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "اختر وقت انتهاء المزاد";
                            }
                            return null;
                          },
                          controller: cubit.dateController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabled: false,
                              hintText: "اختر وقت الانتهاء ",
                              prefixIcon: Icon(
                                Icons.watch_later_outlined,
                                color: ColorManger.primary,
                              )),
                        ),
                      ),
                      TextFormFieldDetailsWidget(
                          detailsController: cubit.detailsController),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButtons.appButtonBlue(() {
                        if (addProductKey.currentState!.validate()) {
                          _replaceController();
                          AppToasts.toastLoading(context);
                          String newToken = token;
                          String endDate =
                          cubit.dateController.text == "ساعة" ?
                          //2022-09-10 18:58:51.572
                          DateTime.now().add(const Duration(hours: 1)).toString()
                              :
                          cubit.dateController.text == "ساعتين" ?
                          DateTime.now().add(const Duration(hours: 2)).toString()
                              :

                          DateTime.now().add(
                            Duration(hours:int.parse(cubit.dateController.text.substring(0,2))),
                          ).toString();
                          DioFactory(newToken)
                              .postData(ApiEndPoint.uploadProducts, {
                            "name": cubit.nameController.text,
                            "descrption": cubit.detailsController.text,
                            "intitalPrice": int.parse(cubit
                                    .initialPriceController.text
                                    .toString())
                                .toDouble(),
                            "minPrice": int.parse(
                                    cubit.minPriceController.text.toString())
                                .toDouble(),
                            //2022-09-12T14:54:18.065297Z
                            "endDate":endDate.substring(0,10)+"T"+endDate.substring(11)+"Z",
                            "status": 0,
                            "targetPrice": int.parse(
                                    cubit.targetPriceController.text.toString())
                                .toDouble(),
                            "categoryId": cubit.categorySelected.index,
                          }).then((value) {
                            if (kDebugMode) {
                              print("++++++++${value.toString()}+++++++++");
                            }
                            Navigator.pop(context);
                            AppToasts.toastSuccess("تم رفع المنتج ", context);
                          }).catchError((err) {
                            if (kDebugMode) {
                              print("++++++++++++ errr +++++");
                            }
                            Navigator.pop(context);
                            AppToasts.toastError(
                                "حدث خطأ ما .. حاول لاحقا", context);
                          });
                        }
                      }, "إضافة المنتج ", true),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}

class CustomFieldTitle extends StatelessWidget {
  final String title ;
  const CustomFieldTitle({
    Key? key,
    required this.title ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          children:  [
            Text(
              title,
              style: AppTextStyles.titleSmallBlack,
            ),
            const Spacer()
          ],
        ),
        const SizedBox(
          height: 16,
        ),

      ],
    );
  }
}

class SwitchBetweenTowCheckBoxWidget extends StatefulWidget {
  final Function getCheckTime;

  final bool isCheckTime;
  final bool isCheckPrice;

  const SwitchBetweenTowCheckBoxWidget(
      {Key? key,
      required this.getCheckTime,
      required this.isCheckTime,
      required this.isCheckPrice})
      : super(key: key);

  @override
  State<SwitchBetweenTowCheckBoxWidget> createState() =>
      _SwitchBetweenTowCheckBoxWidgetState();
}

class _SwitchBetweenTowCheckBoxWidgetState
    extends State<SwitchBetweenTowCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "المزايدة على ؟ ",
              style: AppTextStyles.titleSmallBlack,
            ),
            Spacer()
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.getCheckTime();
                  },
                  icon: Icon(
                    !widget.isCheckTime
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                    color: ColorManger.primary,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "الوقت ",
                  style: AppTextStyles.smallBlack,
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.getCheckTime();
                  },
                  icon: Icon(
                    !widget.isCheckPrice
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                    color: ColorManger.primary,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "السعر ",
                  style: AppTextStyles.smallBlack,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

//-------------------------------------------------2

class TimeTextFiledWidget extends StatefulWidget {
  final TextEditingController dateController;

  final TextEditingController timeController;

  final bool isCheckTime;

  final GlobalKey keyForm;

  const TimeTextFiledWidget({
    Key? key,
    required this.dateController,
    required this.timeController,
    required this.isCheckTime,
    required this.keyForm,
  }) : super(key: key);

  @override
  State<TimeTextFiledWidget> createState() => _TimeTextFiledWidgetState();
}

class _TimeTextFiledWidgetState extends State<TimeTextFiledWidget> {
  @override
  void initState() {
    if (widget.dateController.text.isEmpty) {
      widget.dateController.text = DateTime.now()
          .add(const Duration(days: 10))
          .toString()
          .substring(0, 10);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "تاريخ الانتهاء",
              style: AppTextStyles.titleSmallBlack,
            ),
            Spacer()
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(
                  DateTime.now().year, DateTime.now().month + 10, 30),
            ).then((value) {
              if (value == null && widget.dateController.text.isEmpty) {
                widget.dateController.text = DateTime.now()
                    .add(const Duration(days: 5))
                    .toString()
                    .substring(0, 10);
              }
              widget.dateController.text = value.toString().substring(0, 10);
            });
          },
          child: SizedBox(
            width: double.infinity,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "اختر التاريخ ",
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorManger.lightGrey)),
                prefixIcon: Icon(
                  Icons.calendar_month_sharp,
                  color: ColorManger.primary,
                ),
              ),
              autofocus: false,
              enabled: false,
              controller: widget.dateController,
              keyboardType: TextInputType.datetime,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

//-------------------------------------------------3

class SmallImgProductItem extends StatefulWidget {
  final int index;

  final AddAuctionCubit cubit;

  const SmallImgProductItem(
      {Key? key, required this.index, required this.cubit})
      : super(key: key);

  @override
  State<SmallImgProductItem> createState() => _SmallImgProductItemState();
}

class _SmallImgProductItemState extends State<SmallImgProductItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          AddAuctionCubit.get(context).pickerCamera(widget.index, context);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 60,
          height: 60,
          decoration: DottedDecoration(shape: Shape.box),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: widget.cubit.img[widget.index].isEmpty
                ? SvgPicture.asset("assets/addimgsmall.svg")
                : Image.memory(base64Decode(widget.cubit.img[widget.index])),
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------------4
class TextFormFieldDetailsWidget extends StatefulWidget {
  final TextEditingController detailsController;

  const TextFormFieldDetailsWidget({Key? key, required this.detailsController})
      : super(key: key);

  @override
  State<TextFormFieldDetailsWidget> createState() =>
      _TextFormFieldDetailsWidgetState();
}

class _TextFormFieldDetailsWidgetState
    extends State<TextFormFieldDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomFieldTitle(title:    "التفاصيل"),
        TextFormField(
          controller: widget.detailsController,
          maxLines: 10,
          validator: (value) {
            if (value!.isEmpty) {
              return "ادخل تفاصيل لمنتج  ";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            hintText: "يمكنك كتابة التفاصيل هنا ",
            border: OutlineInputBorder(),
            hintStyle: AppTextStyles.smallGrey,
          ),
        ),
      ],
    );
  }
}

//--------------------------------------------------5

class AddProductImages extends StatefulWidget {
  final AddAuctionCubit cubit;

  const AddProductImages({Key? key, required this.cubit}) : super(key: key);

  @override
  State<AddProductImages> createState() => _AddProductImagesState();
}

class _AddProductImagesState extends State<AddProductImages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            AddAuctionCubit.get(context).pickerCamera(0, context);
          },
          child: Container(
            width: double.infinity,
            height: 190,
            decoration: DottedDecoration(shape: Shape.box),
            child: widget.cubit.img[0].isEmpty
                ? Center(
                    child: SvgPicture.asset("assets/addimgbig.svg"),
                  )
                : Image.memory(
                    base64Decode(widget.cubit.img[0]),
                  ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          children: [
            SmallImgProductItem(
              index: 1,
              cubit: widget.cubit,
            ),
            SmallImgProductItem(
              index: 2,
              cubit: widget.cubit,
            ),
            SmallImgProductItem(
              index: 3,
              cubit: widget.cubit,
            ),
            SmallImgProductItem(
              index: 4,
              cubit: widget.cubit,
            ),
          ],
        ),
      ],
    );
  }
}
