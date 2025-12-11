import 'package:codecrefactos/viewmodels/employee_viewmodel.dart';
import 'package:codecrefactos/viewmodels/forgot_password_viewmodel.dart';
import 'package:codecrefactos/viewmodels/login_viewmodel.dart';
import 'package:codecrefactos/viewmodels/register_viewmodel.dart';
import 'package:codecrefactos/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => EmployeesViewModel()),
        ChangeNotifierProvider(create: (_) => EmployeesViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: Size(390, 844),
        builder: (_, __) =>
            MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()),
      ),
    );
  }
}
