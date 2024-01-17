import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstantProduct extends StatefulWidget {
  const InstantProduct({
    super.key,
    this.serviceController,
    this.productController,
    this.priceController,
  });
  final TextEditingController? serviceController,
      productController,
      priceController;
  @override
  State<InstantProduct> createState() => _InstantProductState();
}

class _InstantProductState extends State<InstantProduct> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitTabBloc, SubmitTabState>(
      builder: (context, state) {
        isChecked = state.isChecked;
        if (isChecked == false) {
          widget.priceController!.clear();
        }
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: widget.productController,
                    enabled: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter replaced spare part name',
                      hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontFamily: AssetConstants.poppinsRegular),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 5,
                          horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 1),
                          borderSide: const BorderSide(
                            color: Colors.black45,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 1),
                          borderSide: const BorderSide(
                            color: ColorConstants.primaryColor,
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 5,
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: Flexible(
                    flex: 1,
                    child: TextField(
                      controller: widget.priceController,
                      enabled: true,
                      keyboardType: defaultTargetPlatform == TargetPlatform.iOS
                          ? const TextInputType.numberWithOptions(
                              decimal: true, signed: true)
                          : TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Price',
                        hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontFamily: AssetConstants.poppinsRegular),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeHorizontal * 5,
                            horizontal: SizeConfig.blockSizeHorizontal * 3),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 1),
                            borderSide: const BorderSide(
                              color: Colors.black45,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 1),
                            borderSide: const BorderSide(
                              color: ColorConstants.primaryColor,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 3,
            ),
            Row(
              children: [
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 2.5), //SizedBox
                /** Checkbox Widget **/
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    context
                        .read<SubmitTabBloc>()
                        .add(CheckET(isChecked: value!));

                    //setState(() {
                    //  isChecked = value!;
                    // });
                  },
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 2,
                ), //SizedBox
                const Text(
                  'Paid replacement',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: AssetConstants.poppinsRegular),
                ), //Text
                //Checkbox
              ], //<Widget>[]
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 3,
            ),
            ServiceDetails(
              controller: widget.serviceController!,
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 20,
            ),
          ],
        );
      },
    );
  }
}
