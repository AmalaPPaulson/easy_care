import 'dart:developer';
import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/blocs/submit_visible/bloc/submit_visible_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/success_screen.dart';
import 'package:easy_care/ui/tabTitletile.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/ui/widgets/submit_report/complaintCard.dart';
import 'package:easy_care/ui/widgets/submit_report/customerCard.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_product.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_service.dart';
import 'package:easy_care/ui/widgets/submit_report/instant_spare.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';

import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

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
  Subscription? subscription;
  //double? progress;
  final ValueNotifier<double?> progressNotifier = ValueNotifier<double?>(null);
  @override
  void initState() {
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((pro) {
      debugPrint('progress 1: $pro');
      progressNotifier.value = pro;
      // setState(() {
      //   progress = pro;
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription!.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();
    return BlocListener<SubmitTabBloc, SubmitTabState>(
      listener: (context, state) {
        //when Api hit and emit isloading = false , screen navigate to success screen
        if (state.isLoading == false && state.started) {
          subscription!.unsubscribe();
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
            'Complaint : ${complaint.complaint!.complaintId.toString()}  ',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: AssetConstants.poppinsSemiBold,
                fontSize: 20),
          ),
        ),
        // body: (progress == null || progress ==100)
        //     ? createBody(complaint)
        //     : Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           const Text('Compressing Video...'),
        //           const SizedBox(
        //             height: 16,
        //           ),
        //           LinearProgressIndicator(
        //             value: progress! / 100,
        //           ),
        //           Text('progress ${progress! / 100}'),
        //         ],
        //       ),

        body: ValueListenableBuilder<double?>(
            valueListenable: progressNotifier,
            builder: (context, double? progress, Widget? child) {
              debugPrint('in valuelistenable$progress');
              if (progress != null) {
                if (progress != 100) {
                  return Stack(
                    children: [
                      createBody(complaint),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 12.5,
                              height: SizeConfig.blockSizeHorizontal * 12.5,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                strokeCap: StrokeCap.round,
                                value: progress / 100,
                                strokeWidth: 8,
                                color: ColorConstants.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 4,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: ColorConstants.primaryColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 1),
                                    border: Border.all(
                                      color: Colors.black26,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ${progress.roundToDouble()} %',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: AssetConstants.poppinsSemiBold),
                                  ),
                                )),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 4,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeHorizontal * 6),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig.blockSizeHorizontal * 2)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 2),
                                      border: Border.all(
                                          color: ColorConstants.primaryColor,
                                          width: 2)),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.blockSizeHorizontal * 2),
                                    child: const Text(
                                      'This video is longer, uploading may take extra time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: AssetConstants.poppinsMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              //  if(VideoCompress.isCompressing== false){
              //   return createBody(complaint);
              //  }
                if (progress == 100) {
                  return createBody(complaint);
                }
              }
              return createBody(complaint);
            }),
        floatingActionButton: ValueListenableBuilder<double?>(
            valueListenable: progressNotifier,
            builder: (context, double? progress, Widget? child) {
              if (progress != null) {
                if (progress != 100) {
                  return const SizedBox();
                }
                if (progress == 100) {
                  return BlocBuilder<SubmitTabBloc, SubmitTabState>(
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
                  );
                }
              }
              return BlocBuilder<SubmitTabBloc, SubmitTabState>(
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
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false, // fluter 2.x
      ),
    );
  }

  Widget createBody(ComplaintResult complaint) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
        child: Column(
          children: [
            //calling two cards to show
            BlocBuilder<SubmitVisibleBloc, SubmitVisibleState>(
              buildWhen: (previous, current) {
                return current.card == false;
              },
              builder: (context, state) {
                isVisible = state.isVisible;
                return CustomerCard(
                    complaint: complaint,
                    customerOnTap: () {
                      context.read<SubmitVisibleBloc>().add(VisibilityET(
                            visible: isVisible,
                          ));
                    },
                    isVisible: isVisible);
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 4,
            ),
            BlocBuilder<SubmitVisibleBloc, SubmitVisibleState>(
              buildWhen: (previous, current) {
                return (current.card == true);
              },
              builder: (context, state) {
                isShow = state.isShow;
                return ComplaintCard(
                    complaintOntap: () {
                      context
                          .read<SubmitVisibleBloc>()
                          .add(ShowET(show: isShow));
                    },
                    complaint: complaint,
                    isShow: isShow);
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 8,
            ),
            // here accroding to current tab and radil btn number as selected
            //option it shows related UI
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
                      height: SizeConfig.blockSizeHorizontal * 8,
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
                      height: SizeConfig.blockSizeHorizontal * 50,
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
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
      child: Container(
        height: SizeConfig.blockSizeHorizontal * 15,
        width: MediaQuery.of(context).size.width,
        color: ColorConstants.backgroundColor2,
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
                    ? BorderRadius.only(
                        topRight: Radius.circular(
                            SizeConfig.blockSizeHorizontal * 1.5))
                    : (currentTab == 1)
                        ? BorderRadius.only(
                            bottomRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 1.5))
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
                    ? BorderRadius.only(
                        bottomLeft:
                            Radius.circular(SizeConfig.blockSizeHorizontal * 2))
                    : (currentTab == 1)
                        ? BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 2),
                            topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 2))
                        : BorderRadius.only(
                            bottomRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 2)),
                onPressed: () {
                  tab = false;
                  context.read<SubmitTabBloc>().add(TabClickET(tabNo: 1));
                  serviceController.clear();
                  priceController.clear();
                  sparePartController.clear();
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
          title: const Text(
            'Service',
            style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
          ),
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
          title: const Text(
            'Spare Replacement',
            style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
          ),
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
          title: const Text(
            'Product Replacement',
            style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
          ),
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
          title: const Text(
            'Assign to another technician',
            style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
          ),
          leading: Radio(
            value: 1,
            groupValue: option,
            onChanged: (value) {
              option = value!;
              serviceController.clear();
              priceController.clear();
              sparePartController.clear();
            },
          ),
        ),
      ],
    );
  }
}
