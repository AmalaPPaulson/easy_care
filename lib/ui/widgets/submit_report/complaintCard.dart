import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key,
  required this.complaintOntap,
  required this.complaint,
  required this.isShow,
  });

  final Function() complaintOntap;
  final ComplaintResult complaint;
  final bool isShow;
  @override
  Widget build(BuildContext context) {
    List<String> complaintLines = complaint.complaint!.complaint!.split('\n');
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: complaintOntap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                    child: const Text(
                      'Complaint:',
                      style: TextStyle(fontFamily: AssetConstants.poppinsBold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                    child: Icon(
                      isShow ? Icons.expand_less : Icons.expand_more,
                      color: ColorConstants.blackColor,
                      size: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isShow,
                child: Divider(color: ColorConstants.backgroundColor2)),
            Visibility(
              visible: isShow,
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  shrinkWrap: true,
                  itemCount: complaintLines.length,
                  itemBuilder: (context, index) {
                    return Text(
                      complaintLines[index],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AssetConstants.poppinsMedium),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
