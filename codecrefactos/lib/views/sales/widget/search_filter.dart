import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search sales...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Gap(10.w),
        Container(
          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton(
            value: "All Categories",
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                  value: "All Categories",
                  child: Text("All Categories")),
              DropdownMenuItem(
                  value: "Electronics",
                  child: Text("Electronics")),
              DropdownMenuItem(
                  value: "Office Supplies",
                  child: Text("Office Supplies")),
            ],
            onChanged: (value) {},
          ),
        )
      ],
    );
  }
}
