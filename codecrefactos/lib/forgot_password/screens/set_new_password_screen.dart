import 'package:codecrefactos/forgot_password/view_model/forgotpassword_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'success_screen.dart';

class SetNewPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForgotPasswordViewModel>(context);

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
                color: kPrimaryColor.withOpacity(0.05),
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
                color: const Color(0xFFB306FD).withOpacity(0.04),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Greeting header
                  const Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151837),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create a new password. Ensure it differs from previous ones for security.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Inputs Form
                  CustomTextField(
                    hint: "Enter your new password",
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    hint: "Re-enter password",
                    controller: confirmController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 35),

                  // Action Button
                  vm.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(color: kPrimaryColor),
                          ),
                        )
                      : CustomButton(
                          text: "Update Password",
                          onPressed: () async {
                            final pass = passwordController.text.trim();
                            final confirmPass = confirmController.text.trim();

                            if (pass.isEmpty || confirmPass.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all password fields"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            if (pass != confirmPass) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            bool success = await vm.updatePassword(pass, confirmPass);

                            if (context.mounted) {
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SuccessScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(vm.message),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
