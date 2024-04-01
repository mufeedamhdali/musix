part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadDataEvent extends HomeEvent {}

class UpdateFavoriteEvent extends HomeEvent {
  final String docId;
  final bool value;

  UpdateFavoriteEvent({required this.docId, required this.value});
}