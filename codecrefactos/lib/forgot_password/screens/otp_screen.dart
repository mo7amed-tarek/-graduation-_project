import 'package:codecrefactos/forgot_password/view_model/forgotpassword_view_model.dart';
import 'package:codecrefactos/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'set_new_password_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String currentOtp = "";

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
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151837),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please enter the 6-digit code sent to\n${vm.savedEmail}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Pin Code Input
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16),
                      activeFillColor: const Color(0xFFFDFDFD),
                      selectedFillColor: const Color(0xFFFDFDFD),
                      inactiveFillColor: const Color(0xFFFDFDFD),
                      fieldHeight: 52,
                      fieldWidth: 46,
                      activeColor: kPrimaryColor,
                      selectedColor: kPrimaryColor,
                      inactiveColor: Colors.grey.shade200,
                      borderWidth: 1.5,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) => setState(() => currentOtp = value),
                    onCompleted: (value) => setState(() => currentOtp = value),
                  ),

                  const SizedBox(height: 30),

                  // Verify Button
                  vm.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(color: kPrimaryColor),
                          ),
                        )
                      : CustomButton(
                          text: "Verify Code",
                          onPressed: () async {
                            if (currentOtp.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter the full 6-digit code"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            bool valid = await vm.verifyOtp(currentOtp);
                            if (context.mounted) {
                              if (valid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SetNewPasswordScreen(),
                                  ),
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

                  const SizedBox(height: 25),

                  // Resend Row
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code?",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await vm.resetPassword(vm.savedEmail);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(vm.message),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Resend OTP",
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
        ],
      ),
    );
  }
}
