import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:codecrefactos/forgot_password/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/confirm.png', width: 120.w, height: 120.h),
              SizedBox(height: 24.h),
              Text(
                'Congratulations',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              const Text(
                'Your order has been confirmed.\nTrack your order',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Back to Home',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
