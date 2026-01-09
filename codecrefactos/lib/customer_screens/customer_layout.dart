import 'package:flutter/material.dart';

class CustomerLayout extends StatelessWidget {
  const CustomerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Customer Home", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
