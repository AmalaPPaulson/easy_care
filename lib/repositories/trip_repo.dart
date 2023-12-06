import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_care/utils/api_query.dart';
import 'package:easy_care/utils/constants/api_constants.dart';


class TripRepository{
  ApiQuery apiQuery = ApiQuery();

//UPDATE STATUS OF TRIP
  Future<Response?> updateStatus(String status,String complaintId) async {
    try {
       Map data = {
        "status": status,
        "reason": '',
      };

      log('Complaint id : $complaintId');
      

      Response? response =
      await apiQuery.patchQuery('${APIConstants.apiUpdateStatus}$complaintId/', data,'updateStatus',true);
      log('responsein the api $response');
      return response;
    } catch (exception) {
      return null;
    }
  }

  //sending the start and end position of trip to track the technician
  Future<Response?> trackingApi(String id,String duration,double startLat,double endLat,double startlong,double endLong) async {
    try {

      Map data = {
        "assigned_complaint": id,
        "duration": duration,
        "latitude_start": startLat,
        "longitude_start": startlong,
        "latitude_ending": endLat,
        "longitude_ending": endLong,
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Response? response =
      await apiQuery.postQuery(APIConstants.apiUpdateLocation, headers, data, 'tracking Api');
      return response;
    } catch (exception) {
      return null;
    }
  }

}