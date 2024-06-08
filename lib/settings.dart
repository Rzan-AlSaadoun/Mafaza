// settingsScreen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Ensure this is the correct path to your MainScreen file
import 'globals.dart' as globals;
import 'brightnessNotifier.dart';

void main() {
  runApp(MaterialApp(
    home: GameSettingsApp(), // Wrap MapScreen with MaterialApp
  ));
}

class GameSettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen();
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = globals.soundEnabled; // Initial sound state from global variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'اعدادات اللعبة',
        //   style: TextStyle(color: Colors.brown),
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4DDB8),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/settingBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 150, left: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'السطوع',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi), // Rotate 180 degrees
                      child: Consumer<BrightnessNotifier>(
                        builder: (context, brightnessNotifier, child) {
                          return Slider(
                            value: brightnessNotifier.brightnessValue,
                            onChanged: (value) {
                              brightnessNotifier.setBrightness(value); // Update brightness
                            },
                            min: 0.1, // Minimum brightness
                            max: 1.0, // Maximum brightness
                            activeColor: Colors.brown,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'الصوت',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi), // Rotate 180 degrees horizontally
                          child: Switch(
                            value: soundEnabled,
                            onChanged: (value) {
                              setState(() {
                                soundEnabled = value; // Update local sound state
                                globals.soundEnabled = value; // Update global sound state
                              });
                            },
                            activeTrackColor: Colors.brown,
                            activeColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 620,
            left: 0,
            right: 300,
            child: IconButton(
              icon: Image.asset('assets/images/returnbackWithBackground.png'),
              iconSize: 80,
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
