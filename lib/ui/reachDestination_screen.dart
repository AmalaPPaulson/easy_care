import 'package:easy_care/blocs/trip_bloc/trip_bloc.dart';
import 'package:easy_care/blocs/trip_visible/bloc/trip_visible_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/start_service.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/ui/widgets/submit_report/complaintCard.dart';
import 'package:easy_care/ui/widgets/submit_report/customerCard.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReachDestination extends StatefulWidget {
  const ReachDestination({super.key});

  @override
  State<ReachDestination> createState() => _ReachDestinationState();
}
 

  class _ReachDestinationState extends State<ReachDestination> {
  bool isShow = true;
  bool isVisible = true;
  UserRepository userRepository = UserRepository();
   final FlareControls _controls = FlareControls();
  @override
  void initState() {
     repeatAnim();
    super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state.reached == true && state.isLoading == false) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StartService()));
        } else if (state.errorMsg != null) {
          Fluttertoast.showToast(
              msg: '${state.errorMsg}',
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
            'Complaint : ${complaint.complaint!.complaintId.toString()}',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: AssetConstants.poppinsSemiBold,
                fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
            child: Column(
              children: [
                animationDriver(context),
                BlocBuilder<TripVisibleBloc, TripVisibleState>(
                  buildWhen: (previous, current) {
                    return current.card == false;
                  },
                  builder: (context, state) {
                    isVisible = state.isVisible;
                    return CustomerCard(
                        complaint: complaint,
                        customerOnTap: () {
                          context.read<TripVisibleBloc>().add(VisibilityET(
                                visible: isVisible,
                              ));
                        },
                        isVisible: isVisible);
                  },
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 4,
                ),
                BlocBuilder<TripVisibleBloc, TripVisibleState>(
                  buildWhen: (previous, current) {
                    return (current.card == true);
                  },
                  builder: (context, state) {
                    isShow = state.isShow;
                    return ComplaintCard(
                        complaintOntap: () {
                          context
                              .read<TripVisibleBloc>()
                              .add(ShowET(show: isShow));
                        },
                        complaint: complaint,
                        isShow: isShow);
                  },
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 20,
                ),
              ],
            ),
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
  }

  Widget animationDriver(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.blockSizeHorizontal*90,
            width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/png/map.png"),
             fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 7.5),
              child: SizedBox(
                width: SizeConfig.blockSizeHorizontal * 50,
                height: SizeConfig.blockSizeHorizontal * 50,
                child:  FlareActor(
                  'assets/animation/Driver_circles.flr',
                  alignment: Alignment.center,
                  controller: _controls,
                  fit: BoxFit.cover,
                  animation: "main",
                ),
              ),
            ),
          ),
        ),
         Positioned(
            right: 0,
          left: 0,
            bottom: 41,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4),
              child: Container(
                height: SizeConfig.blockSizeHorizontal*15,
                 width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*7.5),
                ),
                child:  const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Don't use your phone while driving",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: ColorConstants.primaryColor,fontSize: 12,
                            fontFamily: AssetConstants.poppinsSemiBold),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
  //repeat animation
  repeatAnim() async {
    Future.delayed(const Duration(seconds: 2), () {
      _controls.play('main');
      repeatAnim();
    });
  }
}
 