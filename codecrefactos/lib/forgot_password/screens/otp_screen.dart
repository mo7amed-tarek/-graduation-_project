import 'package:codecrefactos/forgot_password/view_model/forgotpassword_view_model.dart';
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
              "Enter OTP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            const Text(
              "Please enter the OTP sent to your registered phone number: XXXXXXX987",
            ),

            const SizedBox(height: 20),

            PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              textStyle: const TextStyle(fontSize: 20),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(kBorderRadius),
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                fieldHeight: 55,
                fieldWidth: 50,
                activeColor: kPrimaryColor,
                selectedColor: kPrimaryColor,
                inactiveColor: Colors.grey,
              ),
              enableActiveFill: true,
              onChanged: (value) {
                setState(() {
                  currentOtp = value;
                });
              },
              onCompleted: (value) {
                setState(() {
                  currentOtp = value;
                });
              },
            ),

            const SizedBox(height: 20),

            vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Verify Code",
                    onPressed: () async {
                      bool valid = await vm.verifyOtp(currentOtp);

                      if (valid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SetNewPasswordScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(vm.message)));
                      }
                    },
                  ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () async {
                await vm.resetPassword("dummyUser");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(vm.message)));
              },
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
