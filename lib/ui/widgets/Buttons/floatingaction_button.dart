import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FloatingActionBtn extends StatelessWidget {
  const FloatingActionBtn({
    super.key,
    required this.onTap,
    required this.isPressed,
    required this.text,
  });
  final Function()? onTap;
  final String text;
  final bool isPressed;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            width: isPressed ? 46 : 250,
            height: 46,
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isPressed ? 70.0 : 30.0),
              color: (onTap==null)?Colors.grey:ColorConstants.buttonColor,
            ),
            duration: const Duration(milliseconds: 400),
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: isPressed == true ? 0.0 : 1.0,
                child: Text(
                 text,
                  style: TextStyle(
                    fontFamily: AssetConstants.poppinsSemiBold,
                    color: isPressed ? Colors.transparent : Colors.white,
                    fontSize: isPressed ? 0 : 15,
                  ),
                ),
              ),
            ),
          ),
        ),


        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: AnimatedContainer(
              width: isPressed ? 40 : 40,
              height: 40,
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isPressed ? 30.0 : 30.0)),
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isPressed == true ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SpinKitDoubleBounce(
                    color: isPressed ? Colors.white : ColorConstants.buttonColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
