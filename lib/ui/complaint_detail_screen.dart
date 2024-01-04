import 'dart:developer';

import 'package:easy_care/blocs/trip_bloc/trip_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/reachDestination_screen.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ComplaintDetail extends StatefulWidget {
  const ComplaintDetail({
    super.key,
  });

  @override
  State<ComplaintDetail> createState() => _ComplaintDetailState();
}

class _ComplaintDetailState extends State<ComplaintDetail> {
  ComplaintRepository complaintRepository = ComplaintRepository();
  UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();
    String phoneNO = complaint.complaint!.contactNumber.toString();
    log(phoneNO);
    List<String> complaintLines = complaint.complaint!.complaint!.split('\n');

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state.isLoading == false && state.started) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ReachDestination(),
              ),
              (Route<dynamic> route) => false);
        } else if (state.isLoading == false && state.errorMsg != null) {
          Fluttertoast.showToast(
              msg: '${state.errorMsg}',
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Complaint : ${complaint.complaint!.complaintId} ',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: AssetConstants.poppinsSemiBold,fontSize: 20),
          ),
        ),
        body: Padding(
          padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
          child: Column(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 2.5)),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Divider(color: ColorConstants.backgroundColor2),
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
                                    fontFamily: AssetConstants.poppinsSemiBold)),
                            GestureDetector(
                                onTap: () {
                                  complaintRepository.makePhoneCall(phoneNO);
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
                      )
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 2.5)),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: const Text(
                          'Complaint:',
                          style:
                              TextStyle(fontFamily: AssetConstants.poppinsBold),
                        ),
                      ),
                      const Divider(color: ColorConstants.backgroundColor2),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: ListView.separated(
                          physics:const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 2),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<TripBloc, TripState>(
          buildWhen: (previous, current) => (previous != current),
          builder: (context, state) {
            bool isPressed = false;
            if (state.isLoading) {
              isPressed = true;
            }
            return FloatingActionBtn(
                onTap: () {
                  context.read<TripBloc>().add(UpdateStatusET(
                        status: StringConstants.startTrip,
                        complaintId: complaint.id.toString(),
                      ));
                },
                isPressed: isPressed,
                text: 'Start');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
