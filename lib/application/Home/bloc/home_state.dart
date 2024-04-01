part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Song>? songs;

  HomeLoaded(this.songs);
}

class HomeDataNotLoaded extends HomeState {}

class HomeLoadingError extends HomeState {
  final String message;

  HomeLoadingError({required this.message});
}
