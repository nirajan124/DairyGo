import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/cart_model.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem item;

  AddToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  RemoveFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  UpdateQuantity(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

class ClearCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void addToCart(CartItem item) {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.addItem(item);
      emit(CartLoaded(updatedCart));
    } else {
      emit(CartLoaded(Cart().addItem(item)));
    }
  }

  void removeFromCart(String itemId) {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.removeItem(itemId);
      emit(CartLoaded(updatedCart));
    }
  }

  void updateQuantity(String itemId, int quantity) {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.updateQuantity(itemId, quantity);
      emit(CartLoaded(updatedCart));
    }
  }

  void clearCart() {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.clear();
      emit(CartLoaded(updatedCart));
    }
  }
} 