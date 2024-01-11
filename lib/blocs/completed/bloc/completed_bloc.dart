import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'completed_event.dart';
part 'completed_state.dart';

class CompletedBloc extends Bloc<CompletedEvent, CompletedState> {
  ComplaintRepository complaintRepository = ComplaintRepository();
  List<ComplaintResult> completedResult = [];
  int pageNo = 1;
  ComplaintModel complaintModel = ComplaintModel();
  bool isThereNextPage = false;
  CompletedBloc() : super(const CompletedState()) {
    // here fetching completed complaints from backend and passing it in to a model.
    //here also checking whether model is emplty or null to avoid null cheack operator
    //Also setting pagination to the list
    //if any error or empty list showed then it calls another widget to show the message
    // add shimmer effect for loading
    on<GetCompletedET>((event, emit) async {
      // checking internet connectivity
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        try {
          if (!event.isRefreshed) {
            emit(state.copyWith(isLoading: true));
          }
          pageNo = 1;
          Response? response =
              await complaintRepository.getCompletedList(pageNo);
          if (response!.statusCode == 200) {
            complaintModel = ComplaintModel.fromJson(response.data);
            if (complaintModel.results != null &&
                complaintModel.results!.isNotEmpty) {
              if (complaintModel.next != null && complaintModel.next != '') {
                isThereNextPage = true;
              } else {
                isThereNextPage = false;
              }
              completedResult.clear();
              completedResult.addAll(complaintModel.results!);
              emit(CompletedState(completedComplaints: completedResult));
            } else {
              emit(const CompletedState(errorMsg: 'No Active trip Available'));
            }
          } else {
            emit(CompletedState(errorMsg: response.statusMessage));
          }
        } catch (e) {
          emit(CompletedState(errorMsg: e.toString()));
        }
      } else {
        emit(const CompletedState(isNoInternet: true));
        log('internet connection is not there');
        
      }
    });

    //Pagenation
    on<PagenatedCompleteEvent>((event, emit) async {
      // checking internet connectivity
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        try {
          if (state.isPageLoading || state.isLoading) {
            return;
          }
          if (isThereNextPage) {
            emit(state.copyWith(isPageLoading: true));
            pageNo++;

            Response? response =
                await complaintRepository.getCompletedList(pageNo);

            if (response!.statusCode == 200) {
              complaintModel = ComplaintModel.fromJson(response.data);

              if (complaintModel.results != null &&
                  complaintModel.results!.isNotEmpty) {
                if (complaintModel.next != null && complaintModel.next != '') {
                  isThereNextPage = true;
                } else {
                  isThereNextPage = false;
                }
              } else {
                isThereNextPage = false;
                emit(
                    const CompletedState(errorMsg: 'No Active trip Available'));
              }

              completedResult.addAll(complaintModel.results!);

              emit(CompletedState(completedComplaints: completedResult));
            } else {
              isThereNextPage = false;
              emit(CompletedState(errorMsg: response.statusMessage));
            }
          }
        } catch (e) {
          isThereNextPage = false;
          emit(CompletedState(errorMsg: e.toString()));
        }
      } else {
        log('internet connection is not there');
        Fluttertoast.showToast(
            msg: ' No internet, please check your connection');
      }
    });
  }
}
