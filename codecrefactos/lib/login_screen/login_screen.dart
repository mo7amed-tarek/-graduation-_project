import 'package:codecrefactos/customer_screens/views/home_view.dart';
import 'package:codecrefactos/forgot_password/screens/forgot_password_screen.dart';
import 'package:codecrefactos/login_screen/login_viewmodel.dart';
import 'package:codecrefactos/register_screen/register_screen.dart';
import 'package:codecrefactos/resources/color_manager.dart';
import 'package:codecrefactos/resources/text_manager.dart';
import 'package:codecrefactos/views/layout.dart';
import 'package:codecrefactos/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 55),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Image.asset("assets/logo.png", height: 45),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF3D00FF), Color(0xFFB306FD)],
                    ).createShader(bounds),
                    child: Text(
                      "Code",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
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
              const Text(
                "Log In",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
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
                    const SizedBox(height: 15),
                    CustomTextField(
                      hint: TextManager.password,
                      controller: vm.passwordCtrl,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: vm.validatePassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final role = await vm.login();

                    if (role == UserRole.admin) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Layout()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeView()),
                      );
                    }
                  }
                },
                child: Text(
                  TextManager.login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                  ),
                  child: Text(
                    TextManager.forgotPassword,
                    style: TextStyle(color: ColorManager.primary, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/google.png", height: 35),
                  const SizedBox(width: 20),
                  Image.asset("assets/facebook.png", height: 35),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: ColorManager.dark),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: ColorManager.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
