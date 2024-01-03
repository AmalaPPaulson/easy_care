import 'package:easy_care/blocs/completed/bloc/completed_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/ui/widgets/custom_shimmer.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final ScrollController _scrollController = ScrollController();
  ComplaintRepository complaintRepository = ComplaintRepository();

  @override
  void initState() {
    context.read<CompletedBloc>().add(GetCompletedET(isRefreshed: false));
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
      context.read<CompletedBloc>().add(PagenatedCompleteEvent());
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompletedBloc, CompletedState>(
      // buildWhen: (p, c) => c != p,
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
                  itemCount: state.completedComplaints?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return card(state.completedComplaints![index]);
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
    context.read<CompletedBloc>().add(GetCompletedET(isRefreshed: true));
    await Future.delayed(const Duration(seconds: 2));
  }

  Widget card(ComplaintResult result) {
    String phoneNO = result.complaint!.contactNumber.toString();
    String formattedDate = DateFormat('dd-MM-yyyy').format(result.updatedOn!);
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
                    const Spacer(),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontFamily: AssetConstants.poppinsRegular),
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
