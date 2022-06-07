import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/cubit.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/bloc/states.dart';
import 'package:soom/presentation/screens/profile/widgets/avatar_img.dart';
import 'package:soom/style/text_style.dart';

class ProfileEditHeader extends StatefulWidget {
  const ProfileEditHeader({Key? key}) : super(key: key);
  @override
  State<ProfileEditHeader> createState() => _ProfileEditHeaderState();
}
class _ProfileEditHeaderState extends State<ProfileEditHeader> {
  @override
  Widget build(BuildContext context) {
    var editCubit = EditCubit.get(context);
    return BlocListener<EditCubit , EditStates>(
      listener: (context, state) => EditCubit(),
      child: Center(
        child: Column(
          children: [
            profileEditImage(
                image: editCubit.img64User.isEmpty
                    ? Image.asset("assets/logo.png")
                    : Image.memory(base64Decode(editCubit.img64User))),
            const SizedBox(height: 12 ,),
            const Text("تغيير الصورة الشخصية"  , style: AppTextStyles.smallBlue_12,)
          ],
        ),
      ),
    );
  }
}
