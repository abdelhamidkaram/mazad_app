import 'package:flutter/material.dart';
import 'package:soom/style/text_style.dart';

class TitleCategory extends StatelessWidget {
  final String  title ;
  final VoidCallback onPressed ;

  const TitleCategory({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {},
            child:  Text(
              title ,
              style: AppTextStyles.titleSmallBlack,
            )),
        const Spacer(),
        TextButton(
            onPressed: onPressed ,
            child: const Text("عرض الكل ",
                style: AppTextStyles.mediumBlue)),
      ],
    );
  }
}