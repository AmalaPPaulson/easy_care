import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/trip_repo.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:meta/meta.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripRepository tripRepository = TripRepository();
  UserRepository userRepository = UserRepository();
  TripBloc() : super(const TripState()) {
    //here status of the complaint changing to in travelling and fetch the location of start trip
    on<UpdateStatusET>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        Position? position;

        /// Determine the current position of the device.
        /// When the location services are not enabled or permissions
        /// are denied the `Future` will return an error.
        bool serviceEnabled;
        LocationPermission permission;

        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // Location services are not enabled don't continue
          // accessing the position and request users of the
          // App to enable the location services.
          return Future.error('Location services are disabled.');
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return Future.error('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        // When we reach here, permissions are granted and we can
        // continue accessing the position of the device.
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        DateTime start = DateTime.now();
        String startTime = start.toString();
        emit(state.copyWith(
          startPosition: position,
          startTime: start,
        ));
        log('start position : ${position.latitude},start time: $start');
        Response? response =
            await tripRepository.updateStatus(event.status, event.complaintId);
        log('api response ${response!.statusCode}');
        if (response.statusCode == 200) {
          await userRepository.setTripStatus(StringConstants.startTrip);
          await userRepository.setIsStartTrip(true);
          await userRepository.setStarLatitude(position.latitude);
          await userRepository.setStartLongitude(position.longitude);
          await userRepository.setStartTime(startTime);
          emit(state.copyWith(isLoading: false, started: true));
        } else {
          log('api response in the error : ${response.data.toString()}');
          log('api response in the error : ${response.statusCode.toString()}');
          log('api response in the error : ${response.statusMessage.toString()}');
          emit(state.copyWith(isLoading: false));
          emit(const TripState(errorMsg: 'unable to update status'));
        }
      } catch (e) {
        emit(TripState(errorMsg: e.toString()));
      }
    });

    //here tracking the final location and uploading duration & start and final location of the trip
    on<TrackingET>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        Position? position;

        /// Determine the current position of the device.
        /// When the location services are not enabled or permissions
        /// are denied the `Future` will return an error.
        bool serviceEnabled;
        LocationPermission permission;

        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // Location services are not enabled don't continue
          // accessing the position and request users of the
          // App to enable the location services.
          return Future.error('Location services are disabled.');
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return Future.error('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        DateTime end = DateTime.now();
        emit(state.copyWith(finalPosition: position, endTime: end));
        log('final position : ${position.latitude},end time: $end');
       
        
        double? startLatitude = userRepository.getStartLatitude();
        double? startLongitude = userRepository.getStartLongitude();
        String? startTime = userRepository.getStartTime();
        log('start latitude : $startLatitude');
        if ( startLatitude != null) {
          
          double endLat = position.latitude;
          double endLong = position.longitude;
          
         
          String id = event.id.toString();
          DateTime end = state.endTime!;
          DateTime start = DateTime.parse(startTime!);

          final difference = end.difference(start).inMinutes;
          String duration = difference.toString();
          duration += 'Minutes';
          log('time duration ----------------$duration');
          Response? response = await tripRepository.trackingApi(
            id,
            duration,
            startLatitude,
            endLat,
            startLongitude!,
            endLong,
          );
          if (response!.statusCode == 200 || response.statusCode == 201) {
            await userRepository
                .setTripStatus(StringConstants.reachDestination);
            emit(state.copyWith(isLoading: false, reached: true));
          } else {
            log('api response in the error : ${response.data.toString()}');
            log('api response in the error : ${response.statusCode.toString()}');
            log('api response in the error : ${response.statusMessage.toString()}');
            emit(state.copyWith(errorMsg: 'Unable to update status '));
          }
        } else { 
          Fluttertoast.showToast(
              msg: 'start position and end position are not fetched ');
        }
      } catch (e) {
        emit(state.copyWith(errorMsg: 'Unable to upload end position '));
      }
    });
  }
}
