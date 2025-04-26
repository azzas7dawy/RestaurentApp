import 'dart:developer';

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
      log('Failed to load customer name: $e');
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
                  'quantity': meal['quantity'] is int
                      ? meal['quantity']
                      : meal['quantity'] != null
                          ? int.parse(meal['quantity'].toString())
                          : 1,
                })
            .toList();
        log('Loaded cart items: $meals');
      } else {
        meals = [];
      }
      emit(OrdersLoaded(meals: List.from(meals)));
    } catch (e) {
      emit(OrdersError(errorMessage: 'Failed to load cart: ${e.toString()}'));
      log('Failed to load cart: $e');
    } finally {
      _isLoadingCart = false;
    }
  }

  void loadMeals(List<Map<String, dynamic>> initialMeals) {
    meals = List.from(initialMeals);
    _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }

  Future<void> updateMealQuantity(int index, int newQuantity) async {
    if (index >= 0 && index < meals.length && newQuantity >= 1) {
      meals[index]['quantity'] = newQuantity;
      log('Updated meal at index $index with quantity: $newQuantity');
      await _updateCartInFirestore();
      emit(OrdersLoaded(meals: List.from(meals)));
    } else {
      log('Invalid index or quantity: index=$index, newQuantity=$newQuantity');
    }
  }

  void removeMeal(int index) async {
    if (index >= 0 && index < meals.length) {
      meals.removeAt(index);
      log('Removed meal at index $index');
      await _updateCartInFirestore();
      emit(OrdersLoaded(meals: List.from(meals)));
    }
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
      final cartItems = meals.map((meal) {
        return {
          'title': meal['title'],
          'title_ar': meal['title_ar'],
          'price': meal['price'],
          'image': meal['image'],
          'documentId': meal['documentId'],
          'quantity': meal['quantity'] is int
              ? meal['quantity']
              : meal['quantity'] != null
                  ? int.parse(meal['quantity'].toString())
                  : 1,
        };
      }).toList();
      log('Saving cart to Firestore: $cartItems');
      await firestore.collection('users2').doc(userId).set({
        'cartItems': cartItems,
      }, SetOptions(merge: true));
    } catch (e) {
      log('Failed to update cart: $e');
      emit(OrdersError(errorMessage: 'Failed to update cart: ${e.toString()}'));
    }
  }

  Future<void> _clearCart() async {
    try {
      await firestore.collection('users2').doc(userId).update({
        'cartItems': [],
      });
      meals.clear();
      log('Cleared cart');
    } catch (e) {
      log('Failed to clear cart: $e');
      emit(OrdersError(errorMessage: 'Failed to clear cart: ${e.toString()}'));
    }
  }

  void setDeliveryInfo({required String phone, required String address}) {
    _phoneNumber = phone;
    _deliveryAddress = address;
    log('Set delivery info: phone=$phone, address=$address');
  }

  Future<void> submitOrder({
    required String paymentMethod,
    required double totalAmount,
    required double discountAmount,
    bool isPaid = false,
  }) async {
    emit(OrdersLoading());
    try {
      await _loadCartFromFirestore();
      log('Meals after reload for order submission: $meals');

      if (_phoneNumber == null || _deliveryAddress == null) {
        throw Exception('Phone number and delivery address are required');
      }
      if (_customerName == null) {
        await _loadCustomerName();
      }

      final List<Map<String, dynamic>> orderItems = meals.map((meal) {
        final quantity = meal['quantity'] ?? 1;
        final price = meal['price'] is num
            ? meal['price'].toDouble()
            : double.parse(meal['price'].toString());
        final item = {
          'title': meal['title']?.toString() ?? 'Unknown Item',
          'title_ar': meal['title_ar']?.toString() ?? 'Unknown Item',
          'quantity': quantity,
          'price': price,
        };
        log('Order item: $item');
        return item;
      }).toList();

      final String status = 'pending';
      final String trackingStatus = 'order_placed';

      log('Submitting order with items: $orderItems');
      await firestore.collection('orders').add({
        'userId': userId,
        'customer': _customerName ?? 'Unknown',
        'items': orderItems,
        'orderItems': orderItems,
        'total': totalAmount,
        'discountApplied': discountAmount,
        'paymentMethod': paymentMethod,
        'phoneNumber': _phoneNumber,
        'deliveryAddress': _deliveryAddress,
        'timestamp': FieldValue.serverTimestamp(),
        'status': status,
        'trackingStatus': trackingStatus,
      });

      await _clearCart();
      emit(OrdersLoaded(meals: List.from(meals)));
      emit(OrdersSubmissionSuccess());
    } catch (e) {
      log('Failed to submit order: $e');
      emit(OrdersSubmissionError(errorMessage: e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).delete();
      log('Deleted order: $orderId');
      emit(OrdersSubmissionSuccess());
    } catch (e) {
      log('Failed to delete order: $e');
      emit(OrdersSubmissionError(
          errorMessage: 'Failed to delete order: ${e.toString()}'));
    }
  }

  Future<void> addMeal(Map<String, dynamic> meal) async {
    while (_isLoadingCart) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

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
      log('Incremented quantity for existing meal: ${meals[existingIndex]}');
    } else {
      final newMeal = {
        'title': meal['title'] ?? 'Unknown',
        'title_ar': meal['title_ar'],
        'price': meal['price'] ?? 0.0,
        'image': meal['image'] ?? '',
        'documentId': documentId,
        'quantity': 1,
      };
      meals.add(newMeal);
      log('Added new meal: $newMeal');
    }

    await _updateCartInFirestore();
    emit(OrdersLoaded(meals: List.from(meals)));
  }
}
