part of 'rescheduled_bloc.dart';

@immutable
class RescheduledState {
  final String? errorMsg;
  final List<ComplaintResult>? rescheduledComplaints;
  final bool isLoading;
  final bool isPageLoading;
  const RescheduledState({
    this.errorMsg,
    this.rescheduledComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
  });

  

  RescheduledState copyWith({
    String? errorMsg,
    List<ComplaintResult>? rescheduledComplaints,
    bool? isLoading,
    bool? isPageLoading,
  }) {
    return RescheduledState(
      errorMsg: errorMsg ?? this.errorMsg,
      rescheduledComplaints: rescheduledComplaints ?? this.rescheduledComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    );
  }
 }


