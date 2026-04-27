import 'package:codecrefactos/customer_screens/widgets/CustomButton.dart'
    show CustomButton;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback add;
  final VoidCallback buy;

  const ActionButtons({super.key, required this.add, required this.buy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Add to Cart',
            onPressed: add,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            height: 48.h,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomButton(
            text: 'Buy Now',
            onPressed: buy,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            height: 48.h,
          ),
        ),
      ],
    );
  }
}
