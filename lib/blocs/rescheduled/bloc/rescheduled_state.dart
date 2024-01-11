// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rescheduled_bloc.dart';

@immutable
class RescheduledState {
  final String? errorMsg;
  final List<ComplaintResult>? rescheduledComplaints;
  final bool isLoading;
  final bool isPageLoading;
  final bool isNoInternet;
  const RescheduledState({
    this.errorMsg,
    this.rescheduledComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
    this.isNoInternet = false,
  });

  

  RescheduledState copyWith({
    String? errorMsg,
    List<ComplaintResult>? rescheduledComplaints,
    bool? isLoading,
    bool? isPageLoading,
    bool? isNoInternet,
  }) {
    return RescheduledState(
      errorMsg: errorMsg ?? this.errorMsg,
      rescheduledComplaints: rescheduledComplaints ?? this.rescheduledComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isNoInternet: isNoInternet ?? this.isNoInternet,
    );
  }
}
