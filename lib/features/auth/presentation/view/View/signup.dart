
import 'package:flutter/material.dart';
import '../../../../../core/network/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; });
    try {
      await ApiService().safeApiCall(() => ApiService().register(
        fname: fnameController.text.trim(),
        lname: lnameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ));
      if (mounted) {
        _showSnackBar('Registration Successful!');
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        fnameController.clear();
        lnameController.clear();
        phoneController.clear();
        // TODO: Navigate to login or home screen
        Navigator.pop(context); // Go back to login
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
    if (mounted) {
      setState(() { isLoading = false; });
    }
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
                image: AssetImage('assets/images/signup.png'),
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                TextFormField(
                  controller: fnameController,
                  decoration: InputDecoration(
                    hintText: 'Enter First Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter first name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Last Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter last name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter phone' : null,
                ),
                    const SizedBox(height: 20),
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
                        onPressed: _register,
                        child: Text('Sign Up'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}