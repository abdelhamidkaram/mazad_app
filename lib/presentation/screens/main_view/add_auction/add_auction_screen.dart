import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_cubit.dart';
import 'package:soom/presentation/screens/main_view/add_auction/bloc/add_auction_states.dart';
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
          _replaceController(){
            setState(() {
                cubit.priceController.text = cubit.priceController.text.replaceAll(",", "");
                cubit.priceController.text = cubit.priceController.text.replaceAll(".", "");
                cubit.priceController.text = cubit.priceController.text.replaceAll(" ", "");
                cubit.priceController.text = cubit.priceController.text.replaceAll("-", "");
            });
          }
          return SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
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
                        decoration: const InputDecoration(
                          hintText: "اسم المنتج هنا ",
                          border: OutlineInputBorder(),
                          hintStyle: AppTextStyles.smallGrey,
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
                        controller: cubit.priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: false , signed: false),
                        decoration: const InputDecoration(
                          hintText: " 5000 kw ",
                          border: OutlineInputBorder(),
                          hintStyle: AppTextStyles.smallGrey,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TimeTextFiledWidget(
                        dateController: cubit.dateController,
                        timeController: cubit.timeController,
                        isCheckTime: cubit.isCheckTime,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormFieldDetailsWidget(detailsController: cubit.detailsController),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButtons.appButtonBlue(() {
                         if(addProductKey.currentState!.validate()){
                           _replaceController();
                         }
                       if(cubit.customValidate(context)){
                         //TODO: ADD NEW PRODUCT TO SERVER
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

  const TimeTextFiledWidget(
      {Key? key,
      required this.dateController,
      required this.timeController,
      required this.isCheckTime})
      : super(key: key);

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
              "الوقت",
              style: AppTextStyles.titleSmallBlack,
            ),
            Spacer()
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.utc(
                      DateTime.now().year, DateTime.now().month + 1, 30),
                ).then((value) {
                  widget.dateController.text =
                      value.toString().substring(0, 10);
                });
              },
              child: SizedBox(
                width: 155,
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
                    if (widget.isCheckTime) {
                      if (value!.isEmpty) {
                        return " ادخل الوقت ";
                      }
                    } else {
                      return "";
                    }
                    return "";
                  },
                  enabled: false,
                  controller: widget.dateController,
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  widget.timeController.text = value!.format(context);
                });
              },
              child: SizedBox(
                width: 145,
                child: TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: "اختر الوقت",
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorManger.lightGrey)),
                    prefixIcon: Icon(
                      Icons.watch_later_outlined,
                      color: ColorManger.primary,
                    ),
                  ),
                  validator: (value) {
                    if (widget.isCheckTime) {
                      if (value!.isEmpty) {
                        return " ادخل الوقت";
                      }
                    } else {
                      return "";
                    }
                    return "";
                  },
                  controller: widget.timeController,
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
          ],
        ),
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
  const TextFormFieldDetailsWidget({Key? key, required this.detailsController}) : super(key: key);

  @override
  State<TextFormFieldDetailsWidget> createState() => _TextFormFieldDetailsWidgetState();
}

class _TextFormFieldDetailsWidgetState extends State<TextFormFieldDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
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

    ],);
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
            AddAuctionCubit.get(context).pickerCamera(0);
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

