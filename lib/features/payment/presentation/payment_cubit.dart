import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/payment_model.dart';
import '../data/payment_remote_data_source.dart';

// Events
abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final PaymentRequest request;

  InitiatePayment(this.request);

  @override
  List<Object?> get props => [request];
}

class VerifyPayment extends PaymentEvent {
  final String transactionId;

  VerifyPayment(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class ResetPayment extends PaymentEvent {}

// States
abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResponse response;

  PaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRemoteDataSource _paymentDataSource;

  PaymentCubit({PaymentRemoteDataSource? paymentDataSource})
      : _paymentDataSource = paymentDataSource ?? PaymentRemoteDataSource(),
        super(PaymentInitial());

  Future<void> initiatePayment(PaymentRequest request) async {
    print('PaymentCubit.initiatePayment called with request: ${request.toJson()}');
    emit(PaymentLoading());
    
    try {
      print('PaymentCubit: About to call _paymentDataSource.initiateSimplePayment');
      final response = await _paymentDataSource.initiateSimplePayment(request);
      print('PaymentCubit: Received response: ${response.redirectUrl}');
      emit(PaymentSuccess(response));
    } catch (e) {
      print('PaymentCubit: Error occurred: $e');
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> verifyPayment(String transactionId) async {
    emit(PaymentLoading());
    
    try {
      final response = await _paymentDataSource.verifyPayment(transactionId);
      emit(PaymentSuccess(response));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  void resetPayment() {
    emit(PaymentInitial());
  }
} 