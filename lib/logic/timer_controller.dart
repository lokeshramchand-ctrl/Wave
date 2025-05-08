// lib/controllers/timer_controller.dart

// ignore_for_file: avoid_print

import 'dart:async';
import 'package:isar/isar.dart';
import 'package:wave/database/daily_focus.dart';
import 'package:wave/main.dart';
import 'package:wave/screens/pip.dart';

class TimerController {
  int totalSeconds = 1500;
  Timer? _timer;
  bool isRunning = false;

  void startTimer({
    required Function onTick,
    required Function onComplete,
  }) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (totalSeconds == 0) {
        final focusedMinutes = 25;
        await recordFocusSession(focusedMinutes);
        pauseTimer();
        onComplete();
      } else {
        totalSeconds--;
        onTick();
      }
    });
    isRunning = true;
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunning = false;
  }

  Future<void> resetTimer(Function onReset) async {
    final focusedSeconds = 1500 - totalSeconds;
    final focusedMinutes = focusedSeconds ~/ 60;

    if (focusedMinutes > 0) {
      await recordFocusSession(focusedMinutes);
    }

    pauseTimer();
    totalSeconds = 1500;
    onReset();
  }

  Future<void> recordFocusSession(int focusedMinutes) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final existing =
        await isar.dailyFocuses.filter().dateEqualTo(todayDate).findFirst();

    await isar.writeTxn(() async {
      if (existing != null) {
        existing.minutes += focusedMinutes;
        await isar.dailyFocuses.put(existing);
      } else {
        final newEntry = DailyFocus()
          ..date = todayDate
          ..minutes = focusedMinutes;
        await isar.dailyFocuses.put(newEntry);
      }
    });
  }

  Future<void> fetchFocusData() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final dailyFocus =
        await isar.dailyFocuses.filter().dateEqualTo(todayDate).findFirst();

    if (dailyFocus != null) {
      print('Focus Minutes: ${dailyFocus.minutes}');
    } else {
      print('No focus data for today.');
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
