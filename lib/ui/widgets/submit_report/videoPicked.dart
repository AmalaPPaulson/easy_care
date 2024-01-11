import 'dart:io';
import 'package:easy_care/ui/widgets/submit_report/videoThumb.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class VideoPicked extends StatefulWidget {
  const VideoPicked({
    super.key,
    required this.galleryFiles,
    required this.deleteOntap,
    required this.videoOntap,
    
  });
  final List<File> galleryFiles;
  final Function(XFile xfilePick) videoOntap;
  final Function(int index) deleteOntap;
 
  @override
  State<VideoPicked> createState() => _VideoPickedState();
}

class _VideoPickedState extends State<VideoPicked> {
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
          border: Border.all(
            color: Colors.black26,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.galleryFiles.isEmpty
              ? Row(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: SizeConfig.blockSizeHorizontal * 25,
                      color: Colors.black26,
                    ),
                    const Text(
                      "Click to add video",
                      style: TextStyle(
                          color: Colors.black45,
                          fontFamily: AssetConstants.poppinsRegular),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 25,
                    //width:SizeConfig.blockSizeHorizontal*20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // Uint8List thumbNail = state.thumbnail[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 1.5,
                              vertical: SizeConfig.blockSizeHorizontal * 2.5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 2),
                            child: Stack(
                              children: [
                                // Image.memory(
                                //   //to show image, you type like this.
                                //  widget.thumbnail[index],
                                //   fit: BoxFit.cover,
                                //   width: SizeConfig.blockSizeHorizontal * 20,
                                //   height: SizeConfig.blockSizeHorizontal * 25,
                                // ), 
                                VideoThumb(galleryFile: widget.galleryFiles[index]),
                                InkWell(
                                  onTap: () => widget.deleteOntap(index),
                                  child: const Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.cancel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.galleryFiles.length,
                    ),
                  ),
                ),
          if (widget.galleryFiles.length != 3)
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: IconButton(
                  onPressed: () {
                    alertDialog(context);
                  },
                  icon: const Icon(Icons.add)),
            ),
        ],
      ),
    );
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
        widget.videoOntap(xfilePick);
        // context.read<SubmitTabBloc>().add(VideoPickerET(xfilePick: xfilePick));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
            const SnackBar(content: Text('Nothing is selected')));
      }
    });
  }

  //show image popup dialog
  void alertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            title: const Text(
              'Please choose the media',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AssetConstants.poppinsMedium,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    getVideo(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/CRMGallery.svg',
                        semanticsLabel: 'My SVG Image',
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical,
                      ),
                      const Text(
                        'Gallery',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: AssetConstants.poppinsRegular,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    getVideo(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/CRMCamera.svg',
                        semanticsLabel: 'My SVG Image',
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical,
                      ),
                      const Text(
                        'Camera',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: AssetConstants.poppinsRegular,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
