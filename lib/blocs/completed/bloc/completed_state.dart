// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'completed_bloc.dart';

@immutable
class CompletedState {
  final String? errorMsg;
  final List<ComplaintResult>? completedComplaints;
  final bool isLoading;
  final bool isPageLoading;
  final bool isNoInternet;
  const CompletedState({
    this.errorMsg,
    this.completedComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
    this.isNoInternet = false,
  });

  

  CompletedState copyWith({
    String? errorMsg,
    List<ComplaintResult>? completedComplaints,
    bool? isLoading,
    bool? isPageLoading,
    bool? isNoInternet,
  }) {
    return CompletedState(
      errorMsg: errorMsg ?? this.errorMsg,
      completedComplaints: completedComplaints ?? this.completedComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isNoInternet: isNoInternet ?? this.isNoInternet,
    );
  }
}