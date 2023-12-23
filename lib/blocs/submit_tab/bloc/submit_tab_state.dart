// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'submit_tab_bloc.dart';

@immutable
class SubmitTabState {
  final int? currentTab;
  final int? selectedOption;
  final List<XFile> images;
  final String? errorMsg;
  final bool isLoading;
  final bool started;
  final List<Uint8List> thumbnail;
  final List<File> videoFiles;
  final bool isChecked;
  const SubmitTabState({
    this.currentTab=0,
    this.selectedOption = 1,
    this.images = const [],
    this.errorMsg,
    this.isLoading = false,
    this.started = false,
    this.thumbnail = const [],
    this.videoFiles = const [],
     this.isChecked = false,
  });

  SubmitTabState copyWith({
    int? currentTab,
    int? selectedOption,
    List<XFile>? images,
    String? errorMsg,
    bool? isLoading,
    bool? started,
    List<Uint8List>? thumbnail,
    List<File>? videoFiles,
    bool? isChecked,
  }) {
    return SubmitTabState(
      currentTab: currentTab ?? this.currentTab,
      selectedOption: selectedOption ?? this.selectedOption,
      images: images ?? this.images,
      errorMsg: errorMsg ?? this.errorMsg,
      isLoading: isLoading ?? this.isLoading,
      started: started ?? this.started,
      thumbnail: thumbnail ?? this.thumbnail,
      videoFiles: videoFiles ?? this.videoFiles,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
