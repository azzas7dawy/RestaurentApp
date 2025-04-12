part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Map<String, dynamic>> favorites;

  FavoritesLoaded({required this.favorites});
}

class FavoritesError extends FavoritesState {
  final String errorMessage;

  FavoritesError({required this.errorMessage});
}
