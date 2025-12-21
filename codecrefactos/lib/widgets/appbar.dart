import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onLogout;
  final bool showAddButton;
  final bool showLogoutButton;
  final String bottonTitle;

  const Appbar({
    super.key,
    this.onAdd,
    this.onLogout,
    this.showAddButton = true,
    this.showLogoutButton = true,
    required this.bottonTitle,
  });

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      child: Material(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                        "AU",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  Gap(10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Admin User',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  if (showAddButton)
                    ElevatedButton.icon(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      icon: Icon(
                        Icons.person_add,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        bottonTitle,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  if (showAddButton) Gap(5.h),
                  if (showLogoutButton)
                    TextButton.icon(
                      onPressed: onLogout,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 18.sp,
                      ),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
