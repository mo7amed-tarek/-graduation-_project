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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginViewModel>().clearFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background soft decor circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.purpl.withOpacity(0.04),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Beautiful Logo and Brand Header
                    Center(
                      child: Hero(
                        tag: 'logo',
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/logo.png", height: 45),
                              const SizedBox(width: 12),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFF3D00FF), Color(0xFFB306FD)],
                                ).createShader(bounds),
                                child: Text(
                                  "Code",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                              Text(
                                " Crefactos",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  color: ColorManager.purpl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 70),

                    // Greeting header
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF151837),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue with your account",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Inputs Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hint: TextManager.email,
                            controller: vm.emailCtrl,
                            icon: Icons.email_outlined,
                            validator: vm.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            hint: TextManager.password,
                            controller: vm.passwordCtrl,
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: vm.validatePassword,
                          ),
                        ],
                      ),
                    ),

                    // Error Box
                    Consumer<LoginViewModel>(
                      builder: (context, vm, _) {
                        if (!vm.fieldErrors.containsKey("general")) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  vm.fieldErrors["general"]!,
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Premium Gradient Action Button
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3D00FF), Color(0xFFB306FD)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D00FF).withOpacity(0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              vm.clearErrors();

                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );

                                final success = await vm.login();

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                if (!success) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _formKey.currentState!.validate();
                                  });
                                  return;
                                }

                                if (vm.role?.toLowerCase() == "admin") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const Layout()),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeView(),
                                    ),
                                  );
                                }
                              }
                            },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Forgot Password Link
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: ColorManager.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                      ),
                      child: Text(
                        TextManager.forgotPassword,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Signup Row
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          ),
                          child: const Text(
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
        ),
      ],
    ),
  );
}
}
