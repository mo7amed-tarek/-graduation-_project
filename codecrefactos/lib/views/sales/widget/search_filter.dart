import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SearchFilter extends StatelessWidget {
  final bool showDropdown;
  final Function(String)? onChanged; // أضفنا هذا السطر لاستقبال ميثود البحث

  const SearchFilter({super.key, this.showDropdown = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged, // نستخدم الـ parameter هنا
            decoration: InputDecoration(
              hintText: "Search by product name...",
              prefixIcon: const Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        if (showDropdown) ...[
          Gap(10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: DropdownButton<String>(
              value: "All Categories",
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: "All Categories", child: Text("All Categories")),
                DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
                DropdownMenuItem(value: "Office Supplies", child: Text("Office Supplies")),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ],
    );
  }
}