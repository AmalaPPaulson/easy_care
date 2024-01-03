import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.complaint,
    required this.customerOnTap,
    required this.isVisible,
  });

  final ComplaintResult complaint;
  final Function() customerOnTap;
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    ComplaintRepository complaintRepository = ComplaintRepository();
    return Column(
      children: [
        Card(
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
                  onTap: customerOnTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: const Text(
                          'Customer Name & Address',
                          style:
                              TextStyle(fontFamily: AssetConstants.poppinsBold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Icon(
                          isVisible
                              ? Icons.expand_less_rounded
                              : Icons.expand_more,
                          color: ColorConstants.blackColor,
                          size: SizeConfig.blockSizeHorizontal * 5,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: isVisible,
                    child: const Divider(color: ColorConstants.backgroundColor2)),
                Visibility(
                  visible: isVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                complaint.complaint!.customerName
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontFamily: AssetConstants.poppinsBold)),
                            GestureDetector(
                                onTap: () {
                                  complaintRepository.makePhoneCall(complaint
                                      .complaint!.contactNumber
                                      .toString());
                                },
                                child: const Icon(Icons.phone)),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(complaint.complaint!.houseName.toString(),
                            style: const TextStyle(
                                fontFamily: AssetConstants.poppinsSemiBold)),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                            'Contact Number: ${complaint.complaint!.contactNumber!.toString()}',
                            style: const TextStyle(
                                fontFamily: AssetConstants.poppinsBold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
