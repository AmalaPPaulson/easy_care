import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/utils/api_query.dart';
import 'package:easy_care/utils/constants/api_constants.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  ApiQuery apiQuery = ApiQuery();
 ComplaintModel complaintModel = ComplaintModel();
  //Login
  Future<Response?> login(String phoneNo, String pin) async {
    try {
      Map<String, dynamic> body = {
        "username": phoneNo,
        "password": pin,
        // "fcm_token": fcmToken
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Response? response = await apiQuery.postQuery(
          APIConstants.apiLogin, headers, body, 'Login');
      return response;
    } catch (exception) {
      return null;
    }
  }

  //Logout
  Future<Response?> logout() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {};

      Response? response = await apiQuery.postQuery(
          APIConstants.apiLogout, headers, body, 'Logout');
      return response;
    } catch (exception) {
      return null;
    }
  }

  static late final SharedPreferences prefs;

  Future<void> initLocal() async {
    prefs = await SharedPreferences.getInstance();
  }

  //Set is Logged
  Future<bool> setIsLogged(bool isLogged) async {
    return await prefs.setBool(StringConstants.IS_LOGGED_IN, isLogged);
  }

  //Get Is Logged
  bool getIsLogged() {
    return prefs.getBool(StringConstants.IS_LOGGED_IN) ?? false;
  }

  //Set is Logged
  Future<bool> setIsStartTrip(bool isStartTrip) async {
    return await prefs.setBool(StringConstants.IS_START_TRIP, isStartTrip);
  }

  //Get Is Logged
  bool getIsStartTrip() {
    return prefs.getBool(StringConstants.IS_START_TRIP) ?? false;
  }

  //storing complaint list of a case in to a string then save that string to shared preference
  Future<bool> setComplaint(ComplaintResult  complaintResult)async{
   
   String activeComplaint = jsonEncode(complaintResult);
   return prefs.setString('activeComplaint',activeComplaint );
  }
  
  //getting the string value stored in the shared prefence and decode in to a complaint model
  ComplaintResult getComplaint(){
    String? activeComplaint = prefs.getString('activeComplaint');
   return  ComplaintResult.fromJson(jsonDecode(activeComplaint!));
  }

}
