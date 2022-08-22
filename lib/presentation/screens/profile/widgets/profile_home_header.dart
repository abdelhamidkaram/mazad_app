import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/constants/api_constants.dart';
import 'package:soom/data/api/dio_factory.dart';
import 'package:soom/models/profile_detalis_success.dart';
import 'package:soom/presentation/app_bloc/app_cubit.dart';
import 'package:soom/presentation/app_bloc/app_states.dart';
import 'package:soom/presentation/screens/profile/screens/edit_profile/profile_edit_screen.dart';
import 'package:soom/presentation/screens/profile/widgets/profile_img.dart';
import 'package:soom/style/color_manger.dart';
import '../../../../style/text_style.dart';


class ProfileHomeHeader extends StatefulWidget {
  final ProfileEditSuccess profile;
  const ProfileHomeHeader( {Key? key, required this.profile}) : super(key: key);
  @override
  State<ProfileHomeHeader> createState() => _ProfileHomeHeaderState();
}

class _ProfileHomeHeaderState extends State<ProfileHomeHeader> {

  @override
  Widget build(BuildContext context) {
    //TODO:
    String _getImage(){
      //TODO: get image from server
      String response = "";
      DioFactory().getData(ApiEndPoint.getUserImage, {}).then((value) {
        if(value != null){
          response = value.toString();
        }else{
          response = "";
        }
      });
      return response;
    }
  return  BlocConsumer<AppCubit , AppStates>(
      listener:(context, state) =>  AppCubit(),
      builder: (context ,state ){
        return Container(
          padding: const EdgeInsets.only(top: 0 , bottom: 5 , right: 10, left: 10),
          child: Row(
            children: [
              //TODO: IMAGE PROFILE FORM SERVER
              const ProfileImage(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png"),
              const SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(AppCubit.get(context).profileEditSuccess.result?.name ?? "غير معروف " , style: AppTextStyles.titleBlack,),
                    Text(AppCubit.get(context).profileEditSuccess.result?.emailAddress ?? "example@email.com" , style: AppTextStyles.smallGrey, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileEditScreen(profile: widget.profile),));
              }, icon: const  Icon(Icons.settings , color: ColorManger.grey,))
            ],
          ),
        ) ;
      },
    );
  }
}
