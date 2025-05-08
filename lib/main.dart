import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wave/database/daily_focus.dart';
import 'package:wave/screens/home_screen.dart';
import 'package:wave/theme/theme_notifier.dart';
import 'package:wave/theme/theme.dart';
import 'package:window_manager/window_manager.dart';

late final Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Isar Database - related
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([DailyFocusSchema], directory: dir.path);

  //Window Manager - Related
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 400),
    minimumSize: Size(200, 200),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  //WM - End

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(), // Theme - Related
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          themeMode: themeNotifier.themeMode,
          theme: AppTheme.lightTheme, // Use your custom light theme
          darkTheme: AppTheme.darkTheme, // Use your custom dark theme
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
