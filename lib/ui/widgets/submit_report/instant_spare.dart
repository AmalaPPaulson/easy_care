import 'dart:io';

import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/ui/widgets/submit_report/imagePicked.dart';
import 'package:easy_care/ui/widgets/submit_report/videoPicked.dart';
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
              height: SizeConfig.blockSizeHorizontal * 5,
            ),
            Row(
              children: [
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 2.5), //SizedBox
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
                  width: SizeConfig.blockSizeHorizontal * 2.5,
                ), //SizedBox
                const Text(
                  'Paid replacment',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: AssetConstants.poppinsRegular),
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
              height: SizeConfig.blockSizeHorizontal * 5,
            ),
           
           BlocBuilder<SubmitTabBloc, SubmitTabState>(
             builder: (context, state) {
               return ImagePicked(deleteOntap: (index){
                context.read<SubmitTabBloc>().add(ImageDeleteET(index: index));
               }, images: state.images, imageOntap: (image){
                context.read<SubmitTabBloc>().add(ImagePickerET(image: image));
               });
             },
           ),
           SizedBox(
              height: SizeConfig.blockSizeHorizontal * 6.0,
            ),
           BlocBuilder<SubmitTabBloc, SubmitTabState>(
             builder: (context, state) {
               return VideoPicked(thumbnail: state.thumbnail, deleteOntap: (index){
                  context.read<SubmitTabBloc>().add(VideoDeleteET(index: index));
               } ,videoOntap: (xfilePick){
                 context
                    .read<SubmitTabBloc>()
                    .add(VideoPickerET(xfilePick: xfilePick));
               });
             },
           ),
         
             SizedBox(
              height: SizeConfig.blockSizeHorizontal*15,
            ),
          ],
        );
      },
    );
  }
}
