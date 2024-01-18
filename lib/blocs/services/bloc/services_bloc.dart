import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/start_service_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:video_compress/video_compress.dart';
//import 'package:video_thumbnail/video_thumbnail.dart';
part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(const ServicesState()) {
    // List<XFile> images = [];
    List<File> imageList = [];
    List<File> videoFiles = [];
    String? audioFile;
    MultipartFile? audio;
    String? description;
    UserRepository userRepository = UserRepository();
    StartServiceRepository startServiceRepository = StartServiceRepository();
    File? compressFile;
    on<ImagePickerET>((event, emit) {
      //images.addAll(state.images);
      // images.add(event.image);
      var updatedImages = state.images.toList();
      updatedImages.add(event.image);
      // log('image length in imagePickerEt---------------------${images.length}');
      emit(state.copyWith(images: updatedImages));
    });

    on<VideoPickerET>((event, emit) async {
      File? galleryFile = File(event.xfilePick.path);
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

          final uint8list =
              await VideoCompress.getByteThumbnail(compressFile!.path,
                  quality: 50, // default(100)
                  position: -1 // default(-1)
                  );

          final sizeCompress = await compressFile!.length();
          log('size of the file after compressing ------$sizeCompress');
          videoFiles.addAll(state.videoFiles);
          videoFiles.add(compressFile!);
          var updatedVideos = state.videoFiles.toList();
          updatedVideos.add(compressFile!);
          emit(state.copyWith(videoFiles: updatedVideos));
          List<Uint8List> thumbNails = [];
          if (uint8list != null) {
            thumbNails.addAll(state.thumbnail);
            thumbNails.add(uint8list);
            var updatedThumbNails = state.thumbnail.toList();
            updatedThumbNails.add(uint8list);
            emit(state.copyWith(
                thumbnail: updatedThumbNails,));
          }
        } else {
          log('size is greater than 20 mb');
          Fluttertoast.showToast(
              msg: 'Video Size is large please take another video');
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
      //   emit(state.copyWith(thumbnail: updatedThumbNails,isLoadThumb: false));
      // }
    });

    on<ImageDeleteET>((event, emit) {
      state.images.removeAt(event.index);
      var updatedImages = state.images.toList();
      emit(state.copyWith(images: updatedImages));
    });

    on<VideoDeleteET>((event, emit) {
      state.videoFiles.removeAt(event.index);
      videoFiles.addAll(state.videoFiles);
      var updatedVideos = state.videoFiles.toList();
      emit(state.copyWith(videoFiles: updatedVideos));
      state.thumbnail.removeAt(event.index);
      List<Uint8List> thumbNails = [];
      thumbNails.addAll(state.thumbnail);
      var updatedThumbnails = state.thumbnail.toList();
      emit(state.copyWith(thumbnail: updatedThumbnails));
    });

    on<StartServiceApiET>((event, emit) async {
      log('image length ---------------------${state.images.length}');
      imageList = state.images.map<File>((xfile) => File(xfile.path)).toList();
      log('imageList length -------------------------${imageList.length}');
      // checking internet connectivity
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        try {
          if ((event.description != null && event.description != '') ||
              (event.audio != null && event.audio != '')) {
            log('audio file ---------------------${event.audio}');
            audioFile = event.audio;
            description = event.description;
            if (event.audio != null) {
              audio = await MultipartFile.fromFile(audioFile!,
                  filename: "audioDescription.m4a");
            }
            bool isValid = false;
            String videoAudioMsg = '';
            if (imageList.isNotEmpty || videoFiles.isNotEmpty) {
              isValid = true;
            } else {
              isValid = false;
              videoAudioMsg = 'please add atleast one video/image';
            }
            if (isValid) {
              emit(state.copyWith(
                isLoading: true,
              ));
              Response? response = await startServiceRepository.startServiceApi(
                  event.id, description, audio, StringConstants.startService);
              if (response != null) {
                if (response.statusCode == 200 || response.statusCode == 201) {
                  if (imageList.isNotEmpty) {
                    log('imagelist above api ----------------------------------${imageList.isNotEmpty}');
                    startServiceRepository.addVideoAndImages(
                        index: 0,
                        id: event.id,
                        fileType: "image",
                        imageList: imageList,
                        isPreCheck: true);
                  }
                  if (state.videoFiles.isNotEmpty) {
                    startServiceRepository.addVideoAndImages(
                        index: 0,
                        id: event.id,
                        fileType: "video",
                        imageList: state.videoFiles,
                        isPreCheck: true);
                  }
                  await userRepository
                      .setTripStatus(StringConstants.tripStartService);
                  emit(state.copyWith(isLoading: false, started: true));
                } else {
                  Fluttertoast.showToast(
                      msg: response.statusMessage ??
                          'Something went wrong !Please try agian.');
                  emit(state.copyWith(isLoading: false));
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'Network issue! Please try again..');
                emit(state.copyWith(isLoading: false));
              }
            } else {
              Fluttertoast.showToast(msg: videoAudioMsg);
              emit(state.copyWith(isLoading: false));
            }
          } else {
            log('audio file in else condition ---------------------${event.audio}');
            Fluttertoast.showToast(msg: 'Please add description(Audio/Text)');
          }
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      } else {
        log('internet connection is not there');
        Fluttertoast.showToast(
            msg: ' No internet, please check your connection');
      }
    });

    on<CleanServiceET>((event, emit) {
      emit(state.copyWith(
        images: [],
        videoFiles: [],
        thumbnail: [],
        isLoading: false,
        started: false,
        isLoadThumb: false,
      ));
    });
  }
}
