import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Image(
          height: SizeConfig.blockSizeHorizontal*50,
          width: SizeConfig.blockSizeHorizontal*50,
          image: const AssetImage(AssetConstants.appLogo),
        ),
      ),
    );
  }
}