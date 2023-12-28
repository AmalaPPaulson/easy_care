import 'dart:io';

import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InstantSpare extends StatefulWidget {
  const InstantSpare({
    super.key,
    this.spareServiceController,
    this.spareController,
    this.sparePriceController,
  });

  final TextEditingController? spareServiceController,
      spareController,
      sparePriceController;

  @override
  State<InstantSpare> createState() => _InstantSpareState();
}

class _InstantSpareState extends State<InstantSpare> {
  bool isChecked = false;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitTabBloc, SubmitTabState>(
      builder: (context, state) {
        isChecked = state.isChecked;
        if (isChecked == false) {
          widget.sparePriceController!.clear();
        }
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: widget.spareController,
                    enabled: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter replaced spare part name',
                      hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontFamily: AssetConstants.poppinsRegular),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 5,
                          horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 1),
                          borderSide: const BorderSide(
                            color: Colors.black45,
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: const SizedBox(
                    width: 20.0,
                  ),
                ),
                Visibility(
                  visible: isChecked,
                  child: Flexible(
                    flex: 1,
                    child: TextField(
                      controller: widget.sparePriceController,
                      enabled: true,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Price',
                        hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontFamily: AssetConstants.poppinsRegular),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeHorizontal * 5,
                            horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 1),
                            borderSide: const BorderSide(
                              color: Colors.black45,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*5,
            ),
            Row(
              children: [
                 SizedBox(width: SizeConfig.blockSizeHorizontal*2.5), //SizedBox
                /** Checkbox Widget **/
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    context
                        .read<SubmitTabBloc>()
                        .add(CheckET(isChecked: value!));
                  },
                ),
                 SizedBox(
                  width: SizeConfig.blockSizeHorizontal*2.5,
                ), //SizedBox
                const Text(
                  'Paid replacment',
                  style: TextStyle(fontSize: 17.0),
                ), //Text
                //Checkbox
              ], //<Widget>[]
            ),
            TextField(
              controller: widget.spareServiceController,
              maxLines: 3,
              enabled: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Service Details',
                hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontFamily: AssetConstants.poppinsRegular),
                contentPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeHorizontal * 5,
                    horizontal: 12),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 1),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                    )),
              ),
            ),
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*5,
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
                                      fontFamily:
                                          AssetConstants.poppinsRegular),
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
                                            SizeConfig.blockSizeHorizontal *
                                                1.5,
                                        vertical:
                                            SizeConfig.blockSizeHorizontal *
                                                2.5),
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
                                                SizeConfig.blockSizeHorizontal *
                                                    20,
                                            height:
                                                SizeConfig.blockSizeHorizontal *
                                                    25,
                                          ),
                                          InkWell(
                                            child: const Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.cancel,
                                              ),
                                            ),
                                            onTap: () {
                                              context.read<SubmitTabBloc>().add(
                                                  ImageDeleteET(index: index));
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
                              myAlert();
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
                                      fontFamily:
                                          AssetConstants.poppinsRegular),
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
                                            SizeConfig.blockSizeHorizontal *
                                                1.5,
                                        vertical:
                                            SizeConfig.blockSizeHorizontal *
                                                2.5),
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
                                                SizeConfig.blockSizeHorizontal *
                                                    20,
                                            height:
                                                SizeConfig.blockSizeHorizontal *
                                                    25,
                                          ),
                                          InkWell(
                                            child: const Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.cancel,
                                              ),
                                            ),
                                            onTap: () {
                                              context.read<SubmitTabBloc>().add(
                                                  VideoDeleteET(index: index));
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
            const SizedBox(
              height: 60,
            ),
          ],
        );
      },
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
                        Text('From Gallery'),
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
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

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
                        Text('From Gallery'),
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
                        Text('From Camera'),
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
