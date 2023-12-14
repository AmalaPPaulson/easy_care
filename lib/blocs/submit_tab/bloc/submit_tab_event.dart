part of 'submit_tab_bloc.dart';

@immutable
sealed class SubmitTabEvent {}
class TabClickET extends SubmitTabEvent {
  final int tabNo;
  TabClickET({
    required this.tabNo,
  });
}