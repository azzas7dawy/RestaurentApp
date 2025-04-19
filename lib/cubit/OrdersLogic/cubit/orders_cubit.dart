import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirebaseFirestore firestore;
  final String userId;

  List<Map<String, dynamic>> meals = [];
  String? _phoneNumber;
  String? _deliveryAddress;
  String? _customerName;
  bool _isLoadingCart = false;

  OrdersCubit({
    required this.firestore,
    required this.userId,
  }) : super(OrdersInitial()) {
    _loadCartFromFirestore();
    _loadCustomerName();
  }

  Future<void> _loadCustomerName() async {
    try {
      final doc = await firestore.collection('users2').doc(userId).get();
      if (doc.exists) {
        _customerName = doc.data()?['name'] ?? 'Unknown';
      }
    } catch (e) {
      _customerName = 'Unknown';
    }
  }

  Future<void> _loadCartFromFirestore() async {
    if (_isLoadingCart) return;
    _isLoadingCart = true;
    emit(OrdersLoading());
    try {
      final doc = await firestore.collection('users2').doc(userId).get();
      if (doc.exists && doc.data()?['cartItems'] != null) {
        meals = List<Map<String, dynamic>>.from(doc.data()?['cartItems'] ?? [])
            .map((meal) => {
                  ...meal,
                  'quantity': meal['quantity'] ?? 1,
                })
            .toList();
      } else {
        meals = [];
      }
      emit(OrdersLoaded(meals: List.from(meals)));
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to load cart: ${e.toString()}'));
    } finally {
      _isLoadingCart = false;
    }
  }

  void loadMeals(List<Map<String, dynamic>> initialMeals) {
    meals = List.from(initialMeals);
    _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }

  void incrementQuantity(int index) {
    meals[index]['quantity'] = (meals[index]['quantity'] ?? 1) + 1;
    _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }

  void decrementQuantity(int index) {
    if (meals[index]['quantity'] > 1) {
      meals[index]['quantity'] = meals[index]['quantity'] - 1;
      _updateCartInFirestore();
      emit(OrdersLoaded(meals: List.from(meals)));
    }
  }

  void removeMeal(int index) async {
    meals.removeAt(index);
    await _updateCartInFirestore(); // مهم جدًا لحذف البيانات من Firestore
    emit(OrdersLoaded(meals: List.from(meals)));
  }

  double calculateTotal() {
    return meals.fold(0.0, (double total, meal) {
      final price = meal['price'] is int
          ? (meal['price'] as int).toDouble()
          : meal['price'] as double? ?? 0.0;
      final quantity = meal['quantity'] is int
          ? (meal['quantity'] as int).toDouble()
          : meal['quantity'] as double? ?? 1.0;
      return total + (price * quantity);
    });
  }

  Future<void> _updateCartInFirestore() async {
    try {
      await firestore.collection('users2').doc(userId).set({
        'cartItems': meals,
      }, SetOptions(merge: true));
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to update cart: ${e.toString()}'));
    }
  }

  Future<void> _clearCart() async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'cartItems': [],
      });
      meals.clear(); // مهم جدًا لمسح البيانات من الذاكرة بعد حفظها
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to clear cart: ${e.toString()}'));
    }
  }

  void setDeliveryInfo({required String phone, required String address}) {
    _phoneNumber = phone;
    _deliveryAddress = address;
  }

  Future<void> submitOrder({
    required String paymentMethod,
    required double totalAmount,
    required double discountAmount,
    bool isPaid = false,
  }) async {
    emit(OrdersLoading());
    try {
      if (_phoneNumber == null || _deliveryAddress == null) {
        throw Exception('Phone number and delivery address are required');
      }
      if (_customerName == null) {
        await _loadCustomerName();
      }

      final List<Map<String, dynamic>> orderItems = meals.map((meal) {
        return {
          'title': meal['title']?.toString() ?? 'Unknown Item',
          'quantity': meal['quantity'] ?? 1,
          'price': meal['price']?.toDouble() ?? 0.0,
        };
      }).toList();

      await firestore.collection('orders').add({
        'userId': userId,
        'customer': _customerName ?? 'Unknown',
        'orderItems': orderItems,
        'total': totalAmount,
        'discountApplied': discountAmount,
        'paymentMethod': paymentMethod,
        'phoneNumber': _phoneNumber,
        'deliveryAddress': _deliveryAddress,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      await _clearCart();
      emit(OrdersLoaded(meals: List.from(meals)));
      emit(OrdersSubmissionSuccess());
    } catch (e) {
      emit(OrdersSubmissionError(errorMessage: e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).delete();
      emit(OrdersSubmissionSuccess());
    } catch (e) {
      emit(OrdersSubmissionError(
          errorMessage: 'Failed to delete order: ${e.toString()}'));
    }
  }

  Future<void> addMeal(Map<String, dynamic> meal) async {
    while (_isLoadingCart) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // emit(OrdersLoading());

    final documentId =
        meal['documentId'] ?? meal['title'] ?? UniqueKey().toString();

    final doc = await firestore.collection('users2').doc(userId).get();
    if (doc.exists && doc.data()?['cartItems'] != null) {
      meals = List<Map<String, dynamic>>.from(doc.data()?['cartItems'] ?? []);
    } else {
      meals = [];
    }

    final existingIndex =
        meals.indexWhere((m) => m['documentId'] == documentId);

    if (existingIndex != -1) {
      meals[existingIndex]['quantity'] =
          (meals[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      meals.add({
        ...meal,
        'documentId': documentId,
        'quantity': 1,
      });
    }

    await _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }
}
