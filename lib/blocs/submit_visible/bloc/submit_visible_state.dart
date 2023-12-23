// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'submit_visible_bloc.dart';

@immutable
class SubmitVisibleState {
  final bool isShow;
  final bool isVisible;
  final bool card;
  const SubmitVisibleState({
     this.isShow =true,
    this.isVisible= true,
     this.card = false,
  });

  

  SubmitVisibleState copyWith({
    bool? isShow,
    bool? isVisible,
    bool? card,
  }) {
    return SubmitVisibleState(
      isShow: isShow ?? this.isShow,
      isVisible: isVisible ?? this.isVisible,
      card: card ?? this.card,
    );
  }
 }


