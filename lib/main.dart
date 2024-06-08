// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Rewards.dart';
import 'mapScreen.dart';
import 'settings.dart';
import 'level1_complete.dart';
import 'level2_complete.dart';
import 'level3_complete.dart';
import 'globals.dart';
import 'brightnessNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BrightnessNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BrightnessNotifier>(
      builder: (context, brightnessNotifier, child) {
        return MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          home: MainScreen(),
          builder: (context, child) {
            return Opacity(
              opacity: brightnessNotifier.brightnessValue,
              child: child,
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9E5C5),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 100,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  if (point >= 0 && point < 20) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => level1()),
                    );
                  } else if (point >= 20 && point < 80) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => level2()),
                    );
                  } else if (point >= 80) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => level3()),
                    );
                  }
                },
                child: Image.asset(
                  'assets/images/StartButton.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 600,
            left: 0,
            right: 300,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSettingsApp()),
                  );
                },
                child: Image.asset(
                  'assets/images/settingButton.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 600,
            left: 300,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Rewards()),
                  );
                },
                child: Image.asset(
                  'assets/images/rewardsButton.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 430,
            left: 300,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Image.asset(
                  'assets/images/mapButton.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
