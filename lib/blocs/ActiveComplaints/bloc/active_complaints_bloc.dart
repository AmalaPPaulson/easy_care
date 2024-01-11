import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'active_complaints_event.dart';
part 'active_complaints_state.dart';

class ActiveComplaintsBloc
    extends Bloc<ActiveComplaintsEvent, ActiveComplaintsState> {
  List<ComplaintResult> activeResult = [];
  ComplaintRepository complaintRepository = ComplaintRepository();
  int pageNo = 1;
  ComplaintModel complaintModel = ComplaintModel();
  bool isThereNextPage = false;
  ActiveComplaintsBloc() : super(const ActiveComplaintsState()) {
    // here fetching active complaints from backend and passing it in to a model. and emiting this model using bloc state

    on<GetAcitveComplaintsET>((event, emit) async {
      // checking internet connectivity
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        try {
          if (!event.isRefreshed) {
            emit(state.copyWith(isLoading: true));
          }
          pageNo = 1;
          Response? response = await complaintRepository.getActiveList(pageNo);
          if (response!.statusCode == 200) {
            complaintModel = ComplaintModel.fromJson(response.data);
            if (complaintModel.results != null &&
                complaintModel.results!.isNotEmpty) {
              if (complaintModel.next != null && complaintModel.next != '') {
                isThereNextPage = true;
              } else {
                isThereNextPage = false;
              }
              activeResult.clear();
              activeResult.addAll(complaintModel.results!);
              emit(ActiveComplaintsState(activeComplaints: activeResult));
            } else {
              emit(const ActiveComplaintsState(
                  errorMsg: 'No Active trip Available'));
            }
          } else {
            emit(ActiveComplaintsState(errorMsg: response.statusMessage));
          }
        } catch (e) {
          emit(ActiveComplaintsState(errorMsg: e.toString()));
        }
      } else {
        emit(const ActiveComplaintsState(isNoInternet: true));
      }
    });

    //Pagenation
    on<PagenatedActiveEvent>((event, emit) async {
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
                await complaintRepository.getActiveList(pageNo);
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
                emit(const ActiveComplaintsState(
                    errorMsg: 'No Active trip Available'));
              }
              activeResult.addAll(complaintModel.results!);
              emit(ActiveComplaintsState(activeComplaints: activeResult));
            } else {
              isThereNextPage = false;
              emit(ActiveComplaintsState(errorMsg: response.statusMessage));
            }
          }
        } catch (e) {
          isThereNextPage = false;
          emit(ActiveComplaintsState(errorMsg: e.toString()));
        }
      } else {
        log('internet connection is not there');
        Fluttertoast.showToast(
            msg: ' No internet, please check your connection');
      }
    });
  }
}
