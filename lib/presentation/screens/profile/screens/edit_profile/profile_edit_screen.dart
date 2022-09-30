import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/components/appbar/app_bar.dart';
import 'package:soom/presentation/components/buttons/buttons.dart';
import 'package:soom/presentation/screens/main_view/bloc/home_cubit.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/cubit.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/states.dart';
import 'package:soom/presentation/screens/profile/widgets/profile_edit_header.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';
import '../../../login/bloc/cubit.dart';

class ProfileEditScreen extends StatefulWidget {
  final ProfileEditSuccess profile;

  const ProfileEditScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCubit(),
      child: BlocConsumer<EditCubit, EditStates>(
          listener: (context, state) => EditCubit(),
          builder: (context, state) {
            var profile = AppCubit.get(context).profileEditSuccess;
            var formKey = GlobalKey<FormState>();
            var emailController = TextEditingController(
              text: profile.result?.emailAddress,
            );
            var phoneController = TextEditingController(
              text: profile.result?.phoneNumber,
            );
            var nameController = TextEditingController(
              text: profile.result?.name,
            );
            var cityController = TextEditingController(
              //Todo:City Controller
              text: profile.result?.name,
            );
            PhoneNumber number = PhoneNumber(isoCode: 'KW');
            var editCubit = EditCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: ColorManger.white,
                appBar: AppBars.appBarGeneral(
                  context,
                  HomeCubit.get(context),
                  "تعديل الملف الشخصي ",
                  cartView: false,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              editCubit.pickerCamera(context).then((_) {
                              });
                            },
                            // ignore: prefer_const_constructors
                            child: const ProfileEditHeader() ,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: const [
                              Text(
                                "تعديل المعلومات الشخصية",
                                style: AppTextStyles.titleSmallBlue_18,
                              ),
                              Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: const [
                              Text(
                                " الأسم  ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              Spacer()
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء إدخال الأسم';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorManger.primaryLight)),
                              prefixIcon: const Icon(Icons.person),
                              border: const OutlineInputBorder(),
                              hintText: profile.result?.name ?? "غير معروف ",
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: const [
                              Text(
                                "بريدك الالكتروني ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              Spacer()
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (value) {
                              return LoginCubit().emailValidation(value);
                            },
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText:
                                    profile.result?.emailAddress ?? "غير معروف",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorManger.primaryLight)),
                                prefixIcon: const Icon(Icons.email),
                                border: const OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: const [
                              Text(
                                "رقم الهاتف ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              Spacer()
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InternationalPhoneNumberInput(
                            textAlign: TextAlign.right,
                            searchBoxDecoration: const InputDecoration(
                                hintText: "البحث باسم الدولة ..."),
                            errorMessage: "رقم هاتف غير صالح",
                            inputDecoration: const InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorManger.primaryLight,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              prefixIcon: Icon(Icons.phone),
                              border: InputBorder.none,
                            ),
                            onInputChanged: (PhoneNumber number) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: phoneController,
                            formatInput: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: const [
                              Text(
                                "المدينة ",
                                style: AppTextStyles.mediumGrey,
                              ),
                              Spacer()
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء إدخال المدينة';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: cityController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorManger.primaryLight)),
                              prefixIcon: const Icon(Icons.person),
                              border: const OutlineInputBorder(),
                              //TODO: add city
                              hintText: profile.result?.name ?? "غير معروف ",
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          AppButtons.appButtonBlue(() {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                editCubit.putUpdateProfile(
                                  context: context,
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              });
                            }
                          }, "تعديل", true),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
