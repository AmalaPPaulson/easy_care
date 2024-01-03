import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_care/blocs/services/bloc/services_bloc.dart';
import 'package:easy_care/blocs/start_service/bloc/start_service_bloc.dart';
import 'package:easy_care/blocs/start_service/common.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
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

import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

class StartService extends StatefulWidget {
  const StartService({super.key});
  @override
  State<StartService> createState() => _StartState();
}

class _StartState extends State<StartService> {
  UserRepository userRepository = UserRepository();
  ComplaintRepository complaintRepository = ComplaintRepository();
  bool isShow = true;
  bool isVisible = true;
  final record = AudioRecorder();
  XFile? image;
  File? galleryFile;
  final ImagePicker picker = ImagePicker();
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
            audioPlayerCopy(),
            SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6,
            ),
            //imagePicker(),
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
  Widget audioPlayerCopy() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: ElevatedButton(
        onPressed: () {
          showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Are you sure you want to delete?',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'No',
                      style:
                          TextStyle(fontFamily: AssetConstants.poppinsMedium),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Yes',
                      style:
                          TextStyle(fontFamily: AssetConstants.poppinsMedium),
                    ),
                  )
                ],
              );
            },
          );
        },
        child: const Text(
          "Delete",
          style: TextStyle(fontFamily: AssetConstants.poppinsMedium),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        log('Dismissed with direction $direction');
        // Your deletion logic goes here.
        player.stop();
        record.stop();
        setState(() {
          paths = null;
        });
      },
      confirmDismiss: (DismissDirection direction) async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
            border: Border.all(
              color: Colors.black26,
            )),
        child: Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<RecordState>(
                    stream: record.onStateChanged(),
                    builder: (context, snapshot) {
                      bool recodingFinished = false;
                      if (snapshot.data != null) {
                        if (snapshot.data == RecordState.stop) {
                          if (paths != null) {
                            if (paths!.isNotEmpty) {
                              recodingFinished = true;
                            }
                          }
                        }
                      }
                      if (recodingFinished) {
                        return StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              final duration =
                                  positionData?.duration ?? Duration.zero;
                              final position =
                                  positionData?.position ?? Duration.zero;
                              Duration remaining = duration - position;
                              return Column(
                                children: [
                                  const Icon(
                                    Icons.mic,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                            .firstMatch("$remaining")
                                            ?.group(1) ??
                                        '$remaining',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily:
                                            AssetConstants.poppinsRegular),
                                  ),
                                ],
                              );
                            });
                      }

                      return const SizedBox();
                    }),
                StreamBuilder<RecordState>(
                    stream: record.onStateChanged(),
                    builder: (context, snapshot) {
                      final minutes =
                          strDigits(myDuration.inMinutes.remainder(60));
                      //var timer = int.parse(minutes);
                      final seconds =
                          strDigits(myDuration.inSeconds.remainder(60));
                      bool recording = false;
                      bool recodingFinished = false;
                      if (snapshot.data != null) {
                        recording = snapshot.data == RecordState.record;
                        if (snapshot.data == RecordState.stop) {
                          if (paths != null) {
                            if (paths!.isNotEmpty) {
                              recodingFinished = true;
                            }
                          }
                        }
                      }

                      return recording
                          ? Text(
                              '$minutes:$seconds',
                              style: const TextStyle(
                                  color: ColorConstants.primaryColor,
                                  fontSize: 12,
                                  fontFamily: AssetConstants.poppinsMedium),
                            )
                          : (recodingFinished
                              ? StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return SeekBar(
                                      duration: positionData?.duration ??
                                          Duration.zero,
                                      position: positionData?.position ??
                                          Duration.zero,
                                      bufferedPosition:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      onChangeEnd: player.seek,
                                    );
                                  },
                                )
                              : Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.blockSizeHorizontal * 2),
                                    child: const Text(
                                      'Press and hold to add a voice note.',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily:
                                            AssetConstants.poppinsRegular,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ));
                    }),
                const Spacer(),
                StreamBuilder<RecordState>(
                    stream: record.onStateChanged(),
                    builder: (context, snapshot) {
                      bool recording = false;
                      bool recodingFinished = false;
                      if (snapshot.data != null) {
                        recording = snapshot.data == RecordState.record;
                        if (snapshot.data == RecordState.stop) {
                          if (paths != null) {
                            if (paths!.isNotEmpty) {
                              recodingFinished = true;
                            }
                          }
                        }
                      }
                      return recodingFinished
                          ? StreamBuilder<PlayerState>(
                              stream: player.playerStateStream,
                              builder: (context, snapshot) {
                                bool isPlaying = false;
                                if (snapshot.data != null) {
                                  isPlaying = snapshot.data!.playing;
                                  if (snapshot.data!.processingState ==
                                      ProcessingState.completed) {
                                    isPlaying = false;
                                  }
                                }
                                return InkWell(
                                  onTap: () {
                                    if (isPlaying) {
                                      player.pause();
                                    } else {
                                      player.setAudioSource(
                                          AudioSource.file(paths!));
                                      player.play();
                                    }
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 20,
                                      child: Icon(
                                        !isPlaying
                                            ? Icons.play_arrow
                                            : Icons.pause,
                                        color: ColorConstants.primaryColor,
                                      )),
                                );
                              })
                          : GestureDetector(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: recording
                                    ? SizeConfig.blockSizeHorizontal * 17.5
                                    : SizeConfig.blockSizeHorizontal * 10,
                                width: recording
                                    ? SizeConfig.blockSizeHorizontal * 17.5
                                    : SizeConfig.blockSizeHorizontal * 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.primaryColor,
                                ),
                                child: const Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                              onLongPressStart:
                                  (LongPressStartDetails details) {
                                startTimer();
                                startRecording(true);
                              },
                              onLongPressEnd: (LongPressEndDetails details) {
                                log("10");
                                setState(() {
                                  isRecording = false;
                                  if (countdownTimer == null ||
                                      countdownTimer!.isActive) {
                                    stopTimer();
                                    resetTimer();
                                  }
                                });

                                startRecording(false);
                              },
                            );
                    }),
              ],
            )),
      ),
    );
  }

  void startRecording(bool recordStarted) async {
    bool permissionsGranted = await record.hasPermission();
    //print('permission is granted $permissionsGranted');
    if (permissionsGranted) {
      //print('permission is granted $permissionsGranted');
      await Permission.microphone.request();
    }

    if (recordStarted) {
      final Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/amala.m4a';
      record.start(const RecordConfig(), path: tempPath);
    } else {
      paths = await record.stop();
      log(" paths $paths");
      player.setAudioSource(AudioSource.file(paths!));
    }
  }

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

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  Widget changedRow() {
    return Row(
      children: [
        const Column(
          children: [
            Icon(
              Icons.mic,
              color: Colors.white,
            ),
            Text(
              '0.0',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: player.seek,
            );
          },
        ),
        CircleAvatar(
            backgroundColor: Colors.grey,
            radius: SizeConfig.blockSizeHorizontal * 1.5,
            child: const Icon(
              Icons.play_arrow,
              color: ColorConstants.primaryColor,
            )),
      ],
    );
  }
 //start timer
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }
//stop timer
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(days: 5));
  }
  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds + reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }
  playAudio() {
    player.play();
  }
}
