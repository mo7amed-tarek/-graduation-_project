import 'package:codecrefactos/forgot_password/view_model/forgotpassword_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController();

  ForgotPasswordScreen({super.key});

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
              "Forgot password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Please enter your User ID to reset the password"),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter your User ID",
              controller: userIdController,
            ),
            const SizedBox(height: 20),
            vm.isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Reset Password",
                    onPressed: () async {
                      await vm.resetPassword(userIdController.text);

                      if (vm.message.contains('OTP sent')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OtpScreen()),
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
