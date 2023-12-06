part of 'completed_bloc.dart';

@immutable
class CompletedState {
  final String? errorMsg;
  final List<ComplaintResult>? completedComplaints;
  final bool isLoading;
  final bool isPageLoading;
  const CompletedState({
    this.errorMsg,
    this.completedComplaints,
    this.isLoading = false,
    this.isPageLoading = false,
  });

 

  CompletedState copyWith({
    String? errorMsg,
    List<ComplaintResult>? completedComplaints,
    bool? isLoading,
    bool? isPageLoading,
  }) {
    return CompletedState(
      errorMsg: errorMsg ?? this.errorMsg,
      completedComplaints: completedComplaints ?? this.completedComplaints,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    );
  }
}


// class CompletedPageLoadingST extends CompletedState {}

// class CompletedPageLoadedST extends CompletedState {}

// class CompletedFailureST extends CompletedState {
//   final String? errorMsg;

//   CompletedFailureST({required this.errorMsg});
// }


// class LoadedCompletedST extends CompletedState {
//   final bool? hasError;
//   final List<ComplaintResult>? completedResult;

//   LoadedCompletedST({this.hasError, this.completedResult});
// }

// class PagenationLoadingST extends CompletedState{}

// class PagenationLoadedST extends CompletedState{}