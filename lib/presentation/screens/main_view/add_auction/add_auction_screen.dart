import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/category/category_model.dart';
import 'package:soom/presentation/screens/main_view/add_auction/add_auction_progress.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_cubit.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class AddAuctionScreen extends StatefulWidget {
  const AddAuctionScreen({Key? key}) : super(key: key);

  @override
  State<AddAuctionScreen> createState() => _AddAuctionScreenState();
}

class _AddAuctionScreenState extends State<AddAuctionScreen> {
  @override
  Widget build(BuildContext context) {
    var addProductKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AddAuctionCubit(),
      child: BlocConsumer<AddAuctionCubit, AddAuctionStates>(
        listener: (context, state) => AddAuctionCubit(),
        builder: (context, state) {
          var cubit = AddAuctionCubit.get(context);
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
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: const [
                          Text(
                            "اسم المنتج ",
                            style: AppTextStyles.titleSmallBlack,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: cubit.nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل اسم المنتج  ";
                          } else {
                            return null;
                          }
                        },
                        decoration:  InputDecoration(
                          hintText: cubit.catController.text.isEmpty? "اسم المنتج هنا   " : cubit.catController.text,
                          border: const OutlineInputBorder(),
                          hintStyle: AppTextStyles.smallGrey,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap:  () {
                          showDialog(
                            context: context,
                            builder: (context){
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: ListView.separated(
                                        itemCount: cats.length,
                                        itemBuilder:(context, index) => InkWell(
                                          onTap: (){
                                            cubit.catController.text = cats[index].title.toString();
                                            cubit.categorySelected = cats[index] ;
                                            Navigator.pop(context);
                                          },
                                          child: Text(cats[index].title.toString() , style: AppTextStyles.mediumBlack,),
                                        ),
                                        separatorBuilder: (BuildContext context, int index) {
                                          return const Divider();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "اختر التصنيف ";
                            }
                            return null ;
                          },
                          controller: cubit.catController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabled: false,
                            hintText: "اختر التصنيف ",
                            prefixIcon: Icon(Icons.apps , color: ColorManger.primary,)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SwitchBetweenTowCheckBoxWidget(
                        getCheckTime: () {
                          cubit.getCheckTime();
                        },
                        isCheckTime: cubit.isCheckTime,
                        isCheckPrice: cubit.isCheckPrice,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Text(
                            "السعر ",
                            style: AppTextStyles.titleSmallBlack,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Text(
                            "أقل سعر ",
                            style: AppTextStyles.titleSmallBlack,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Text(
                            "السعر المستهدف ",
                            style: AppTextStyles.titleSmallBlack,
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                      const SizedBox(
                        height: 16,
                      ),
                      TimeTextFiledWidget(
                        dateController: cubit.dateController,
                        timeController: cubit.timeController,
                        isCheckTime: cubit.isCheckTime,
                        keyForm: addProductKey,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormFieldDetailsWidget(
                          detailsController: cubit.detailsController),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButtons.appButtonBlue(() {
                        if (addProductKey.currentState!.validate()) {
                          _replaceController();
                          cubit
                              .uploadProductDetails(state, context)
                              .then((value) {
                            if (state is UploadDetailsSuccess) {
                              cubit.dateController.clear();
                              cubit.nameController.clear();
                              cubit.targetPriceController.clear();
                              cubit.initialPriceController.clear();
                              cubit.minPriceController.clear();
                              cubit.detailsController.clear();
                              cubit.catController.clear();
                            }


                          });
                          if (cubit.customValidate(context)) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                              const AddAuctionProgress(),
                            ));
                          }
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
              validator: (value) {
                if (value!.isEmpty) {
                  return " ادخل تاريخ الانتهاء";
                } else {
                  return "";
                }
              },
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
          AddAuctionCubit.get(context).pickerCamera(
            widget.index,
            context
          );
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
        Row(
          children: const [
            Text(
              "التفاصيل ",
              style: AppTextStyles.titleSmallBlack,
            ),
            Spacer()
          ],
        ),
        const SizedBox(
          height: 16,
        ),
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
            AddAuctionCubit.get(context).pickerCamera(0 , context );
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
