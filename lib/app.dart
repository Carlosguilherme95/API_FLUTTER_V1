import 'package:flutter/material.dart';

import 'src/history/page/history_page.dart';
import 'src/home/page/home_page.dart';
import 'src/routes/app_routes.dart';
import 'src/shared/colors/app_colors.dart';

class ApiFlutterApp extends StatelessWidget {
  const ApiFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Flutter v1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.history: (_) => const HistoryPage(),
      },
    );
  }
}
