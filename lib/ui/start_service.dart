import 'dart:developer';
import 'dart:io';

import 'package:easy_care/blocs/start_service/bloc/start_service_bloc.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/widgets/Buttons/floatingaction_button.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';



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
  List<XFile> images = [];
  final ImagePicker picker = ImagePicker(); 
  //show popup dialog
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
                    //if user click this button, user can upload image from gallery
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

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      if (img != null) {
        images.add(img);
      }
    });
    image = img;
    //imageFileList!.add(img!);
  }

  void myVideoAlert() {
    print('inside myVideoAlert');
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

  Future getVideo(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          print('asdfgg ${galleryFile!.path}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );   
  }

  @override
  Widget build(BuildContext context) {
    ComplaintResult complaint = userRepository.getComplaint();

    return Scaffold(
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
      floatingActionButton: FloatingActionBtn(
          onTap: () {}, isPressed: false, text: 'Start Service'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget createBody(ComplaintResult complaint) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            card(complaint),
            const SizedBox(
              height: 24,
            ),
            textfield(),
            const SizedBox(
              height: 24,
            ),
            audioPlayer(),
            const SizedBox(
              height: 24,
            ),
            imagePicker(),

            //example(),
            const SizedBox(
              height: 56,
            ),
          ],
        ),
      )),
    );
  }

  Widget example() {
    return Container(
        margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeHorizontal * 5),
        height: SizeConfig.blockSizeHorizontal * 25,
        child: images.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  XFile image = images[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 1.5,
                        vertical: SizeConfig.blockSizeHorizontal * 2.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 2),
                      child: Image.file(
                        //to show image, you type like this.
                        File(image.path),
                        fit: BoxFit.cover,
                        width: SizeConfig.blockSizeHorizontal * 25,
                        height: SizeConfig.blockSizeHorizontal * 25,
                      ),
                    ),
                  );
                },
                itemCount: images.length,
              )
            : const Text('no pic selected'));
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
          child: Row(
            children: [
              images.isEmpty
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
                          XFile image = images[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 1.5,
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
                                  const InkWell(
                                    child: Align(
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
                        itemCount: images.length,
                      ),
                    ),
              if (images.length != 3)
                IconButton(
                    onPressed: () {
                      if (images.length != 3) {
                        myAlert();
                      }
                    },
                    icon: const Icon(Icons.add)),
            ],
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
          child: Row(
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
              const Spacer(),
              IconButton(
                  onPressed: () {
                    print('when pressed add icon');
                    myVideoAlert();
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
      ],
    );
  }

  Widget audioPlayer() {
    return Container(
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
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: const Text(
                'Press and hold to add a voice note... ',
                style: TextStyle(
                  fontFamily: AssetConstants.poppinsRegular,
                  color: Colors.black45,
                ),
              ),
            ),
            GestureDetector(
              child: CircleAvatar(
                  backgroundColor: ColorConstants.primaryColor,
                  radius: SizeConfig.blockSizeHorizontal * 6,
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  )),
              onLongPressStart: (LongPressStartDetails details) {
                log("12");
                startRecording(true);
              },
              onLongPressEnd: (LongPressEndDetails details) {
                log("10");
                startRecording(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void startRecording(bool recordStarted) async {
    bool permissionsGranted = await record.hasPermission();
    if (!permissionsGranted) {
      await Permission.microphone.request();
    }

    if (recordStarted) {
      await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
    } else {
      final paths = await record.stop();
      log(" paths $paths");
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
          enabled: true,
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
                    Row(
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
                          child: InkWell(
                            child: Icon(
                              isVisible
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more,
                              color: ColorConstants.blackColor,
                              size: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            onTap: () {
                              context.read<StartServiceBloc>().add(VisibilityET(
                                    visible: isVisible,
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: ColorConstants.backgroundColor2),
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
                    Row(
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
                          child: InkWell(
                            child: Icon(
                              isShow ? Icons.expand_less : Icons.expand_more,
                              color: ColorConstants.blackColor,
                              size: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            onTap: () {
                              context
                                  .read<StartServiceBloc>()
                                  .add(ShowET(show: isShow));
                            },
                          ),
                        )
                      ],
                    ),
                    const Divider(color: ColorConstants.backgroundColor2),
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
}
