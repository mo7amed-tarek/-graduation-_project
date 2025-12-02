import 'package:codecrefactos/resources/color_manager.dart';
import 'package:codecrefactos/resources/text_manager.dart';
import 'package:codecrefactos/viewmodels/register_viewmodel.dart';
import 'package:codecrefactos/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'forgot_password_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 55),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png", height: 45),
                  const SizedBox(width: 10),
                  Text(
                    "Code",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primary,
                    ),
                  ),
                  Text(
                    " Crefactos",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.purpl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 110),

              Text(
                "Sign Up",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hint: TextManager.email,
                      controller: vm.emailCtrl,
                      icon: Icons.email_outlined,
                      validator: vm.validateEmail,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      hint: TextManager.password,
                      controller: vm.passCtrl,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: vm.validatePassword,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      hint: TextManager.repeatPassword,
                      controller: vm.repeatPassCtrl,
                      icon: Icons.lock_reset_outlined,
                      isPassword: true,
                      validator: vm.validateRepeat,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // API CALL
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  minimumSize: Size(double.infinity, 45),
                ),
                child: Text(
                  TextManager.signup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                  ),
                  child: Text(
                    TextManager.forgotPassword,
                    style: TextStyle(color: ColorManager.primary),
                  ),
                ),
              ),

              SizedBox(height: 25),

              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/google.png", height: 35),
                  SizedBox(width: 20),
                  Image.asset("assets/facebook.png", height: 35),
                ],
              ),

              SizedBox(height: 25),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  ),
                  child: Text(
                    "Have an account? Sign In",
                    style: TextStyle(color: ColorManager.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
