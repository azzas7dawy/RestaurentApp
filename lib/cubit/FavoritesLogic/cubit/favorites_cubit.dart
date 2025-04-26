import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirebaseFirestore firestore;
  final String userId;

  FavoritesCubit({
    required this.firestore,
    required this.userId,
  }) : super(FavoritesInitial()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final DocumentSnapshot doc =
          await firestore.collection('users2').doc(userId).get();
      if (doc.exists) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['favorites'] != null) {
          final List<Map<String, dynamic>> favorites =
              List<Map<String, dynamic>>.from(data['favorites'] as List);
          emit(FavoritesLoaded(favorites: favorites));
        } else {
          emit(FavoritesLoaded(favorites: []));
        }
      } else {
        emit(FavoritesLoaded(favorites: []));
      }
    } catch (error) {
      emit(FavoritesError(
          errorMessage: 'Failed to load favorites: ${error.toString()}'));
    }
  }

  Future<void> _updateFavoritesInFirestore(
      List<Map<String, dynamic>> favorites) async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'favorites': favorites,
      });
    } catch (error) {
      emit(FavoritesError(
          errorMessage: 'Failed to update favorites: ${error.toString()}'));
    }
  }

  Future<void> addToFavorites(Map<String, dynamic> meal) async {
    try {
      final FavoritesState currentState = state;
      if (currentState is FavoritesLoaded) {
        final List<Map<String, dynamic>> favorites =
            List<Map<String, dynamic>>.from(currentState.favorites);

        if (!favorites.any((Map<String, dynamic> favorite) =>
            favorite['documentId'] == meal['documentId'])) {
          favorites.add(meal);
          await _updateFavoritesInFirestore(favorites);
          emit(FavoritesLoaded(favorites: favorites));
        }
      }
    } catch (error) {
      emit(FavoritesError(
          errorMessage: 'Failed to add favorite: ${error.toString()}'));
    }
  }

  Future<void> removeFromFavorites(String documentId) async {
    try {
      final FavoritesState currentState = this.state;
      if (currentState is FavoritesLoaded) {
        final List<Map<String, dynamic>> favorites =
            List<Map<String, dynamic>>.from(currentState.favorites)
              ..removeWhere((Map<String, dynamic> favorite) =>
                  favorite['documentId'] == documentId);
        await _updateFavoritesInFirestore(favorites);
        emit(FavoritesLoaded(favorites: favorites));
      }
    } catch (error) {
      emit(FavoritesError(
          errorMessage: 'Failed to remove favorite: ${error.toString()}'));
    }
  }
}
