import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/start_service_repo.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(const ServicesState()) {
    List<XFile> images = [];
    List<File> imageList = [];
    List<File> videoFiles = [];
    StartServiceRepository startServiceRepository = StartServiceRepository();
    on<ImagePickerET>((event, emit) {
      images.addAll(state.images);
      images.add(event.image);

      emit(state.copyWith(images: images));
    });
    on<VideoPickerET>((event, emit) async {
      File? galleryFile = File(event.xfilePick.path);

      videoFiles.addAll(state.videoFiles);
      videoFiles.add(galleryFile);
      emit(state.copyWith(videoFiles: videoFiles));
      final uint8list = await VideoThumbnail.thumbnailData(
        video: galleryFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      List<Uint8List> thumbNails = [];
      if (uint8list != null) {
        thumbNails.addAll(state.thumbnail);
        thumbNails.add(uint8list);
        emit(state.copyWith(thumbnail: thumbNails));
      }
    });

    on<ImageDeleteET>((event, emit) {
      state.images.removeAt(event.index);
      List<XFile> images = [];
      images.addAll(state.images);
      emit(state.copyWith(images: images));
    });

    on<VideoDeleteET>((event, emit) {
      state.videoFiles.removeAt(event.index);
      List<File> videoFiles = [];
      videoFiles.addAll(state.videoFiles);
      emit(state.copyWith(videoFiles: videoFiles));
      state.thumbnail.removeAt(event.index);
      List<Uint8List> thumbNails = [];
      thumbNails.addAll(state.thumbnail);
      emit(state.copyWith(thumbnail: thumbNails));
    });

    on<StartServiceApiET>((event, emit) async {
      MultipartFile? audioFile = await MultipartFile.fromFile(event.audio,
          filename: "audioDescription.m4a");
      imageList = images.map<File>((xfile) => File(xfile.path)).toList();
      emit(state.copyWith(isLoading: true));
      try {
        if (imageList.isNotEmpty) {
          Response? response = await startServiceRepository.startServiceApi(
              event.id,
              event.description,
              audioFile,
              StringConstants.startService);
          if (response != null) {
            if (response.statusCode == 200 || response.statusCode == 201) {
              // print('api response in the success : ${response.data.toString()}');
              
              if (imageList.isNotEmpty) {
                startServiceRepository.addVideoAndImages(
                    index: 0,
                    id: event.id,
                    fileType: "image",
                    imageList: imageList,
                    isPreCheck: true);
                  emit(state.copyWith(isLoading: false, started: true));  
              }
            } else {
              log('api response in the error : ${response.data.toString()}');
              log('api response in the error : ${response.statusCode.toString()}');
              log('api response in the error : ${response.statusMessage.toString()}');
              emit(state.copyWith(isLoading: false));
              emit(state.copyWith(errorMsg: 'unable to update status'));
            }
          } else {
            emit(state.copyWith(errorMsg: 'error', isLoading: false));
          }
        } else if (videoFiles.isNotEmpty) {
          Response? response = await startServiceRepository.startServiceApi(
              event.id,
              event.description,
              audioFile,
              StringConstants.startService);
              if(response!= null){
                if(response.statusCode == 200 || response.statusCode == 201){
                  if(videoFiles.isNotEmpty){
                    startServiceRepository.addVideoAndImages(
                    index: 0,
                    id: event.id,
                    fileType: "video",
                    imageList: videoFiles,
                    isPreCheck: true);
                  emit(state.copyWith(isLoading: false, started: true));  
                  }
                }
              }
        }
      } catch (e) {
        emit(state.copyWith(errorMsg: e.toString()));
      }
    });
  }
}
