
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/network/api_service.dart';
// TODO: import '../../../home/presentation/view/HomePage.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; });
    try {
      final response = await ApiService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      final token = response['token'];
      final userId = response['userId'];
      if (token != null && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_id', userId);
        _showSnackBar('Login Successful');
        // TODO: Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackBar('Invalid response from server', isError: true);
      }
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}