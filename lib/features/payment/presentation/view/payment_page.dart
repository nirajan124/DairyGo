import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../payment_cubit.dart';
import '../../data/payment_model.dart';
import '../../../cart/data/cart_model.dart';
import '../../../cart/presentation/cart_cubit.dart';
import '../../../orders/presentation/orders_cubit.dart';
import '../../../orders/data/order_model.dart';

class PaymentPage extends StatelessWidget {
  final Cart cart;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  const PaymentPage({
    super.key,
    required this.cart,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181C2E),
      appBar: AppBar(
        title: Text('Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF181C2E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            _handlePaymentSuccess(context, state.response);
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: ${state.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                // Payment Methods
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
                        _buildPaymentMethod(
                          context,
                          'Credit/Debit Card',
                          'Pay with your card',
                          Icons.credit_card,
                          Colors.blue,
                          () {
                            print('Credit/Debit Card payment method selected');
                            _showCardPaymentDialog(context);
                          },
                        ),
                        SizedBox(height: 12),
                        _buildPaymentMethod(
                          context,
                          'Cash on Delivery',
                          'Pay when you receive',
                          Icons.money,
                          Colors.orange,
                          () => _processCashOnDelivery(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Customer Information
                Card(
                  color: Color(0xFF2A2F4F),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInfoRow('Name', customerName),
                        _buildInfoRow('Email', customerEmail),
                        _buildInfoRow('Phone', customerPhone),
                      ],
                    ),
                  ),
                ),
                if (state is PaymentLoading) ...[
                  SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Processing payment...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        print('Payment method tapped: $title');
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showCardPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CardPaymentDialog(
          amount: cart.total.toStringAsFixed(2),
          onPaymentSuccess: () {
            Navigator.of(context).pop();
            _createOrder(context, 'Credit/Debit Card');
          },
          onPaymentCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _processCashOnDelivery(BuildContext context) {
    _createOrder(context, 'Cash on Delivery');
  }

  void _createOrder(BuildContext context, String paymentMethod) {
    try {
      // Create order items from cart items
      final orderItems = cart.items.map((cartItem) => OrderItem(
        id: cartItem.id,
        name: cartItem.name,
        image: cartItem.image,
        price: cartItem.price,
        quantity: cartItem.quantity,
      )).toList();

      // Create the order
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: orderItems,
        total: cart.total,
        status: 'pending',
        orderDate: DateTime.now(),
        deliveryAddress: 'Your registered address',
        paymentMethod: paymentMethod,
      );

      // Add order to orders cubit
      context.read<OrdersCubit>().addOrder(order);
      
      // Clear the cart
      context.read<CartCubit>().clearCart();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully! Thank you for your purchase.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      // Navigate back to home
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print('Error creating order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _handlePaymentSuccess(BuildContext context, PaymentResponse response) {
    print('Payment response: ${response.redirectUrl}');
    
    if (response.redirectUrl != null) {
      // Launch eSewa payment URL
      _launchUrl(context, response.redirectUrl!);
      
      // Show simple confirmation dialog
      _showSimplePaymentDialog(context);
    } else {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment initiated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      // Create order
      _createOrder(context, 'eSewa');
    }
  }

  void _showSimplePaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2F4F),
          title: Text(
            'eSewa Payment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have been redirected to eSewa payment page.',
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 12),
              Text(
                'After completing payment on the web page:',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Complete the payment on the web page\n2. Close the web page\n3. Click "Confirm Order" below',
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Create order with eSewa payment method
                _createOrder(context, 'eSewa');
              },
              child: Text(
                'Confirm Order',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      print('Launching eSewa URL: $url');
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error launching URL: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open eSewa. Please try again.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

class CardPaymentDialog extends StatefulWidget {
  final String amount;
  final VoidCallback onPaymentSuccess;
  final VoidCallback onPaymentCancel;

  const CardPaymentDialog({
    Key? key,
    required this.amount,
    required this.onPaymentSuccess,
    required this.onPaymentCancel,
  }) : super(key: key);

  @override
  State<CardPaymentDialog> createState() => _CardPaymentDialogState();
}

class _CardPaymentDialogState extends State<CardPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF2A2F4F),
      title: Text(
        'Credit/Debit Card Payment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: Rs. ${widget.amount}',
                style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: TextStyle(color: Colors.grey[300]),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length < 16) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                ],
                onChanged: (value) {
                  // Format card number with spaces
                  final digits = value.replaceAll(' ', '');
                  final formatted = digits.replaceAllMapped(
                    RegExp(r'.{4}'),
                    (match) => '${match.group(0)} ',
                  ).trim();
                  if (formatted != value) {
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cardNameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  labelStyle: TextStyle(color: Colors.grey[300]),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        labelStyle: TextStyle(color: Colors.grey[300]),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        // Allow both MM/YY and MMYY formats
                        final cleanValue = value.replaceAll('/', '');
                        if (cleanValue.length != 4) {
                          return 'Please enter 4 digits (MM/YY)';
                        }
                        final month = int.tryParse(cleanValue.substring(0, 2));
                        final year = int.tryParse(cleanValue.substring(2, 4));
                        if (month == null || month < 1 || month > 12) {
                          return 'Please enter valid month (01-12)';
                        }
                        if (year == null || year < 0 || year > 99) {
                          return 'Please enter valid year (YY)';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5), // Allow MM/YY format
                      ],
                      onChanged: (value) {
                        // Auto-format expiry date with slash
                        final digits = value.replaceAll('/', '');
                        if (digits.length <= 2) {
                          // Just digits, no formatting needed
                        } else if (digits.length == 3) {
                          // Add slash after 2 digits
                          final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
                          if (formatted != value) {
                            _expiryDateController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        } else if (digits.length == 4) {
                          // Add slash after 2 digits
                          final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
                          if (formatted != value) {
                            _expiryDateController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: Colors.grey[300]),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        if (value.length < 3) {
                          return 'Please enter valid CVV';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : widget.onPaymentCancel,
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isProcessing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Pay Rs. ${widget.amount}'),
        ),
      ],
    );
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate payment processing
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Call success callback
        widget.onPaymentSuccess();
      });
    }
  }
} 