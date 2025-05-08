// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:wave/database/daily_focus.dart';
import 'package:wave/main.dart';
import 'package:wave/screens/home_screen.dart'; // Adjust the import if necessary

class FocusDataScreen extends StatefulWidget {
  const FocusDataScreen({super.key});

  @override
  _FocusDataScreenState createState() => _FocusDataScreenState();
}

class _FocusDataScreenState extends State<FocusDataScreen> {
  String focusMinutes = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchFocusData();
  }

  Future<void> fetchFocusData() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final dailyFocus = await isar.dailyFocuses
        .filter()
        .dateEqualTo(todayDate)
        .findFirst();

    if (dailyFocus != null) {
      setState(() {
        focusMinutes = '${dailyFocus.minutes} minutes';
      });
    } else {
      setState(() {
        focusMinutes = 'No focus data for today.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Data'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            focusMinutes,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
