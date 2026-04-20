import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codecrefactos/views/layout.dart';
import 'package:codecrefactos/customer_screens/views/home_view.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import '../apiService.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Widget? screen;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final role = prefs.getString("role");

    if (token != null && token.isNotEmpty) {
      ApiService.token = token;

      if (role?.toLowerCase() == "admin") {
        screen = const Layout();
      } else {
        screen = const HomeView();
      }
    } else {
      screen = LoginScreen();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (screen == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return screen!;
  }
}
