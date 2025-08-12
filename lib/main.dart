import 'package:flutter/material.dart';
import 'package:local_db_app/core/theme.dart';
import 'package:provider/provider.dart';

import 'viewmodels/db_viewmodels.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeVM = ThemeViewModel();
  await themeVM.loadThemeFromPrefs(); // Load theme from SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>.value(value: themeVM),
        ChangeNotifierProvider<TaskViewModel>(
          create: (_) => TaskViewModel()..fetchTasks(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
