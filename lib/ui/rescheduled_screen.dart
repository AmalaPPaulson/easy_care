import 'package:easy_care/blocs/rescheduled/bloc/rescheduled_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/ui/widgets/custom_shimmer.dart';
import 'package:easy_care/ui/widgets/noInternet.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RescheduledScreen extends StatefulWidget {
  const RescheduledScreen({super.key});

  @override
  State<RescheduledScreen> createState() => _RescheduledScreenState();
}

class _RescheduledScreenState extends State<RescheduledScreen> {
  final ScrollController _scrollController = ScrollController();
  ComplaintRepository complaintRepository = ComplaintRepository();

  @override
  void initState() {
    context.read<RescheduledBloc>().add(GetRescheduledET(isRefreshed: false));
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
      context.read<RescheduledBloc>().add(PagenatedRescheduledEvent());
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RescheduledBloc, RescheduledState>(
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
        if (state.isNoInternet) {
          return const NoInternetCard();
        }

        /// to list rescheduled complaints
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: state.rescheduledComplaints?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return card(state.rescheduledComplaints![index]);
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
    context.read<RescheduledBloc>().add(GetRescheduledET(isRefreshed: true));
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
            ],
          ),
        ),
      ),
    );
  }
}
