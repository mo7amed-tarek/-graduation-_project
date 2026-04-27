import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (i) {
            if (i < rating.floor()) {
              return const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB800),
                size: 16,
              );
            } else if (i < rating && rating - i >= 0.5) {
              return const Icon(
                Icons.star_half_rounded,
                color: Color(0xFFFFB800),
                size: 16,
              );
            } else {
              return Icon(
                Icons.star_outline_rounded,
                color: Color(0xFFD1D5DB),
                size: 16.sp,
              );
            }
          }),
        ),
        SizedBox(width: 4.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
