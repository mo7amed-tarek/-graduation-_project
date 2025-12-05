import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(

      actions: [
        TextButton.icon(
          onPressed: () {
            print("Logout Pressed");
          },
          icon: Icon(Icons.logout, color: Color(0xff0A0A0A), size: 18.sp),
          label: Text(
            'Logout',
            style: TextStyle(
              color: Color(0xff0A0A0A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Gap(10),
      ],

      title: Row(

        children: [
          Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset('assets/home/avatar.png'),
          ),
          Gap(10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Admin Panel',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff717182),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}

