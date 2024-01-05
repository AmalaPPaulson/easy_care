import 'dart:async';
import 'package:easy_care/blocs/services/bloc/services_bloc.dart';
import 'package:easy_care/blocs/start_service/bloc/start_service_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/audiorecording.dart';
import 'package:easy_care/ui/submit_report.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/ui/widgets/submit_report/complaintCard.dart';
import 'package:easy_care/ui/widgets/submit_report/customerCard.dart';
import 'package:easy_care/ui/widgets/submit_report/imagePicked.dart';
import 'package:easy_care/ui/widgets/submit_report/videoPicked.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

class StartService extends StatefulWidget {
  const StartService({super.key});
  @override
  State<StartService> createState() => _StartState();
}

class _StartState extends State<StartService> {
  UserRepository userRepository = UserRepository();
  bool isShow = true;
  bool isVisible = true;
  final record = AudioRecorder();
  final player = AudioPlayer();
  bool isRecording = false;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);
  String? paths;
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();
    return BlocListener<ServicesBloc, ServicesState>(
      listener: (context, state) {
        if (state.isLoading == false && state.started) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SubmitReport()),
              (Route route) => false);
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
        body: createBody(complaint),
        floatingActionButton: BlocBuilder<ServicesBloc, ServicesState>(
          buildWhen: (previous, current) => (previous != current),
          builder: (context, state) {
            bool isPressed = false;
            if (state.isLoading) {
              isPressed = true;
            }
            return FloatingActionBtn(
                onTap: () {
                  context.read<ServicesBloc>().add(StartServiceApiET(
                        id: complaint.id.toString(),
                        description: descriptionController.text,
                        audio: paths,
                      ));
                },
                isPressed: isPressed,
                text: 'Start Service');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget createBody(ComplaintResult complaint) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
        child: Column(
          children: [
            //here hide and show cards
            BlocBuilder<StartServiceBloc, StartServiceState>(
              buildWhen: (previous, current) {
                return current.card == false;
              },
              builder: (context, state) {
                isVisible = state.isVisible;
                return CustomerCard(
                    complaint: complaint,
                    customerOnTap: () {
                      context.read<StartServiceBloc>().add(VisibilityET(
                            visible: isVisible,
                          ));
                    },
                    isVisible: isVisible);
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 4,
            ),
            BlocBuilder<StartServiceBloc, StartServiceState>(
              buildWhen: (previous, current) {
                return (current.card == true);
              },
              builder: (context, state) {
                isShow = state.isShow;
                return ComplaintCard(
                    complaintOntap: () {
                      context
                          .read<StartServiceBloc>()
                          .add(ShowET(show: isShow));
                    },
                    complaint: complaint,
                    isShow: isShow);
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6,
            ),
            textfield(),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6,
            ),
            AudioRecording(
              onRecorded: (path) {
                paths = path;
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6,
            ),
            BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                return ImagePicked(
                    deleteOntap: (index) {
                      context
                          .read<ServicesBloc>()
                          .add(ImageDeleteET(index: index));
                    },
                    images: state.images,
                    imageOntap: (image) {
                      context
                          .read<ServicesBloc>()
                          .add(ImagePickerET(image: image));
                    });
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6.0,
            ),
            BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                return VideoPicked(
                    thumbnail: state.thumbnail,
                    deleteOntap: (index) {
                      context
                          .read<ServicesBloc>()
                          .add(VideoDeleteET(index: index));
                    },
                    videoOntap: (xfilePick) {
                      context
                          .read<ServicesBloc>()
                          .add(VideoPickerET(xfilePick: xfilePick));
                    });
              },
            ),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 20,
            ),
          ],
        ),
      )),
    );
  }
  // text field to add description about complaint
  Widget textfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          child: const Text(
            'Add description',
            style: TextStyle(
                color: Colors.black,
                fontFamily: AssetConstants.poppinsSemiBold,
                fontSize: 16),
          ),
        ),
        TextField(
          controller: descriptionController,
          enabled: true,
          textInputAction: TextInputAction.done,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Enter your description about the compliant..',
            hintStyle: const TextStyle(
                color: Colors.black45,
                fontFamily: AssetConstants.poppinsRegular),
            contentPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeHorizontal * 5, horizontal: 12),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
                borderSide: const BorderSide(
                  color: Colors.black26,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
                borderSide: const BorderSide(
                  color: Colors.black26,
                )),
          ),
        ),
      ],
    );
  }
}
