import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/ui/widgets/submit_report/imagePicked.dart';
import 'package:easy_care/ui/widgets/submit_report/service_details.dart';
import 'package:easy_care/ui/widgets/submit_report/videoPicked.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstantService extends StatefulWidget {
  const InstantService({super.key, this.instantServiceController});
  final TextEditingController? instantServiceController;
  @override
  State<InstantService> createState() => _InstantServiceState();
}

class _InstantServiceState extends State<InstantService> {
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<SubmitTabBloc, SubmitTabState>(
          builder: (context, state) {
            return ImagePicked(
              deleteOntap: (index) {
                context.read<SubmitTabBloc>().add(ImageDeleteET(index: index));
              },
              images: state.images,
              imageOntap: (image) {
                context.read<SubmitTabBloc>().add(ImagePickerET(image: image));
              },
            );
          },
        ),
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 6.0,
        ),
        BlocBuilder<SubmitTabBloc, SubmitTabState>(
          builder: (context, state) {
            return VideoPicked(
              thumbnail: state.thumbnail,
              deleteOntap: (index) {
                context.read<SubmitTabBloc>().add(VideoDeleteET(index: index));
              },
              videoOntap: (xfilePick) {
                context
                    .read<SubmitTabBloc>()
                    .add(VideoPickerET(xfilePick: xfilePick));
              },
            );
          },
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
}
