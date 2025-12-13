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
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 40),
            const Text(
              "Set a new password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create a new password. Ensure it differs from previous ones for security",
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter your new password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hint: "Re-enter password",
              controller: confirmController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            vm.isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Update Password",
                    onPressed: () async {
                      bool success = await vm.updatePassword(
                        passwordController.text,
                        confirmController.text,
                      );

                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SuccessScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(vm.message)));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
