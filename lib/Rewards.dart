// done to change  all Score to point globelScore
import 'package:flutter/material.dart';
import 'main.dart';
import 'globals.dart';

void main() {
  runApp(MaterialApp(
    home: Rewards(), // Wrap MapScreen with MaterialApp
  ));
}

class Rewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // score = 20; // Example: Player points
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xFFF4DDB8) //0xFFF4DDB8,
              ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/RewardsBackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 610,
                left: 0,
                right: 290,
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
                      // Add your onPressed logic here
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
                // reward 1
                top: 0,
                bottom: 350,
                left: 0,
                right: 0,
                child: Center(
                  child: RewardsLevel(
                    reward: reward1,
                    level: 2,
                    pointsRequired: 20,
                    playerPoints: point,
                    unlockedImageAsset: 'assets/images/candy.png',
                    lockedImageAsset: 'assets/images/candyB.png',
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
              Positioned(
                // reward 2
                top: 0,
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: RewardsLevel(
                    reward: reward2,
                    level: 2,
                    pointsRequired: 50,
                    playerPoints: point,
                    unlockedImageAsset: 'assets/images/bakhor.png',
                    lockedImageAsset: 'assets/images/bakhorB.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              Positioned(
                // reward 3
                top: 260,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: RewardsLevel(
                    reward: reward3,
                    level: 2,
                    pointsRequired: 80,
                    playerPoints: point,
                    unlockedImageAsset: 'assets/images/oud.png',
                    lockedImageAsset: 'assets/images/oudB.png',
                    height: 180,
                    width: 180,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}


class RewardsLevel extends StatelessWidget {
  final int level;
  final int pointsRequired;
  final int playerPoints;
  final String unlockedImageAsset;
  final String lockedImageAsset;
  final double width;
  final double height;
  final bool reward;

  const RewardsLevel({
    Key? key,
    required this.level,
    required this.pointsRequired,
    required this.playerPoints,
    required this.unlockedImageAsset,
    required this.lockedImageAsset,
    required this.width,
    required this.height,
    required this.reward,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canUnlock = playerPoints >= pointsRequired && reward1;
    return GestureDetector(
      onTap: canUnlock
          ? () {
        // Update global points only if reward condition is met
        if (reward1) {
          point += tempPoint;
          tempPoint = 0; // Reset temporary points
        }
      }
          : () {
        // Discard temporary points if reward condition is not met
        tempPoint = 0;
      },
      child: Image.asset(
        canUnlock ? unlockedImageAsset : lockedImageAsset,
        width: width,
        height: height,
      ),
    );
  }

  bool someReward1SpecificCondition() {
    // Implement any specific condition for reward1 if needed
    // For now, it returns true to allow unlocking
    return true;
  }
}
