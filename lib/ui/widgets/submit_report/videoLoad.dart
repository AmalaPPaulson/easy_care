import 'dart:developer';

import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class VideoLoad extends StatefulWidget {
  const VideoLoad({super.key});

  @override
  State<VideoLoad> createState() => VideoLoadState();
}

class VideoLoadState extends State<VideoLoad> {
  @override
  void initState() {
    startListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: progress,
        builder: (context, progressed, child) {
          log('progress ${progress.value}');
          if (progress.value == 0.0) {
            return const SizedBox.shrink();
          }

          return Scaffold(
             backgroundColor: Colors.white.withOpacity(0.5),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                      value: progressed / 100,
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
                          ' ${progressed.roundToDouble()} %',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: AssetConstants.poppinsSemiBold),
                        ),
                      )),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 4,
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.blockSizeHorizontal * 2)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 2),
                            border: Border.all(
                                color: ColorConstants.primaryColor, width: 2)),
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
          );
        });
  }

  static void startListen() {
    if (!VideoCompress.compressProgress$.notSubscribed) return;
    VideoCompress.compressProgress$.subscribe((event) {
      if (event == 100) {
        progress.value = 0;
        return;
      }
      log('progress is : ${progress.value}');
      progress.value = event;
    });
  }

  static final progress = ValueNotifier(0.0);
}
