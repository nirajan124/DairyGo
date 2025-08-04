class PaymentRequest {
  final String amount;
  final String productId;
  final String productName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String successUrl;
  final String failureUrl;

  PaymentRequest({
    required this.amount,
    required this.productId,
    required this.productName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.successUrl,
    required this.failureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'product_id': productId,
      'product_name': productName,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'success_url': successUrl,
      'failure_url': failureUrl,
    };
  }
}

class PaymentResponse {
  final String status;
  final String? transactionId;
  final String? message;
  final String? redirectUrl;

  PaymentResponse({
    required this.status,
    this.transactionId,
    this.message,
    this.redirectUrl,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'] ?? '',
      transactionId: json['transaction_id'],
      message: json['message'],
      redirectUrl: json['redirectUrl'] ?? json['redirect_url'],
    );
  }
}

enum PaymentStatus {
  pending,
  success,
  failed,
  cancelled,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isSuccess => this == PaymentStatus.success;
  bool get isFailed => this == PaymentStatus.failed || this == PaymentStatus.cancelled;
} 