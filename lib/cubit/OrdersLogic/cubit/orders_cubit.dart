import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirebaseFirestore firestore;
  final String userId;

  List<Map<String, dynamic>> meals = [];

  OrdersCubit({
    required this.firestore,
    required this.userId,
  }) : super(OrdersInitial()) {
    _loadCartFromFirestore();
  }

  Future<void> _loadCartFromFirestore() async {
    try {
      final doc = await firestore.collection('users2').doc(userId).get();
      if (doc.exists && doc.data()?['cartItems'] != null) {
        meals = List<Map<String, dynamic>>.from(doc.data()?['cartItems'] ?? []);
        emit(OrdersLoaded(meals: meals));
      }
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to load cart: ${e.toString()}'));
    }
  }
// ===============================================================================================

  void loadMeals(List<Map<String, dynamic>> initialMeals) {
    meals = List.from(initialMeals);
    emit(OrdersLoaded(meals: meals));
  }

// ===================================================================================================
  void incrementQuantity(int index) {
    meals[index]['quantity'] = (meals[index]['quantity'] ?? 1) + 1;
    _updateCartInFirestore();
    emit(OrdersLoaded(meals: meals));
  }

// ===================================================================================================
  void decrementQuantity(int index) {
    if (meals[index]['quantity'] > 1) {
      meals[index]['quantity'] = meals[index]['quantity'] - 1;
      _updateCartInFirestore();
      emit(OrdersLoaded(meals: meals));
    }
  }

// ===================================================================================================
  void removeMeal(int index) {
    meals.removeAt(index);
    _updateCartInFirestore();
    emit(OrdersLoaded(meals: meals));
  }

// ===================================================================================================
  double calculateTotal() {
    return meals.fold(0, (total, meal) {
      return total + (meal['price'] * (meal['quantity'] ?? 1));
    });
  }

// ===================================================================================================
  Future<void> submitOrder() async {
    emit(OrdersLoading());
    try {
      await firestore.collection('orders').add({
        'userId': userId,
        'items': meals,
        'total': calculateTotal(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      await _clearCart();
      meals.clear();
      emit(OrdersSubmissionSuccess());
    } catch (e) {
      emit(OrdersSubmissionError(errorMessage: e.toString()));
    }
  }

// ===================================================================================================
  Future<void> _updateCartInFirestore() async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'cartItems': meals,
      });
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to update cart: ${e.toString()}'));
    }
  }

// ===================================================================================================
  Future<void> _clearCart() async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'cartItems': [],
      });
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to clear cart: ${e.toString()}'));
    }
  }

// ===================================================================================================
  void addMeal(Map<String, dynamic> meal) {
    final existingIndex = meals.indexWhere((m) => m['title'] == meal['title']);

    if (existingIndex != -1) {
      meals[existingIndex]['quantity'] =
          (meals[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      meals.add({...meal, 'quantity': 1});
    }

    _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }
}
