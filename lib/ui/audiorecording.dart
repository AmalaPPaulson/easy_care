import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_care/blocs/start_service/common.dart';
import 'package:easy_care/ui/widgets/Buttons/login_button1.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

class AudioRecording extends StatefulWidget {
  const AudioRecording({super.key, required this.onRecorded});
  final void Function(String? path) onRecorded;
  @override
  State<AudioRecording> createState() => _AudioRecordingState();
}

class _AudioRecordingState extends State<AudioRecording> {
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final record = AudioRecorder();
  final player = AudioPlayer();
  bool isRecording = false;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);
  String? paths;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: (paths != null) ? true : false,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Column(
                    children: [
                      const Text(
                        'Do you want to Delete...?',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      LoginButton1(
                          isPressed: false,
                          onTap: () {
                            setState(() {
                              player.pause();
                              paths = null;
                              widget.onRecorded(paths);
                              log('path becoms  null ----------------$paths');
                              if (paths != null) {
                                log('path becoms not null ----------------$paths');
                              }
                              Navigator.of(context).pop();
                            });

                            if (paths == null) {
                              Fluttertoast.showToast(
                                  msg: 'Audio deleted Successfully');
                            }
                          },
                          text: 'YES'),
                    ],
                  ));
                },
              );
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
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
                          ? Row(children: [ Text(
                              '$minutes:$seconds',
                              style: const TextStyle(
                                  color: ColorConstants.primaryColor,
                                  fontSize: 12,
                                  fontFamily: AssetConstants.poppinsMedium),
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal*2,
                            )
                            ],)
                          
                          
                          : (recodingFinished
                              ? StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return Flexible(
                                      child: SeekBar(
                                        duration: positionData?.duration ??
                                            Duration.zero,
                                        position: positionData?.position ??
                                            Duration.zero,
                                        bufferedPosition:
                                            positionData?.bufferedPosition ??
                                                Duration.zero,
                                        onChangeEnd: player.seek,
                                      ),
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
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.blockSizeHorizontal * 2),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 20,
                                        child: Icon(
                                          !isPlaying
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                          color: ColorConstants.primaryColor,
                                        )),
                                  ),
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
      setState(() {
        widget.onRecorded(paths);
      });
      log(" paths $paths");
      player.setAudioSource(AudioSource.file(paths!));
    }
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

  // Widget changedRow() {
  //   return Row(
  //     children: [
  //       const Column(
  //         children: [
  //           Icon(
  //             Icons.mic,
  //             color: Colors.white,
  //           ),
  //           Text(
  //             '0.0',
  //             style: TextStyle(color: Colors.white, fontSize: 12),
  //           ),
  //         ],
  //       ),
  //       StreamBuilder<PositionData>(
  //         stream: _positionDataStream,
  //         builder: (context, snapshot) {
  //           final positionData = snapshot.data;
  //           return SeekBar(
  //             duration: positionData?.duration ?? Duration.zero,
  //             position: positionData?.position ?? Duration.zero,
  //             bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
  //             onChangeEnd: player.seek,
  //           );
  //         },
  //       ),
  //       CircleAvatar(
  //           backgroundColor: Colors.grey,
  //           radius: SizeConfig.blockSizeHorizontal * 1.5,
  //           child: const Icon(
  //             Icons.play_arrow,
  //             color: ColorConstants.primaryColor,
  //           )),
  //     ],
  //   );
  // }

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
  // playAudio() {
  //   player.play();
  // }
}
