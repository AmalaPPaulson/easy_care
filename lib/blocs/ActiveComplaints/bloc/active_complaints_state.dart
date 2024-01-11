// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'active_complaints_bloc.dart';

@immutable
class ActiveComplaintsState {
  final String? errorMsg;
  final List<ComplaintResult>? activeComplaints;
  final bool isLoading;
  final bool isPageLoading;
  final bool isNoInternet;

  const ActiveComplaintsState({
    this.errorMsg,
    this.activeComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
    this.isNoInternet = false,
  });

  

  ActiveComplaintsState copyWith({
    String? errorMsg,
    List<ComplaintResult>? activeComplaints,
    bool? isLoading,
    bool? isPageLoading,
    bool? isNoInternet,
  }) {
    return ActiveComplaintsState(
      errorMsg: errorMsg ?? this.errorMsg,
      activeComplaints: activeComplaints ?? this.activeComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isNoInternet: isNoInternet ?? this.isNoInternet,
    );
  }
}
