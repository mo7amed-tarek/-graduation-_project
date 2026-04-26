import 'package:codecrefactos/apiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
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
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final _api = ApiService();

  bool _isLoading = false;
  String _fullName = 'Admin User';
  String _initials = 'AU';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);

    try {
      final response = await _api.get('User/profile');
      final data = response.data;

      final name = data['fullName'] ?? data['userName'] ?? 'Admin User';

      final parts = name.trim().split(' ');
      String initials;
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      } else {
        initials = 'AU';
      }

      setState(() {
        _fullName = name;
        _initials = initials;
      });
    } on DioException catch (e) {
      final errors = _api.handleError(e);
      debugPrint('Profile error: ${errors['general']}');
    } catch (e) {
      debugPrint('Profile error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _initials,
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
                        _isLoading ? 'Loading...' : _fullName,
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
                  if (widget.showAddButton)
                    ElevatedButton.icon(
                      onPressed: widget.onAdd,
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
                        widget.bottonTitle,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  if (widget.showAddButton) Gap(5.h),
                  if (widget.showLogoutButton)
                    TextButton.icon(
                      onPressed: widget.onLogout,
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
