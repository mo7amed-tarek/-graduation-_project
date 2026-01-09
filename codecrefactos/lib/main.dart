import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';
import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:codecrefactos/forgot_password/view_model/forgotpassword_view_model.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:codecrefactos/login_screen/login_viewmodel.dart';
import 'package:codecrefactos/register_screen/register_viewmodel.dart';
import 'package:codecrefactos/views/Purchase/viewmodels/Purchase_Provider.dart';
import 'package:codecrefactos/views/sales/viewmodels/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => EmployeesViewModel()),
        ChangeNotifierProvider(create: (_) => InventoryViewModel()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => PurchasesProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) =>
            MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()),
      ),
    );
  }
}
