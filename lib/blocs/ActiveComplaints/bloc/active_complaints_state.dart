part of 'active_complaints_bloc.dart';

@immutable
class ActiveComplaintsState {
  final String? errorMsg;
  final List<ComplaintResult>? activeComplaints;
  final bool isLoading;
  final bool isPageLoading;
  
  const ActiveComplaintsState({
    this.errorMsg,
    this.activeComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
   
  });

  

  

  ActiveComplaintsState copyWith({
    String? errorMsg,
    List<ComplaintResult>? activeComplaints,
    bool? isLoading,
    bool? isPageLoading,
    
  }) {
    return ActiveComplaintsState(
      errorMsg: errorMsg ?? this.errorMsg,
      activeComplaints: activeComplaints ?? this.activeComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      
    );
  }
}



