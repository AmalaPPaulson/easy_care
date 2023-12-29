import 'dart:developer';

import 'package:easy_care/blocs/ActiveComplaints/bloc/active_complaints_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/complaint_detail_screen.dart';
import 'package:easy_care/ui/start_service.dart';
import 'package:easy_care/ui/submit_report.dart';
import 'package:easy_care/ui/widgets/custom_shimmer.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({super.key});

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  final ScrollController _scrollController = ScrollController();
  ComplaintRepository complaintRepository = ComplaintRepository();
  UserRepository userRepository = UserRepository();
  @override
  void initState() {
    context
        .read<ActiveComplaintsBloc>()
        .add(GetAcitveComplaintsET(isRefreshed: false));
    _scrollController.addListener(_loadMoreData);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      log('scroll extent');
      context.read<ActiveComplaintsBloc>().add(PagenatedActiveEvent());
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveComplaintsBloc, ActiveComplaintsState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return const CustomShimmerEffect();
        }
        if (state.errorMsg != null && state.errorMsg!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMsg!),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.activeComplaints?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: card(state.activeComplaints![index]),
                      onTap: () async {
                        userRepository
                            .setComplaint(state.activeComplaints![index])
                            .then((value) {
                          if (value) {
                            if (state.activeComplaints![index].status ==
                                'Assigned') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ComplaintDetail()));
                            } else if (state.activeComplaints![index].status ==
                                'Ongoing') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubmitReport()));
                            }else if(state.activeComplaints![index].status == 'In Travelling'){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StartService()));
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            if (state.isPageLoading)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeHorizontal * 10),
                child: const CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    context
        .read<ActiveComplaintsBloc>()
        .add(GetAcitveComplaintsET(isRefreshed: true));
    await Future.delayed(const Duration(seconds: 2));
  }

  Widget card(ComplaintResult result) {
    String phoneNO = result.complaint!.contactNumber.toString();
    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.5),
      child: Card(
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
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Row(
                  children: [
                    const Text(
                      'Complaint ID: ',
                      style:
                          TextStyle(fontFamily: AssetConstants.poppinsRegular),
                    ),
                    Text(
                      result.complaint!.complaintId.toString(),
                      style: const TextStyle(
                          fontFamily: AssetConstants.poppinsBold),
                    ),
                  ],
                ),
              ),
              const Divider(color: ColorConstants.backgroundColor2),
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      result.complaint!.customerName.toString().toUpperCase(),
                      style: const TextStyle(
                          fontFamily: AssetConstants.poppinsBold),
                    ),
                    GestureDetector(
                        onTap: () {
                          complaintRepository.makePhoneCall(phoneNO);
                        },
                        child: const Icon(Icons.phone)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Text(
                  result.complaint!.houseName.toString(),
                  style: const TextStyle(
                      fontFamily: AssetConstants.poppinsRegular),
                ),
              ),
              const Divider(color: ColorConstants.backgroundColor2),
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Text(
                  result.status.toString(),
                  style: const TextStyle(
                      color: ColorConstants.primaryColor,
                      fontFamily: AssetConstants.poppinsSemiBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
