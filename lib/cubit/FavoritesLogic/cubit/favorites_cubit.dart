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
// =======================================================================================
  Future<void> _loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final doc = await firestore.collection('users2').doc(userId).get();
      if (doc.exists && doc.data()?['favorites'] != null) {
        final favorites =
            List<Map<String, dynamic>>.from(doc.data()?['favorites'] ?? []);
        emit(FavoritesLoaded(favorites: favorites));
      } else {
        emit(FavoritesLoaded(favorites: []));
      }
    } catch (e) {
      emit(FavoritesError(
          errorMessage: 'Failed to load favorites: ${e.toString()}'));
    }
  }

// =======================================================================================

  Future<void> _updateFavoritesInFirestore(
      List<Map<String, dynamic>> favorites) async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'favorites': favorites,
      });
    } catch (e) {
      emit(FavoritesError(
          errorMessage: 'Failed to update favorites: ${e.toString()}'));
    }
  }

// =======================================================================================

  Future<void> addToFavorites(Map<String, dynamic> meal) async {
    try {
      final state = this.state;
      if (state is FavoritesLoaded) {
        final favorites = List<Map<String, dynamic>>.from(state.favorites);

        if (!favorites.any((fav) => fav['title'] == meal['title'])) {
          favorites.add(meal);
          await _updateFavoritesInFirestore(favorites);
          emit(FavoritesLoaded(favorites: favorites));
        }
      }
    } catch (e) {
      emit(FavoritesError(
          errorMessage: 'Failed to add favorite: ${e.toString()}'));
    }
  }

// =======================================================================================

  Future<void> removeFromFavorites(String mealTitle) async {
    try {
      final state = this.state;
      if (state is FavoritesLoaded) {
        final favorites = List<Map<String, dynamic>>.from(state.favorites)
          ..removeWhere((fav) => fav['title'] == mealTitle);
        await _updateFavoritesInFirestore(favorites);
        emit(FavoritesLoaded(favorites: favorites));
      }
    } catch (e) {
      emit(FavoritesError(
          errorMessage: 'Failed to remove favorite: ${e.toString()}'));
    }
  }

// =======================================================================================

  // bool isFavorite(String mealTitle) {
  //   final state = this.state;
  //   if (state is FavoritesLoaded) {
  //     return state.favorites.any((fav) => fav['title'] == mealTitle);
  //   }
  //   return false;
  // }
}
