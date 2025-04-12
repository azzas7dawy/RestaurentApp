part of 'orders_cubit.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Map<String, dynamic>> meals;

  OrdersLoaded({required this.meals});
}

class OrdersLoading extends OrdersState {}

class OrdersSubmissionSuccess extends OrdersState {}

class OrdersSubmissionError extends OrdersState {
  final String errorMessage;

  OrdersSubmissionError({required this.errorMessage});
}

class OrdersError extends OrdersState {
  final String errorMessage;

  OrdersError({required this.errorMessage});
}
