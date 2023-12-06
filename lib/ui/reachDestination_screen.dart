import 'package:easy_care/blocs/trip_bloc/trip_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/start_service.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReachDestination extends StatefulWidget {
  const ReachDestination({super.key});

  @override
  State<ReachDestination> createState() => _ReachDestinationState();
}

class _ReachDestinationState extends State<ReachDestination> {
  UserRepository userRepository = UserRepository();
  ComplaintRepository complaintRepository = ComplaintRepository();

  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();
    String phoneNO = complaint.complaint!.contactNumber.toString();
    List<String> complaintLines = complaint.complaint!.complaint!.split('\n');

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state.reached == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StartService()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          leading: null,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Complaint : ${complaint.complaint!.complaintId.toString()}',
            style: const TextStyle(
                color: Colors.white, fontFamily: AssetConstants.poppinsMedium),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
          child: Column(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*2.5)),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: BlocBuilder<TripBloc, TripState>(
                    buildWhen: (previous, current) {
                      return current.card == false;
                    },
                    builder: (context, state) {
                      // bool isVisible = true;
                      // isVisible = state.isVisible;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 2),
                                child: const Text(
                                  'Customer Name & Address',
                                  style: TextStyle(
                                      fontFamily: AssetConstants.poppinsBold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                                child: InkWell(
                                  child: Icon(
                                    state.isVisible
                                        ? Icons.expand_less_rounded
                                        : Icons.expand_more,
                                    color: ColorConstants.blackColor,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                  ),
                                  onTap: () {
                                    context.read<TripBloc>().add(
                                        VisibilityET(visible: state.isVisible));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: ColorConstants.backgroundColor2),
                          Visibility(
                            visible: state.isVisible,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          complaint.complaint!.customerName
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontFamily:
                                                  AssetConstants.poppinsBold)),
                                      GestureDetector(
                                          onTap: () {
                                            complaintRepository
                                                .makePhoneCall(phoneNO);
                                          },
                                          child: const Icon(Icons.phone)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  child: Text(
                                      complaint.complaint!.houseName.toString(),
                                      style: const TextStyle(
                                          fontFamily:
                                              AssetConstants.poppinsSemiBold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  child: Text(
                                      'Contact Number: ${complaint.complaint!.contactNumber!.toString()}',
                                      style: const TextStyle(
                                          fontFamily:
                                              AssetConstants.poppinsSemiBold)),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5)),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: BlocBuilder<TripBloc, TripState>(
                    buildWhen: (previous, current) {
                      return (current.card == true);
                    },
                    builder: (context, state) {
                      // bool isShow =true;
                      //isShow = state.isShow;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 2),
                                child: const Text(
                                  'Complaint:',
                                  style: TextStyle(
                                      fontFamily:
                                          AssetConstants.poppinsSemiBold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                                child: InkWell(
                                  child: Icon(
                                    state.isShow
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: ColorConstants.blackColor,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                  ),
                                  onTap: () {
                                    context
                                        .read<TripBloc>()
                                        .add(ShowET(show: state.isShow));
                                  },
                                ),
                              )
                            ],
                          ),
                          const Divider(color: ColorConstants.backgroundColor2),
                          Visibility(
                            visible: state.isShow,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeHorizontal * 2),
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                    height: SizeConfig.blockSizeHorizontal * 2),
                                shrinkWrap: true,
                                itemCount: complaintLines.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    complaintLines[index],
                                    textAlign: TextAlign.start,
                                    style:  TextStyle(
                                        color: Colors.black,
                                        fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            AssetConstants.poppinsMedium),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                  context
                      .read<TripBloc>()
                      .add(TrackingET(id: complaint.id.toString()));
                },
                isPressed: isPressed,
                text: 'Reach Destination');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
    //bloc builder
  }
}
