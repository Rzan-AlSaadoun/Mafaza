// done to change  all Score to point globelScore
import 'package:flutter/material.dart';
import 'globals.dart';
import 'level1_complete.dart';
import 'level2_complete.dart';
import 'level3_complete.dart';
import 'main.dart';
import 'globals.dart'; // Import the global variables file

void main() {
  runApp(MaterialApp(
    home: MapScreen(), // Wrap MapScreen with MaterialApp
  ));
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4DDB8),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mapBackgroundwo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 620,
            left: 0,
            right: 300,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: Image.asset(
                  'assets/images/returnbackWithBackground.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          Positioned(
            // Level one
            top: 0,
            bottom: 345,
            left: 0,
            right: 130,
            child: Center(
              child: MapLevelButton(
                open: true,
                level: 1,
                pointsRequired: 0,
                score: point, // Use the global score variable
                unlockedImageAsset: 'assets/images/najdButton.png',
                lockedImageAsset:
                'assets/images/najdButton.png', // Same image for locked state
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => level1()),
                  );
                },
              ),
            ),
          ),
          Positioned(
            // Level three
            top: 350,
            bottom: 0,
            left: 0,
            right: 50,
            child: Center(
              child: MapLevelButton(
                open: lvl3,
                level: 3,
                pointsRequired: 50,
                score: point, // Use the global score variable
                unlockedImageAsset: 'assets/images/southButton.png',
                lockedImageAsset: 'assets/images/southBW.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => level3()),
                  );
                },
              ),
            ),
          ),
          Positioned(
            // Level two
            top: 0,
            bottom: 0,
            left: 80,
            right: 0,
            child: Center(
              child: MapLevelButton(
                open: lvl2,
                level: 2,
                pointsRequired: 20,
                score: point, // Use the global score variable
                unlockedImageAsset: 'assets/images/eastButton.png',
                lockedImageAsset: 'assets/images/eastBW.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => level2()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapLevelButton extends StatelessWidget {
  final int level;
  final int pointsRequired;
  final int score;
  final bool open;
  final String unlockedImageAsset;
  final String lockedImageAsset;
  final VoidCallback? onPressed;

  const MapLevelButton({
    Key? key,
    required this.level,
    required this.pointsRequired,
    required this.score,
    required this.unlockedImageAsset,
    required this.lockedImageAsset,
    this.open = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canUnlock = score >= pointsRequired && open;
    return TextButton(
      onPressed: canUnlock ? onPressed : null,
      child: Image.asset(
        canUnlock ? unlockedImageAsset : lockedImageAsset,
        width: 250,
        height: 250,
      ),
    );
  }
}
