import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/order_model.dart';

// Events
abstract class OrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddOrder extends OrdersEvent {
  final Order order;

  AddOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class LoadOrders extends OrdersEvent {}

class ClearOrders extends OrdersEvent {}

// States
abstract class OrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;

  OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  void addOrder(Order order) {
    if (state is OrdersLoaded) {
      final currentOrders = (state as OrdersLoaded).orders;
      final updatedOrders = [order, ...currentOrders]; // Add new order at the top
      emit(OrdersLoaded(updatedOrders));
    } else {
      emit(OrdersLoaded([order]));
    }
  }

  void loadOrders() {
    emit(OrdersLoading());
    // For now, we'll just emit the current state
    // In a real app, you'd load from local storage or API
    if (state is OrdersLoaded) {
      emit(state);
    } else {
      emit(OrdersLoaded([]));
    }
  }

  void clearOrders() {
    emit(OrdersLoaded([]));
  }
} 