import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/start_service_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:video_compress/video_compress.dart';

part 'submit_tab_event.dart';
part 'submit_tab_state.dart';

class SubmitTabBloc extends Bloc<SubmitTabEvent, SubmitTabState> {
  SubmitTabBloc() : super(const SubmitTabState()) {
    int currentTab;
    int selectedOption;
    List<XFile> images = [];
    List<File> videoFiles = [];
    List<File> imageList = [];
    bool isValid = false;
    bool isChecked = false;
    String serviceText, priceText, sparePartText;
    UserRepository userRepository = UserRepository();
    StartServiceRepository startServiceRepository = StartServiceRepository();
    File? compressFile;
    on<TabClickET>((event, emit) {
      currentTab = event.tabNo;
      var removedImages = state.images.toList();
      removedImages.clear();
      var removeVideos = state.videoFiles.toList();
      removeVideos.clear();
      var removeThumb = state.thumbnail.toList();
      removeThumb.clear();
      isChecked = false;
      serviceText = '';
      priceText = '';
      sparePartText = '';
      emit(SubmitTabState(
          currentTab: currentTab,
          images: removedImages,
          videoFiles: removeVideos,
          thumbnail: removeThumb));
    });

    on<RadialBtnClickET>((event, emit) {
      selectedOption = event.value;
      var removedImages = state.images.toList();
      removedImages.clear();
      var removeVideos = state.videoFiles.toList();
      removeVideos.clear();
      var removeThumb = state.thumbnail.toList();
      removeThumb.clear();
      isChecked = false;
      serviceText = '';
      priceText = '';
      sparePartText = '';
      emit(SubmitTabState(
          selectedOption: selectedOption,
          images: removedImages,
          videoFiles: removeVideos,
          thumbnail: removeThumb));
    });

    on<ImagePickerET>((event, emit) {
      images.addAll(state.images);
      images.add(event.image);
      var updatedImages = state.images.toList();
      updatedImages.add(event.image);

      emit(state.copyWith(images: updatedImages));
    });
    on<ImageDeleteET>((event, emit) {
      state.images.removeAt(event.index);
      images.addAll(state.images);
      var updatedImages = state.images.toList();
      emit(state.copyWith(images: updatedImages));
    });

    on<VideoPickerET>((event, emit) async {
      File galleryFile = File(event.xfilePick.path);
      if (File(galleryFile.path).existsSync()) {
        log('File exists!');
        // Proceed with file operations
        log('galleryfile path ${galleryFile.path}');
        // String path = galleryFile.path;
        final size = await galleryFile.length();
        if (size < 20000000) {
          log('size of t he file ------$size');
          final info = await VideoCompress.compressVideo(
            galleryFile.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: false,
          );
          String mediaInfo = info!.path.toString();
          log('MediaInfo as String: $mediaInfo');
          compressFile = File(mediaInfo);
          final sizeCompress = await compressFile!.length();
          log('size of the file after compressing ------$sizeCompress');
          videoFiles.addAll(state.videoFiles);
          videoFiles.add(compressFile!);
          var updatedVideos = state.videoFiles.toList();
          updatedVideos.add(compressFile!);
          emit(state.copyWith(videoFiles: updatedVideos));
        } else {
          log('size is greater than 20 mb');
          Fluttertoast.showToast(msg: 'Video Size is large please take another video');
        }
      } else {
        log('File does not exist.');
      }

      // final uint8list = await VideoThumbnail.thumbnailData(
      //   video: galleryFile.path,
      //   imageFormat: ImageFormat.JPEG,
      //   maxWidth:
      //       128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      //   quality: 25,
      // );
      // List<Uint8List> thumbNails = [];
      // if (uint8list != null) {
      //   thumbNails.addAll(state.thumbnail);
      //   thumbNails.add(uint8list);
      //   var updatedThumbNails = state.thumbnail.toList();
      //   updatedThumbNails.add(uint8list);
      //   emit(state.copyWith(thumbnail: updatedThumbNails,));
      // }
    });
    on<VideoDeleteET>((event, emit) {
      state.videoFiles.removeAt(event.index);
      videoFiles.addAll(state.videoFiles);
      var updatedVideos = state.videoFiles.toList();
      emit(state.copyWith(videoFiles: updatedVideos));
      // state.thumbnail.removeAt(event.index);
      // List<Uint8List> thumbNails = [];
      // thumbNails.addAll(state.thumbnail);
      // var updatedThumbnails = state.thumbnail.toList();
      // emit(state.copyWith(thumbnail: updatedThumbnails));
    });

    on<CheckET>((event, emit) {
      isChecked = event.isChecked;
      emit(state.copyWith(isChecked: isChecked));
    });

    on<SubmitReportET>((event, emit) async {
      log('serviceText inside bloc-------------------------${event.serviceText}');
      serviceText = event.serviceText!;
      priceText = event.price!;
      sparePartText = event.spareName!;

      imageList = state.images.map<File>((xfile) => File(xfile.path)).toList();
      Map<String, dynamic>? data = {};
      emit(state.copyWith(isLoading: true));
      log('seleted option -------------------------${state.selectedOption}');
      if (state.currentTab == 0) {
        log('seleted option -------------------------${state.selectedOption}');
        switch (state.selectedOption) {
          case 1:
            if (event.serviceText != null && event.serviceText != '') {
              if (imageList.isNotEmpty || videoFiles.isNotEmpty) {
                isValid = true;
              } else {
                isValid = false;
              }
              if (isValid) {
                data = {
                  "status": "Completed",
                  "reason": "Service Completed for complaint : ${event.id}",
                  "post_summary": serviceText,
                };
              } else {
                Fluttertoast.showToast(
                    msg: 'please add atleast one video/image');
                emit(state.copyWith(isLoading: false));
              }
            } else {
              Fluttertoast.showToast(msg: 'Please add Service details');
              emit(state.copyWith(isLoading: false));
            }
            break;
          case 2:
            if (event.spareName != null && event.spareName != '') {
              if (event.serviceText != null && event.serviceText != '') {
                if (imageList.isNotEmpty || videoFiles.isNotEmpty) {
                  log('isChecked -------------------------$isChecked');
                  log('price in case 2 -------------------------${event.price}');
                  if (isChecked && (event.price == null || event.price == '')) {
                    isValid = false;
                    Fluttertoast.showToast(msg: 'please add price');
                    emit(state.copyWith(isLoading: false));
                  } else {
                    isValid = true;
                  }
                } else {
                  isValid = false;
                  Fluttertoast.showToast(
                      msg: 'please add atleast one video/image');
                  emit(state.copyWith(isLoading: false));
                }
                if (isValid) {
                  data = {
                    "status": "Completed",
                    "reason":
                        "Spare replacement completed for complaint : ${event.id}",
                    "post_summary":
                        '${event.serviceText!}, Spare Parts: $sparePartText',
                    "is_paid": isChecked, //there is a mistake
                    "spare_rate": (isChecked) ? double.parse(priceText) : 0.0,
                  };
                } else {
                  //write isloading false to emit
                }
              } else {
                Fluttertoast.showToast(msg: 'Please add Service details');
                emit(state.copyWith(isLoading: false));
              }
            } else {
              Fluttertoast.showToast(msg: 'Please provide Spare part name');
              emit(state.copyWith(isLoading: false));
            }
            break;
          case 3:
            if (event.spareName != null && event.spareName != '') {
              if (event.serviceText != null && event.serviceText != '') {
                if (isChecked && (event.price == null || event.price == '')) {
                  isValid = false;
                  Fluttertoast.showToast(msg: 'please add price');
                  emit(state.copyWith(isLoading: false));
                } else {
                  isValid = true;
                }
                if (isValid) {
                  data = {
                    "status": "Completed",
                    "reason": "Product replacement for complaint : ${event.id}",
                    "post_summary":
                        '${event.serviceText!}, Product Name: ${event.spareName!}',
                    "is_paid": event.isPaid,
                    "product_price":
                        (event.isPaid) ? double.parse(event.price!) : 0.0,
                  };
                }
              } else {
                Fluttertoast.showToast(msg: 'Please add Service details');
                emit(state.copyWith(
                  isLoading: false,
                ));
              }
            } else {
              Fluttertoast.showToast(msg: 'Please provide Spare part name');
              emit(state.copyWith(
                isLoading: false,
              ));
            }
        }
      } else if (state.currentTab == 1) {
        if (event.serviceText != null && event.serviceText != '') {
          isValid = true;
          data = {
            "status": "Rescheduled",
            "reason":
                "Service for complaint : ${event.id} is rescheduled to another technician ",
            "post_summary": event.serviceText!,
          };
        } else {
          Fluttertoast.showToast(msg: 'Please provide service details');
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      }
      if (isValid) {
        log('inside isValid data ----------------$data');
        // checking internet connectivity
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          try {
            Response? response = await startServiceRepository.submitReport(
                event.id.toString(), data);

            if (response != null) {
              log('api response in the error : ${response.data.toString()}');
              log('api response in the error : ${response.statusCode.toString()}');
              log('api response in the error : ${response.statusMessage.toString()}');
              if (response.statusCode == 200 || response.statusCode == 201) {
                log('api response in the success of submitreport : ${response.data.toString()}');
                log('api response in the success : ${response.statusCode.toString()}');
                log('api response in the success : ${response.statusMessage.toString()}');
                if (imageList.isNotEmpty) {
                  log('imagelist above api ----------------------------------${imageList.isNotEmpty}');
                  startServiceRepository.addVideoAndImages(
                      index: 0,
                      id: event.id!,
                      fileType: "image",
                      imageList: imageList,
                      isPreCheck: false);
                }
                if (state.videoFiles.isNotEmpty) {
                  startServiceRepository.addVideoAndImages(
                      index: 0,
                      id: event.id!,
                      fileType: "video",
                      imageList: state.videoFiles,
                      isPreCheck: false);
                }
                await userRepository.setTripStatus('');
                emit(state.copyWith(isLoading: false, started: true));
              } else {
                Fluttertoast.showToast(
                    msg: response.statusMessage ??
                        'Something went wrong !Please try agian.');
                emit(state.copyWith(isLoading: false));
              }
            } else {
              Fluttertoast.showToast(msg: 'Network issue! Please try again..');
              emit(state.copyWith(isLoading: false));
            }
          } catch (e) {
            log('error in the submit api ----------------${e.toString()}');
            Fluttertoast.showToast(msg: e.toString());
          }
        } else {
          emit(state.copyWith(isLoading: false));
          log('internet connection is not there');
          Fluttertoast.showToast(
              msg: ' No internet, please check your connection');
        }
      }
    });

    on<CleanSubmitTabReportET>((event, emit) {
      emit(state.copyWith(
        images: [],
        currentTab: 0,
        selectedOption: 1,
        isLoading: false,
        started: false,
        thumbnail: [],
        videoFiles: [],
        isChecked: false,
      ));
    });
  }
}
