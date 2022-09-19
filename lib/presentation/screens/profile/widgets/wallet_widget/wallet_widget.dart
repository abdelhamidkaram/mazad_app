
import 'package:flutter/material.dart';
import 'package:soom/style/text_style.dart';

class BalanceWidget extends StatefulWidget {
  final String  balance ;
  const BalanceWidget({Key? key, required this.balance}) : super(key: key);
  @override
  _BalanceWidgetState createState() => _BalanceWidgetState();
}
class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator BalanceWidget - GROUP
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
            width: double.infinity ,
            height: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient : LinearGradient(
                begin: Alignment(0.0901101678609848,0.9605768322944641),
                  end: Alignment(-0.9605768322944641,0.42025235295295715),
                colors: [Color.fromRGBO(93, 66, 198, 1),Color.fromRGBO(87, 113, 252, 1)]
                     ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text(" الرصيد المتوفر " , style: AppTextStyles.mediumWhite,) ,
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(" KW" , style: AppTextStyles.smallWhite,),
                      Text(widget.balance , style: AppTextStyles.titleWhite,),
                    ],
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
