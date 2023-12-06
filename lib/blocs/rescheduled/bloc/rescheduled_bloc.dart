import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
import 'package:meta/meta.dart';

part 'rescheduled_event.dart';
part 'rescheduled_state.dart';

class RescheduledBloc extends Bloc<RescheduledEvent, RescheduledState> {
  ComplaintRepository complaintRepository = ComplaintRepository();
  List<ComplaintResult> rescheduledResult = [];
  int pageNo = 1;
  ComplaintModel rescheduledModel = ComplaintModel();
  bool isThereNextPage = false;
  RescheduledBloc() : super(const RescheduledState()) {



    on<GetRescheduledET>((event, emit) async {
      try{

        if (!event.isRefreshed) {
          emit(state.copyWith(isLoading: true));
        }
         pageNo = 1;
         Response? response = await complaintRepository.getRescheduledList(pageNo);
         if (response!.statusCode == 200) {
            rescheduledModel = ComplaintModel.fromJson(response.data);
            if (rescheduledModel.results != null &&
              rescheduledModel.results!.isNotEmpty) {
            if (rescheduledModel.next != null && rescheduledModel.next != '') {
              isThereNextPage = true;
            } else {
              isThereNextPage = false;
            }
            rescheduledResult.clear();
            rescheduledResult.addAll(rescheduledModel.results!);
            emit(RescheduledState(rescheduledComplaints: rescheduledResult));
         }
         else {
            emit(const RescheduledState(errorMsg: 'No Active trip Available'));
          }
         
         } else {
          emit(RescheduledState(errorMsg: response.statusMessage));
        }
         }catch(e){
        emit(RescheduledState(errorMsg: e.toString()));
      }
    });


    //Pagenation
    on<PagenatedRescheduledEvent>((event, emit) async {
      try {
        if(state.isPageLoading || state.isLoading){
          return;
        }
        if (isThereNextPage) {
          emit(state.copyWith(isPageLoading: true));
          pageNo++;

          Response? response =
              await complaintRepository.getCompletedList(pageNo);

          if (response!.statusCode == 200)   {
            rescheduledModel = ComplaintModel.fromJson(response.data);

            if (rescheduledModel.results != null &&
                rescheduledModel.results!.isNotEmpty) {
              if (rescheduledModel.next != null && rescheduledModel.next != '') {
                isThereNextPage = true;
              } else {
                isThereNextPage = false;
              }
            } else {
              isThereNextPage = false;
              emit(const RescheduledState(errorMsg: 'No Active trip Available'));
            }

            rescheduledResult.addAll(rescheduledModel.results!);
           
            emit(RescheduledState(rescheduledComplaints: rescheduledResult));
          } else {
            isThereNextPage = false;
            emit(RescheduledState(errorMsg: response.statusMessage));
          }
        }
      } catch (e) {
        isThereNextPage = false;
        emit(RescheduledState(errorMsg: e.toString()));
      }
    });
  }


    
  }

