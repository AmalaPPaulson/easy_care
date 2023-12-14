import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

class InstantProduct extends StatefulWidget {
  const InstantProduct({super.key});

  @override
  State<InstantProduct> createState() => _InstantProductState();
}

class _InstantProductState extends State<InstantProduct> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 25,
              child: TextField(
                enabled: true,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter replaced sparepart name',
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
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 3,
            ),
            Visibility(
              visible:isChecked,
              child: TextField(
                enabled: true,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Price',
                  contentPadding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeHorizontal * 5,
                      horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 1),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )),
                ),
              ),
            )
          ],
        ),
        CheckboxListTile(
          title: const Text('Paid Replacement'),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        const ServiceDetails(),
      ],
    );
  }
}
