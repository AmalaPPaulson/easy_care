// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'submit_tab_bloc.dart';

@immutable
sealed class SubmitTabEvent {}

class TabClickET extends SubmitTabEvent {
  final int tabNo;
  TabClickET({
    required this.tabNo,
  });
}

class RadialBtnClickET extends SubmitTabEvent {
  final int value;
  RadialBtnClickET({
    required this.value,
  });
}

class ImagePickerET extends SubmitTabEvent {
  final XFile image;
  ImagePickerET({
    required this.image,
  });
}

class ImageDeleteET extends SubmitTabEvent {
  final int index;
  ImageDeleteET({
    required this.index,
  });
}

class VideoPickerET extends SubmitTabEvent {
  final XFile xfilePick;
  VideoPickerET({
    required this.xfilePick,
  });
}

class VideoDeleteET extends SubmitTabEvent {
  final int index;
  VideoDeleteET({
    required this.index,
  });
}

class CheckET extends SubmitTabEvent {
  final bool isChecked;
  CheckET({
     this.isChecked = false,
  });
  
}

class SubmitReportET extends SubmitTabEvent {
  final String? serviceText;
  final String? id;
  final String? spareName;
  final String? price;
  final bool isPaid;
  SubmitReportET({
    this.serviceText,
    this.id,
    this.spareName,
    this.price,
    this.isPaid = false,
  });
}
 class CleanSubmitTabReportET extends SubmitTabEvent {}
