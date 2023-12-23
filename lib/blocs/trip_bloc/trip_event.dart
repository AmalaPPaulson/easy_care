part of 'trip_bloc.dart';

@immutable
sealed class TripEvent {}


class UpdateStatusET extends TripEvent {
  final String status;
  final String complaintId;
 
  UpdateStatusET({
    required this.status,
    required this.complaintId,
    
  });
  
}
class TrackingET extends TripEvent {
  final String id;
  TrackingET({
    required this.id,
  });

}


