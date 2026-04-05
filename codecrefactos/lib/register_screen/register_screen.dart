import 'package:codecrefactos/forgot_password/screens/forgot_password_screen.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:codecrefactos/register_screen/register_viewmodel.dart';
import 'package:codecrefactos/resources/color_manager.dart';
import 'package:codecrefactos/resources/text_manager.dart';
import 'package:codecrefactos/widgets/custom_text_field.dart';
import 'package:codecrefactos/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RegisterViewModel>(
        builder: (context, vm, child) {
          return Padding(
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
                    "Sign Up",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hint: TextManager.email,
                          controller: vm.emailCtrl,
                          icon: Icons.email_outlined,
                          validator: vm.validateEmail,
                          errorText: vm.emailError,
                        ),
                        const SizedBox(height: 15),

                        CustomTextField(
                          hint: "Full Name",
                          controller: vm.fullNameCtrl,
                          icon: Icons.person_outline,
                          validator: vm.validateFullName,
                          errorText: vm.nameError,
                        ),
                        const SizedBox(height: 15),

                        CustomTextField(
                          hint: TextManager.password,
                          controller: vm.passCtrl,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: vm.validatePassword,
                          errorText: vm.passwordError,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (vm.generalError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            vm.generalError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            vm.clearErrors();

                            if (_formKey.currentState!.validate()) {
                              await vm.register();

                              if (vm.isRegistered) {
                                AppDialogs.showSuccess(
                                  context,
                                  "Registered successfully!",
                                );

                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(),
                                    ),
                                  );
                                });
                              } else {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  _formKey.currentState!.validate();
                                });
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: vm.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
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
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(),
                        ),
                      ),
                      child: Text(
                        TextManager.forgotPassword,
                        style: TextStyle(color: ColorManager.primary),
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
          );
        },
      ),
    );
  }
}
