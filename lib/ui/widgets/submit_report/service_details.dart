import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return  TextField(
      enabled: true,
      textInputAction: TextInputAction.done,
      maxLines: 6,
      decoration: InputDecoration(
            hintText: 'Service Details',
            hintStyle: const TextStyle(
                color: Colors.black45,
                fontFamily: AssetConstants.poppinsRegular),
            contentPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeHorizontal * 5, horizontal: 12),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
                borderSide: const BorderSide(
                  color: Colors.black,
                )),
          ),
    );
  }
}
