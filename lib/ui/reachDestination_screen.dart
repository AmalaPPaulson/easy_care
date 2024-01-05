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
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16);
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
}
