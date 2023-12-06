import 'dart:async';

import 'package:easy_care/blocs/login_bloc/login_bloc_bloc.dart';
import 'package:easy_care/ui/home_screen.dart';
import 'package:easy_care/ui/widgets/Buttons/login_button1.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPin extends StatefulWidget {
  final String? phoneNo;
  const LoginPin({super.key, required this.phoneNo});

  @override
  State<LoginPin> createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<LoginBlocBloc, LoginBlocState>(
      listener: (context, state) {
        if (state is LoginSuccessST) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => const HomeScreen()), (Route route) => false);
        }
        if (state is LoginFailureST) {
          Fluttertoast.showToast(msg: state.errorMsg!);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Please enter your',
                    style: TextStyle(
                      color: ColorConstants.blackColor,
                      fontFamily: AssetConstants.poppinsRegular,
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    children: [
                      TextSpan(
                        text: ' Security Pin ',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontFamily: AssetConstants.poppinsRegular,
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                        ),
                      ),
                      TextSpan(
                        text: 'Number for ',
                        style: TextStyle(
                          color: ColorConstants.blackColor,
                          fontFamily: AssetConstants.poppinsRegular,
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 5,
                ),
                Text(
                  '${widget.phoneNo}',
                  style: TextStyle(
                    color: ColorConstants.primaryColor,
                    fontFamily: AssetConstants.poppinsBold,
                    fontSize: SizeConfig.blockSizeHorizontal * 6,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 10,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeHorizontal * 4,
                      horizontal: SizeConfig.blockSizeHorizontal * 15,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        color: ColorConstants.backgroundColor2,
                        fontFamily: AssetConstants.poppinsBold,
                      ),
                      length: 4,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        activeColor: ColorConstants.backgroundColor2,
                        inactiveColor: ColorConstants.backgroundColor2,
                        selectedColor: ColorConstants.backgroundColor2,
                        disabledColor: ColorConstants.backgroundColor2,
                        inactiveFillColor: ColorConstants.backgroundColor2,
                        selectedFillColor: ColorConstants.backgroundColor2,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 1.5),
                        fieldHeight: SizeConfig.blockSizeHorizontal * 12.5,
                        fieldWidth: SizeConfig.blockSizeHorizontal * 10,
                        activeFillColor: ColorConstants.backgroundColor2,
                      ),
                      cursorColor: Colors.white,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      
                      
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 10,
                ),
                BlocBuilder<LoginBlocBloc, LoginBlocState>(
                  buildWhen: (previous, current) => (previous != current),
                  builder: (context, state) {
                    bool isPressed = false;
                    if (state is LoginPageLoadingST) {
                      isPressed = true;
                    }
                    return LoginButton1(
                        onTap: () {
                          context.read<LoginBlocBloc>().add(VerifyPinET(
                              phoneNo: widget.phoneNo,
                              pin: textEditingController.text));
                        },
                        isPressed: isPressed,
                        text: 'Verify Pin');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
