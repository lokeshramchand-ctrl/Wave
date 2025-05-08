// ignore_for_file: deprecated_member_use, unused_element, unused_local_variable

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:wave/database/daily_focus.dart';
import 'package:wave/logic/timer_controller.dart';
import 'package:wave/screens/focus.dart';
import 'package:wave/screens/pip.dart';
import 'package:wave/theme/theme_notifier.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final _timerController = TimerController();

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  bool isRunning = false;
  bool showControls = true;
  Size? currentSize;
  Offset? currentPosition;

  String get formattedTime {
    final minutes = (_timerController.totalSeconds ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_timerController.totalSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    return '$minutes:$seconds';
  }

  void toggleTimer() {
    if (_timerController.isRunning) {
      _timerController.pauseTimer();
    } else {
      _timerController.startTimer(
        onTick: () => setState(() {}),
        onComplete: () => setState(() {}),
      );
    }
    setState(() {
      isRunning = _timerController.isRunning;
    });
  }

  void resetTimer() {
    _timerController.resetTimer(() {
      setState(() {});
    });
  }

  Future<void> _enterPipMode() async {
    currentSize = await windowManager.getSize();
    currentPosition = await windowManager.getPosition();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Pip(
                originalWindowSize: currentSize!,
                originalWindowPosition: currentPosition!,
              ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initWindow();
  }

  Future<void> _initWindow() async {
    await windowManager.ensureInitialized();
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setSkipTaskbar(false);
    await windowManager.setResizable(true);

    // Set default window size if not already set
    const defaultSize = Size(700, 600);
    await windowManager.setMinimumSize(const Size(0, 0));
    final current = await windowManager.getSize();
    if (current.width < 400 || current.height < 500) {
      await windowManager.setSize(defaultSize);
      await windowManager.center();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize =
        screenWidth < 250
            ? 30
            : screenWidth < 400
            ? 60
            : 100;
    double iconSize =
        screenWidth < 250
            ? 20
            : screenWidth < 400
            ? 32
            : 64;
    double spacing = screenWidth < 250 ? 10 : 20;

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              onPanUpdate: (_) => windowManager.startDragging(),
              child: Container(color: Colors.transparent),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    final themeNotifier = Provider.of<ThemeNotifier>(
                      context,
                      listen: false,
                    );
                    themeNotifier.setTheme(
                      themeNotifier.themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    );
                  },
                  child: Icon(
                    theme.brightness == Brightness.dark
                        ? CupertinoIcons.sun_max_fill
                        : CupertinoIcons.moon_fill,
                    color: textColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: spacing * 2),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/wave.svg',
                          width: iconSize * 2,
                          height: iconSize * 2,
                        ),
                        onPressed: _enterPipMode,
                      ),
                      SizedBox(height: spacing),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FocusDataScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Wave',
                          style: TextStyle(
                            fontFamily:
                                'SF Pro Display', // Using your custom font
                            fontSize: fontSize - 50 ,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension GetDailyFocusCollection on Isar {
  IsarCollection<DailyFocus> get dailyFocuses => this.collection();
}
