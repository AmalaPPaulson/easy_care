import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:easy_care/utils/api_query.dart';
import 'package:easy_care/utils/constants/api_constants.dart';

class StartServiceRepository {
  ApiQuery apiQuery = ApiQuery();

  //updateing status of trip to  ongoing and adding audio and textfield
  // decription to backend
  Future<Response?> startServiceApi(String id, String? description,
      MultipartFile? audio, String status) async {
    try {
      Map<String, dynamic> data = {
        "status": status,
        "reason": '',
        "pre_summary": description,
        "pre_summary_audio": audio,
      };
      log('Complaint id : $id');
      FormData formData = FormData.fromMap(data);
      Response? response = await apiQuery.patchQuery(
          '${APIConstants.apiUpdateStatus}$id/', formData, status, true);
      log('responsein the start serviceapi $response');
      return response;
    } catch (exception) {
      return null;
    }
  }

  //uploading video files and images to the backend
  Future<bool?> addVideoAndImages({
    required int index,
    required String id,
    String? fileType,
    required List<File>? imageList,
    required isPreCheck,
  }) async {
    Map<String, dynamic> data = {};
    MultipartFile? imageFile;
    imageFile = null;

   
    DateTime now = DateTime.now();
    String d = now.toString();
    d = d.replaceAll(':', '');
    d = d.replaceAll(',', '');
    d = d.replaceAll(' ', '');
    d = d.replaceAll('-', '');
    d = d.replaceAll('.', '');
    d = d.trim();
    var image = File(imageList![index].path);
    imageFile = await MultipartFile.fromFile(
      image.path,
      filename: (fileType == 'video') ? "${d}clip.mp4" : "${d}img.jpg",
    );

    try {
      data = {
        "assignment": id,
        "sender": "Technician",
        "message": " ",
        "file": imageFile,
        "file_type": fileType,
        "is_user_message": true,
        "is_status_change": false,
        "is_pre_check_message": isPreCheck
      };

      Map<String, String> headers = {
        //'Content-Type': 'application/json',
      };

      FormData formData = FormData.fromMap(data);

      Response? response =
          await apiQuery.postQuery(APIConstants.addLog, headers, formData, '');
          
           
      log('response in the addaudiovideoApi-------------');
      log('------------------ response of addvideoimg api ${response!.data.toString()}');
       log('api response in the success : ${response.statusCode.toString()}');
            log('api response in the success : ${response.statusMessage.toString()}');
       log('imageList length ---------------------------${imageList.length}');
      //if (response != null) {
        if (response.statusCode == 201) {
          if (index < imageList.length - 1) {
            index = index + 1;
            return await addVideoAndImages(
                fileType: fileType,
                index: index,
                id: id,
                imageList: imageList,
                isPreCheck: isPreCheck);
          } else {
            return true;
          }
        }
      //}
    } catch (exception) {}
    return false;
  }

  //Submit Report
  Future<Response?> submitReport(String id, Map<String, dynamic>? data) async {
    try {
      Response? response = await apiQuery.patchQuery(
        '${APIConstants.apiUpdateStatus}$id/',
        data,
        'ChangeStatusApi',
        true,
      );
      return response;
    } catch (exception) {
      return null;
    }
  }
}
