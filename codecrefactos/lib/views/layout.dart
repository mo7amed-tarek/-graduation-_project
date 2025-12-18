import 'package:codecrefactos/Inventory%20Management/screens/inventory_management_screen.dart';
import 'package:codecrefactos/resources/color_manager.dart';
import 'package:codecrefactos/views/employee_screen.dart';
import 'package:codecrefactos/views/home.dart';
import 'package:codecrefactos/views/profile.dart';
import 'package:codecrefactos/views/sales/screens/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Purchase/screens/Purchase_screen.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    Home(),
    EmployeesScreen(),
    SalesScreen(),
<<<<<<< HEAD

    PurchaseScreen(),
=======
    Profile(),
>>>>>>> 32949468a9dedf1a01873acd229e10175aa5bb40
    InventoryManagementScreen(),
    Profile(),
  ];

  List<String> icons = [
    "assets/dashboard.png",
    "assets/employ.png",
    "assets/Icon.png",
    "assets/Icon (1).png",
    "assets/Group 427320746.png",
    "assets/settting.png",
  ];

  List<String> selectedIcons = [
    "assets/dashboard.png",

    "assets/employ.png",
    "assets/Icon.png",
    "assets/Icon (1).png",
    "assets/Group 427320746.png",
    "assets/settting.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,

        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[0],
              fit: BoxFit.contain,
              height: 25.h,
            ),
            icon: Image.asset(icons[0], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[1],
              fit: BoxFit.contain,
              height: 25.h,
            ),

            icon: Image.asset(icons[1], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[2],
              fit: BoxFit.contain,
              height: 25.h,
            ),

            icon: Image.asset(icons[2], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[3],
              fit: BoxFit.contain,
              height: 25.h,
            ),

            icon: Image.asset(icons[3], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[4],
              fit: BoxFit.contain,
              height: 25.h,
            ),

            icon: Image.asset(icons[4], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              selectedIcons[5],
              fit: BoxFit.contain,
              height: 25.h,
            ),

            icon: Image.asset(icons[5], fit: BoxFit.contain, height: 20.h),
            label: '',
          ),
        ],
      ),
    );
  }
}
