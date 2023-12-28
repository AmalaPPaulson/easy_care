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

  //show image popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            title: const Text('Please choose media to select',overflow: TextOverflow.ellipsis,),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  ElevatedButton(
                    // if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery', overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera', overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //we can upload image from camera or from gallery based on parameter
  void getImage(ImageSource media) {
    picker.pickImage(source: media).then((img) {
      context.read<ServicesBloc>().add(ImagePickerET(image: img!));
    });
  }

  void myVideoAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            title: const Text('Please choose media to select',overflow: TextOverflow.ellipsis,),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getVideo(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery', overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getVideo(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera', overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getVideo(
    ImageSource img,
  ) {
    picker
        .pickVideo(
            source: img,
            preferredCameraDevice: CameraDevice.front,
            maxDuration: const Duration(minutes: 10))
        .then((xfilePick) {
      if (xfilePick != null) {
        context.read<ServicesBloc>().add(VideoPickerET(xfilePick: xfilePick));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
            const SnackBar(content: Text('Nothing is selected')));
      }
    });
  }

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
            'Complaint Id : ${complaint.complaint!.complaintId.toString()}  ',
            style: const TextStyle(
                color: Colors.white, fontFamily: AssetConstants.poppinsMedium),
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
        padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
        child: Column(
          children: [
            card(complaint),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*6,
            ),
            textfield(),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*6,
            ),
            audioPlayerCopy(),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*6,
            ),
            imagePicker(),

            //example(),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*14,
            ),
          ],
        ),
      )),
    );
  }

  Widget imagePicker() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
              border: Border.all(
                color: Colors.black,
              )),
          child: BlocBuilder<ServicesBloc, ServicesState>(
            builder: (context, state) {
              log('${state.images.length}');
              return Row(
                children: [
                  state.images.isEmpty
                      ? Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: SizeConfig.blockSizeHorizontal * 25,
                              color: Colors.black45,
                            ),
                            const Text(
                              "Click to add picture",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: AssetConstants.poppinsRegular),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 25,
                          //width:SizeConfig.blockSizeHorizontal*20,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              XFile image = state.images[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 1.5,
                                    vertical:
                                        SizeConfig.blockSizeHorizontal * 2.5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        //to show image, you type like this.
                                        File(image.path),
                                        fit: BoxFit.cover,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 20,
                                        height:
                                            SizeConfig.blockSizeHorizontal * 25,
                                      ),
                                      InkWell(
                                        child: const Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.cancel,
                                          ),
                                        ),
                                        onTap: () {
                                          context
                                              .read<ServicesBloc>()
                                              .add(ImageDeleteET(index: index));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: state.images.length,
                          ),
                        ),
                  if (state.images.length != 3)
                    IconButton(
                        onPressed: () {
                          if (state.images.length != 3) {
                            myAlert();
                          }
                        },
                        icon: const Icon(Icons.add)),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 6.0,
        ),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
              border: Border.all(
                color: Colors.black,
              )),
          child: BlocBuilder<ServicesBloc, ServicesState>(
            builder: (context, state) {
              return Row(
                children: [
                  state.thumbnail.isEmpty
                      ? Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: SizeConfig.blockSizeHorizontal * 25,
                              color: Colors.black45,
                            ),
                            const Text(
                              "Click to add video",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: AssetConstants.poppinsRegular),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 25,
                          //width:SizeConfig.blockSizeHorizontal*20,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              // Uint8List thumbNail = state.thumbnail[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 1.5,
                                    vertical:
                                        SizeConfig.blockSizeHorizontal * 2.5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  child: Stack(
                                    children: [
                                      Image.memory(
                                        //to show image, you type like this.
                                        state.thumbnail[index],
                                        fit: BoxFit.cover,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 20,
                                        height:
                                            SizeConfig.blockSizeHorizontal * 25,
                                      ),
                                      InkWell(
                                        child: const Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.cancel,
                                          ),
                                        ),
                                        onTap: () {
                                          context
                                              .read<ServicesBloc>()
                                              .add(VideoDeleteET(index: index));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: state.thumbnail.length,
                          ),
                        ),
                  if (state.thumbnail.length != 3)
                    IconButton(
                        onPressed: () {
                          myVideoAlert();
                        },
                        icon: const Icon(Icons.add)),
                ],
              );
            },
          ),
        ),
      ],
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
                title: const Text('Are you sure you want to delete?',overflow: TextOverflow.ellipsis,),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  )
                ],
              );
            },
          );
        },
        child: const Text("Delete"),
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
        // final confirmed = await showDialog<bool>(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: const Text('Are you sure you want to delete?'),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.pop(context, false),
        //           child: const Text('No'),
        //         ),
        //         TextButton(
        //           onPressed: () => Navigator.pop(context, true),
        //           child: const Text('Yes'),
        //         )
        //       ],
        //     );
        //   },
        // );
        // log('Deletion confirmed: $confirmed');
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 1),
            border: Border.all(
              color: Colors.black,
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
                              //  final remainingInSec =
                              //       strDigits(remaining.inMinutes.remainder(60));
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
                                        color: Colors.grey, fontSize: 12),
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
                                  fontSize: 12),
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
                                      maxLines: 1,
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
                                height: recording ? SizeConfig.blockSizeHorizontal*17.5 : SizeConfig.blockSizeHorizontal*10,
                                width: recording ? SizeConfig.blockSizeHorizontal*17.5: SizeConfig.blockSizeHorizontal*10,
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
          child: Text(
            'Add description',
            style: TextStyle(
                color: Colors.black,
                fontFamily: AssetConstants.poppinsSemiBold,
                fontSize: SizeConfig.blockSizeHorizontal * 4),
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
                  color: Colors.black,
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
            radius: SizeConfig.blockSizeHorizontal*1.5,
            child: const Icon(
              Icons.play_arrow,
              color: ColorConstants.primaryColor,
            )),
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
            child: BlocBuilder<StartServiceBloc, StartServiceState>(
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
                        context.read<StartServiceBloc>().add(VisibilityET(
                              visible: isVisible,
                            ));
                      },
                    ),
                    Visibility(
                        visible: isVisible,
                        child: const Divider(
                            color: ColorConstants.backgroundColor2)),
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
            child: BlocBuilder<StartServiceBloc, StartServiceState>(
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
                            .read<StartServiceBloc>()
                            .add(ShowET(show: isShow));
                      },
                    ),
                    Visibility(
                      visible: isShow,
                        child: const Divider(
                            color: ColorConstants.backgroundColor2)),
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

  playAudio() {
    player.play();
  }
}
