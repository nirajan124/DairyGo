import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_cubit.dart';
import '../../data/cart_model.dart';
import '../../../orders/presentation/orders_cubit.dart';
import '../../../orders/data/order_model.dart';
import '../../../payment/presentation/view/payment_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../location/presentation/view/location_widget.dart';

class CheckoutPage extends StatelessWidget {
  final Cart cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181C2E),
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF181C2E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              color: Color(0xFF2A2F4F),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...cart.items.map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} x${item.quantity}',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ),
                          Text(
                            'Rs. ${item.total.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[600]),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rs. ${cart.total.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Delivery Information with Location Widget
            LocationWidget(
              onAddressSelected: (String address) {
                // Handle address selection
                print('Selected delivery address: $address');
              },
            ),
            SizedBox(height: 24),
            // Payment Information
            Card(
              color: Color(0xFF2A2F4F),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.payment, color: Colors.orange, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Choose payment method',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            // Proceed to Payment Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _proceedToPayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 8,
                  shadowColor: Colors.orange.withOpacity(0.3),
                ),
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Get user information from auth state
    final authState = context.read<AuthBloc>().state;
    String customerName = 'Customer';
    String customerEmail = 'customer@example.com';
    String customerPhone = '';

    if (authState is Authenticated) {
      final user = authState.user;
      customerName = user.fullName;
      customerEmail = user.email;
      customerPhone = user.phone;
    }

    // Navigate to payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          cart: cart,
          customerName: customerName,
          customerEmail: customerEmail,
          customerPhone: customerPhone,
        ),
      ),
    );
  }
} 