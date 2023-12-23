import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
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
                    ),
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: const SizedBox(
                    width: 20.0,
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: Flexible(
                    flex: 1,
                    child: TextField(
                      controller: widget.priceController,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Price',
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(width: 10), //SizedBox
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
                const SizedBox(
                  width: 10,
                ), //SizedBox
                const Text(
                  'Paid replacement',
                  style: TextStyle(fontSize: 17.0),
                ), //Text
                //Checkbox
              ], //<Widget>[]
            ),
            ServiceDetails(
              controller: widget.serviceController!,
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        );
      },
    );
  }
}
