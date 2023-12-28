import 'dart:developer';

import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/blocs/submit_visible/bloc/submit_visible_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/success_screen.dart';
import 'package:easy_care/ui/tabTitletile.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_product.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_service.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_spare.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitReport extends StatefulWidget {
  const SubmitReport({super.key});

  @override
  State<SubmitReport> createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
  UserRepository userRepository = UserRepository();
  bool isShow = true;
  bool isVisible = true;
  ComplaintRepository complaintRepository = ComplaintRepository();

  TextEditingController serviceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sparePartController = TextEditingController();

  bool tab = true;
  int currentTab = 0;
  int selectedOption = 1;
  int option = 1;
  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();

    return BlocListener<SubmitTabBloc, SubmitTabState>(
      listener: (context, state) {
        if (state.isLoading == false &&state.started) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          leading: null,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Complaint Id : ${complaint.complaint!.complaintId.toString()}  ',
            style: const TextStyle(
                color: Colors.white, fontFamily: AssetConstants.poppinsMedium),
          ),
        ),
        body: createBody(complaint),
        floatingActionButton: BlocBuilder<SubmitTabBloc, SubmitTabState>(
          builder: (context, state) {
            bool isPressed = false;
            if (state.isLoading) {
              isPressed = true;
            }
            return FloatingActionBtn(
                onTap: () {
                  log(serviceController.text);
                  context.read<SubmitTabBloc>().add(SubmitReportET(
                      serviceText: serviceController.text,
                      id: complaint.id.toString(),
                      spareName: sparePartController.text,
                      price: priceController.text));
                },
                isPressed: isPressed,
                text: 'Submit Report');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget createBody(ComplaintResult complaint) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*3),
        child: Column(
          children: [
            card(complaint),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*8,
            ),
            BlocBuilder<SubmitTabBloc, SubmitTabState>(
              builder: (context, state) {
                if (state.currentTab != null) {
                  currentTab = state.currentTab!;
                }
                if (state.selectedOption != null) {
                  selectedOption = state.selectedOption!;
                }
                return Column(
                  children: [
                    tabContainer(currentTab, selectedOption),
                     SizedBox(
                      height: SizeConfig.blockSizeHorizontal*8,
                    ),
                    if (currentTab == 1)
                      ServiceDetails(
                        controller: serviceController,
                      ),
                    if (currentTab == 0)
                      switch (selectedOption) {
                        1 => InstantService(
                            instantServiceController: serviceController,
                          ),
                        2 => InstantSpare(
                            spareServiceController: serviceController,
                            spareController: sparePartController,
                            sparePriceController: priceController,
                          ),
                        _ => InstantProduct(
                            serviceController: serviceController,
                            priceController: priceController,
                            productController: sparePartController,
                          ),
                      },
                      SizedBox(
                      height: SizeConfig.blockSizeHorizontal*20,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tabContainer(int currentTab, int selectedOption) {
    return DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
            border: Border.all(
              color: Colors.black,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tabTitle(currentTab),
            tab == true ? tabOne(selectedOption) : tabTwo(),
          ],
        ));
  }

  Widget tabTitle(int currentTab) {
    return Padding(
      padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*1),
      child: Container(
        height: SizeConfig.blockSizeHorizontal * 15,
        width: MediaQuery.of(context).size.width,
        color: ColorConstants.backgroundColor1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: TabTitleTile(
                width: MediaQuery.of(context).size.width,
                currentTab: currentTab,
                onPressed: () {
                  tab = true;
                  context.read<SubmitTabBloc>().add(TabClickET(tabNo: 0));
                },
                title: 'Instant',
                tabNo: 0,
                borderRadiusGeometry: (currentTab == 0)
                    ?  BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeHorizontal*1.5))
                    : (currentTab == 1)
                        ?  BorderRadius.only(
                            bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal*1.5))
                        : BorderRadius.circular(0),
                color2: (currentTab == 0)
                    ? ColorConstants.backgroundColor1
                    : ColorConstants.backgroundColor2,
              ),
            ),
            Flexible(
              child: TabTitleTile(
                width: MediaQuery.of(context).size.width,
                title: 'Rescheduled',
                tabNo: 1,
                currentTab: currentTab,
                color2: (currentTab == 1)
                    ? ColorConstants.backgroundColor1
                    : ColorConstants.backgroundColor2,
                borderRadiusGeometry: (currentTab == 0)
                    ?  BorderRadius.only(bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*2))
                    : (currentTab == 1)
                        ?  BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.blockSizeHorizontal*2),
                            topRight: Radius.circular(SizeConfig.blockSizeHorizontal*2))
                        :  BorderRadius.only(
                            bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal*2)),
                onPressed: () {
                  tab = false;
                  context.read<SubmitTabBloc>().add(TabClickET(tabNo: 1));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabOne(int selectedOption) {
    return Column(
      children: [
        ListTile(
          title: const Text('Service'),
          leading: Radio(
            value: 1,
            groupValue: selectedOption,
            onChanged: (value) {
              context
                  .read<SubmitTabBloc>()
                  .add(RadialBtnClickET(value: value!));
              serviceController.clear();
              priceController.clear();
              sparePartController.clear();
            },
          ),
        ),
        ListTile(
          title: const Text('Spare Replacement'),
          leading: Radio(
            value: 2,
            groupValue: selectedOption,
            onChanged: (value) {
              context
                  .read<SubmitTabBloc>()
                  .add(RadialBtnClickET(value: value!));
                   serviceController.clear();
              priceController.clear();
              sparePartController.clear();
            },
          ),
        ),
        ListTile(
          title: const Text('Product Replacement'),
          leading: Radio(
            value: 3,
            groupValue: selectedOption,
            onChanged: (value) {
              context
                  .read<SubmitTabBloc>()
                  .add(RadialBtnClickET(value: value!));
                   serviceController.clear();
              priceController.clear();
              sparePartController.clear();
            },
          ),
        ),
      ],
    );
  }

  Widget tabTwo() {
    return Column(
      children: [
        ListTile(
          title: const Text('Assign to another technician'),
          leading: Radio(
            value: 1,
            groupValue: option,
            onChanged: (value) {
              option = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget card(ComplaintResult complaint) {
    String phoneNO = complaint.complaint!.contactNumber.toString();
    List<String> complaintLines = complaint.complaint!.complaint!.split('\n');
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
            child: BlocBuilder<SubmitVisibleBloc, SubmitVisibleState>(
              buildWhen: (previous, current) {
                return current.card == false;
              },
              builder: (context, state) {
                isVisible = state.isVisible;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Row(
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
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
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
                      onTap: () {
                        context.read<SubmitVisibleBloc>().add(VisibilityET(
                              visible: isVisible,
                            ));
                      },
                    ),
                    const Divider(color: ColorConstants.backgroundColor2),
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 4,
        ),
        Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5)),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
            child: BlocBuilder<SubmitVisibleBloc, SubmitVisibleState>(
              buildWhen: (previous, current) {
                return (current.card == true);
              },
              builder: (context, state) {
                isShow = state.isShow;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
                            child: const Text(
                              'Complaint:',
                              style: TextStyle(
                                  fontFamily: AssetConstants.poppinsSemiBold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
                            child: Icon(
                              isShow ? Icons.expand_less : Icons.expand_more,
                              color: ColorConstants.blackColor,
                              size: SizeConfig.blockSizeHorizontal * 5,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        context
                            .read<SubmitVisibleBloc>()
                            .add(ShowET(show: isShow));
                      },
                    ),
                    const Divider(color: ColorConstants.backgroundColor2),
                    Visibility(
                      visible: isShow,
                      child: Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: ListView.separated(
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
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
