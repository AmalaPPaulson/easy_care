import 'dart:io';


import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImagePicked extends StatefulWidget {
  const ImagePicked({
    super.key,
    required this.deleteOntap,
    required this.images,
    required this.imageOntap,
  });

  final Function(int index) deleteOntap;
  final List<XFile> images;
  final Function(XFile image) imageOntap;
  @override
  State<ImagePicked> createState() => _ImagePickedState();
}

class _ImagePickedState extends State<ImagePicked> {
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
        widget.images.isEmpty
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
            : Padding(
              padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
              child: SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 25,
                  //width:SizeConfig.blockSizeHorizontal*20,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      XFile image = widget.images[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 1.5,
                            vertical: SizeConfig.blockSizeHorizontal * 2.5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 2),
                          child: Stack(
                            children: [
                              Image.file(
                                //to show image, you type like this.
                                File(image.path),
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
                    itemCount: widget.images.length,
                  ),
                ),
            ),
        if (widget.images.length != 3)
          Padding(
            padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
            child: IconButton(
                onPressed: () {
                  if (widget.images.length != 3) {
                    myAlert(context);
                  }
                },
                icon: const Icon(Icons.add)),
          ),
      ]),
    );
  }

//show image popup dialog
  void myAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2)),
            title: const Text(
              'Please choose media',
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
                    // if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
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
                              fontFamily: AssetConstants.poppinsMedium),
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
                      getImage(ImageSource.camera);
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

  //we can upload image from camera or from gallery based on parameter
  void getImage(ImageSource media) {
    picker.pickImage(source: media).then((img) {
      widget.imageOntap(img!);
      
    });
  }
}
