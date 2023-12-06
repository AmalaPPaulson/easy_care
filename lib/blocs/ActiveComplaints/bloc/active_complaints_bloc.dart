import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/model/complaint_model.dart';
import 'package:easy_care/repositories/complaint_repo.dart';
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
      try {
      
        if (!event.isRefreshed) {
          emit(state.copyWith(isLoading: true));
        }
        pageNo=1;
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
    });


        //Pagenation
    on<PagenatedActiveEvent>((event, emit) async {
      try {
        if(state.isPageLoading || state.isLoading){
          return;
        }
        if (isThereNextPage) {
          emit(state.copyWith(isPageLoading: true));
          pageNo++;

          Response? response =
              await complaintRepository.getActiveList(pageNo);

          if (response!.statusCode == 200)   {
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
              emit(const ActiveComplaintsState(errorMsg: 'No Active trip Available'));
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
    });
  }
}
