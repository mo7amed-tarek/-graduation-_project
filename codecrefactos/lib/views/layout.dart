import 'package:codecrefactos/views/home.dart';
import 'package:codecrefactos/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;

  final List<Widget> pages = [
   Home(),
    Profile(),
    Home(),
    Profile(),
    Home(),
    Profile(),
  ];

  List<String> icons = [
    "assets/bottomNavigationBar/home1.png",
    "assets/bottomNavigationBar/person1.png",
    "assets/bottomNavigationBar/bick1.png",
    "assets/bottomNavigationBar/Icon1.png",
    "assets/bottomNavigationBar/Group.png",
    "assets/bottomNavigationBar/setting1.png"
  ];

  List<String> selectedIcons = [
    "assets/bottomNavigationBar/Untitled.png",
    "assets/bottomNavigationBar/Untitled2.png",
    "assets/bottomNavigationBar/bick1.png",
    "assets/bottomNavigationBar/Icon1.png",
    "assets/bottomNavigationBar/Group.png",
    "assets/bottomNavigationBar/setting1.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(


        onTap: (index){
            setState(() {
              selectedIndex = index;
            });


        },
        currentIndex: selectedIndex,

          items: [

        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[0], fit: BoxFit.contain,
            height: 25.h,),
          icon: Image.asset(
            icons[0],
            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[1], fit: BoxFit.contain,
            height:25.h,),

          icon: Image.asset(
            icons[1],

            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[2], fit: BoxFit.contain,
            height: 25.h,),

          icon: Image.asset(
            icons[2],
            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[3], fit: BoxFit.contain,
            height: 25.h,),

          icon: Image.asset(
            icons[3],
            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[4], fit: BoxFit.contain,
            height: 25.h,),

          icon: Image.asset(
            icons[4],
            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(selectedIcons[5], fit: BoxFit.contain,
            height: 25.h,),

          icon: Image.asset(
            icons[5],
            fit: BoxFit.contain,
            height: 20.h,
          ),
          label: '',
        ),
      ]),

    );
  }

}
