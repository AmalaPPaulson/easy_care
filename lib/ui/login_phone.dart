import 'package:easy_care/blocs/login_bloc/login_bloc_bloc.dart';
import 'package:easy_care/ui/login_pin.dart';
import 'package:easy_care/ui/widgets/Buttons/login_button1.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  TextEditingController phoneNoController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<LoginBlocBloc, LoginBlocState>(
      listener: (context, state) {
        if (state is LoginSuccessST) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPin(
                        phoneNo: phoneNoController.text,
                      )));
        }
        if (state is LoginFailureST) {
          Fluttertoast.showToast(msg: state.errorMsg!);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Your Registered Mobile Number',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: AssetConstants.poppinsMedium,
                    fontSize: SizeConfig.blockSizeHorizontal * 4),
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black,
              fontSize: 17,
              fontFamily: AssetConstants.poppinsRegular,),
                  controller: phoneNoController,
                  enabled: true,
                  onChanged: (text) {
                    // phoneNo = phoneNoController.text;
                  },
                  keyboardType: defaultTargetPlatform == TargetPlatform.iOS
                      ? const TextInputType.numberWithOptions(
                          decimal: true, signed: true)
                      : TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeHorizontal * 5,
                        horizontal: 0.0),
                    filled: true,
                    fillColor: ColorConstants.backgroundColor2,
                    prefixIcon: Padding(
                      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
                      child: const Text(' +91',style: TextStyle(color: Colors.black,
              fontSize: 17,
              fontFamily: AssetConstants.poppinsRegular,),),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 4),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeHorizontal * 15,
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
                        context.read<LoginBlocBloc>().add(
                            LoginBtnPressET(phoneNo: phoneNoController.text));
                      },
                      isPressed: isPressed,
                      text: 'Login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
