import 'dart:io';

import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InstantService extends StatefulWidget {
  const InstantService({super.key, this.instantServiceController});
  final TextEditingController? instantServiceController;
  @override
  State<InstantService> createState() => _InstantServiceState();
}

class _InstantServiceState extends State<InstantService> {
  final ImagePicker picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
              border: Border.all(
                color: Colors.black45,
              )),
          child: BlocBuilder<SubmitTabBloc, SubmitTabState>(
            builder: (context, state) {
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
                                              .read<SubmitTabBloc>()
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
                color: Colors.black45,
              )),
          child: BlocBuilder<SubmitTabBloc, SubmitTabState>(
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
                                              .read<SubmitTabBloc>()
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
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 6.0,
        ),
        ServiceDetails(
          controller: widget.instantServiceController!,
        ),
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 20.0,
        ),
      ],
    );
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
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
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
      context.read<SubmitTabBloc>().add(ImagePickerET(image: img!));
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
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
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
        context.read<SubmitTabBloc>().add(VideoPickerET(xfilePick: xfilePick));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
            const SnackBar(content: Text('Nothing is selected')));
      }
    });
  }
}
