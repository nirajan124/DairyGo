
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/signup_viewmodel/signup_event.dart';
import '../../view_model/signup_viewmodel/signup_state.dart';
import '../../view_model/signup_viewmodel/signup_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<SignupViewModel, SignupState>(
        builder: (context, state) {
          return Container(
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

                    /// Full Name
                    _buildStyledTextField(
                      controller: usernameController,
                      hintText: "Enter Username",
                      icon: Icons.person,
                      validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                    ),

                    const SizedBox(height: 20),

                    /// Email
                    _buildStyledTextField(
                      controller: emailController,
                      hintText: "Enter Email",
                      icon: Icons.email,
                      validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
                    ),

                    const SizedBox(height: 20),

                    /// Password
                    _buildStyledTextField(
                      controller: passwordController,
                      hintText: "Enter Password",
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (val) => val == null || val.length < 6 ? 'Password require 6 character' : null,
                    ),

                    const SizedBox(height: 30),

                    /// Signup Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignupViewModel>().add(
                              SignupButtonPressed(
                                email: emailController.text.trim(),
                                username: usernameController.text.trim(),
                                password: passwordController.text,
                                // role: "user", // default role
                                // studentId: 0, // dummy value
                                context: context,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xFFFFAB40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Sign Up", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Login Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(color: Colors.black)),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.7),
                            foregroundColor: Colors.black,
                          ),
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Styled Input Field
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white54),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
        validator: validator,
      ),
    );
  }
}