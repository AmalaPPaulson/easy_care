import 'package:dio/dio.dart';
import 'package:easy_care/utils/api_query.dart';
import 'package:easy_care/utils/constants/api_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintRepository {
  ApiQuery apiQuery = ApiQuery();


    Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }  


  //Api to get active compalint list
  Future<Response?> getActiveList(int? pageNo) async {
    try {
      Map<String, String> headers = {};

      Map<String, String> query = {'page': pageNo.toString()};

      Response? response = await apiQuery.getQuery(APIConstants.apiActiveList,
          headers, query, 'Active Complaint List', true, true, true);
      return response;
    } catch (exception) {
      return null;
    }
  }

  //Api to get Completed complaint list
  Future<Response?> getCompletedList(int? pageNo) async {
    try {
      Map<String, String> headers = {};

      Map<String, String> query = {'page': pageNo.toString()};

      Response? response = await apiQuery.getQuery(APIConstants.apiCompletedList,
          headers, query, 'Completed Complaint List', true, true, true);
      return response;
    } catch (exception) {
      return null;
    }
  }

  //Api to get Rescheduled complaint list
  Future<Response?> getRescheduledList(int? pageNo) async {
    try {
      Map<String, String> headers = {
        
      };

      Map<String, String> query = {'page': pageNo.toString()};

      Response? response = await apiQuery.getQuery(APIConstants.apiRescheduledList,
          headers, query, 'Rescheduled Complaint List', true, true, true);
      return response;
    } catch (exception) {
      return null;
    }
  }



}
