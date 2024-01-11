import 'dart:io';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumb extends StatefulWidget {
  const VideoThumb({
    super.key,
    required this.galleryFile,
  });

  final File galleryFile;

  @override
  State<VideoThumb> createState() => _VideoThumbState();
}

class _VideoThumbState extends State<VideoThumb> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: VideoThumbnail.thumbnailData(
        video: widget.galleryFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            //to show image, you type like this.
            snapshot.data!,
            fit: BoxFit.cover,
            width: SizeConfig.blockSizeHorizontal * 20,
            height: SizeConfig.blockSizeHorizontal * 25,
          );
        }
        return Center(
          child: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 20,
              height: SizeConfig.blockSizeHorizontal * 25,
              child: const Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
