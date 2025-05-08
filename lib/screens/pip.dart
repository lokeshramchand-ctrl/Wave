// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, avoid_print, deprecated_member_use, unused_import

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:wave/database/daily_focus.dart';
import 'package:wave/logic/timer_controller.dart';
import 'package:wave/screens/home_screen.dart';
import 'package:wave/theme/theme_notifier.dart';
import 'package:window_manager/window_manager.dart';

class Pip extends StatefulWidget {
  final Size originalWindowSize;
  final Offset originalWindowPosition;

  const Pip({
    super.key,
    required this.originalWindowSize,
    required this.originalWindowPosition,
  });

  @override
  State<Pip> createState() => _PipState();
}

final _timerController = TimerController();

class _PipState extends State<Pip> with WindowListener {
  bool isRunning = false;
  bool showControls = true;

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
    _initPipWindow();
  }

  Future<void> _initPipWindow() async {
    await windowManager.ensureInitialized();
    const pipSize = Size(275, 200);
    await windowManager.setMinimumSize(const Size(100, 100));
    await windowManager.setSize(pipSize);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setSkipTaskbar(false);
    await windowManager.setResizable(false);
  }

  Future<void> _restoreOriginalWindow() async {
    await windowManager.setSize(widget.originalWindowSize);
    await windowManager.setPosition(widget.originalWindowPosition);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setResizable(false);
  }

  void _navigateToHome() async {
    await _restoreOriginalWindow();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*
                      IconButton(
                        icon: Icon(
                          theme.brightness == Brightness.dark
                              ? CupertinoIcons.sun_max
                              : CupertinoIcons.moon,
                          size: 18,
                        ),
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
                      ),
                      
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.refresh,
                          size: 18,
                          color: textColor,
                        ),
                        onPressed: resetTimer,
                      ),
                      */
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/wave.svg',
                    width: 32,
                    height: 32,
                  ),
                  onPressed: _navigateToHome,
                ),
                */
                TextButton(
                  onPressed: _navigateToHome,

                  child: Text(
                    'Wave',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display', // Using your custom font
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.refresh,
                        size: 18,
                        color: textColor,
                      ),
                      onPressed: resetTimer,
                    ),
                    IconButton(
                      icon: Icon(
                        isRunning
                            ? CupertinoIcons.pause_circle
                            : CupertinoIcons.play_circle,
                        size: 28,
                        color: textColor,
                      ),
                      onPressed: toggleTimer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension GetDailyFocusCollection on Isar {
  IsarCollection<DailyFocus> get dailyFocuses => this.collection();
}
