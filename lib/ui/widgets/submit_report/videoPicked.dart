import 'dart:typed_data';

import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class VideoPicked extends StatefulWidget {
  const VideoPicked({
    super.key,
    required this.thumbnail,
    required this.deleteOntap,
    required this.videoOntap,
  });
  final List<Uint8List> thumbnail;
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
          widget.thumbnail.isEmpty
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
                                Image.memory(
                                  //to show image, you type like this.
                                  widget.thumbnail[index],
                                  fit: BoxFit.cover,
                                  width: SizeConfig.blockSizeHorizontal * 20,
                                  height: SizeConfig.blockSizeHorizontal * 25,
                                ),
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
                      itemCount: widget.thumbnail.length,
                    ),
                  ),
                ),
          if (widget.thumbnail.length != 3)
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: IconButton(
                  onPressed: () {
                    myVideoAlert();
                  },
                  icon: const Icon(Icons.add)),
            ),
        ],
      ),
    );
  }

  void myVideoAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            title: const Text(
              'Please choose media ',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: AssetConstants.poppinsMedium,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black87),
            ),
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
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 2),
                          child: const Icon(Icons.image),
                        ),
                        const Text(
                          'From Gallery',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AssetConstants.poppinsMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getVideo(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 2),
                          child: const Icon(Icons.camera),
                        ),
                        const Text(
                          'From Camera',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: AssetConstants.poppinsMedium),
                        ),
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
        widget.videoOntap(xfilePick);
        // context.read<SubmitTabBloc>().add(VideoPickerET(xfilePick: xfilePick));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
            const SnackBar(content: Text('Nothing is selected')));
      }
    });
  }
}
