import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

void main() {
  runApp(MaterialApp(
    home: Quiz(),
  ));
}

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/InstructionQuiz.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ColorGamePage()),
                      );
                    },
                    child: Container(
                      width: 140,
                      height: 220,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/Button.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorGamePage extends StatefulWidget {
  @override
  _ColorGamePageState createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
  int _timerSeconds = 10;
  Timer? _timer;
  bool _showImage = false;
  int _questionTimerSeconds = 8; // Adjust this value as needed
  Timer? _questionTimer;
  bool _choicePressed = false; // Track if a choice is pressed
  String _selectedChoice = ''; // Track the selected choice
  bool _firstQuestionTimerEnded = false; // Track if the first question timer has ended

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/puzz.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment(0, -0.7),
              child: Text(
                'الوقت المتبقي: $_timerSeconds ثواني',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            ),
          ),
          if (_showImage)
            _firstQuestionTimerEnded
                ? ImagePage() // Show ImagePage widget after the first question timer ends
                : Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/Question1.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.7),
                    child: Text(
                      'الوقت المتبقي: $_questionTimerSeconds ثواني',
                      style: TextStyle(fontSize: 18, color: Colors.brown),
                    ),
                  ),
                  // Choices
                  Positioned(
                    bottom: MediaQuery.of(context).size.height / 2 - 100, // Center vertically
                    child: Center(
                      // Center the choices horizontally
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildChoice('ثلاثة مباخر'),
                          SizedBox(height: 20),
                          buildChoice('سبعة مباخر'),
                          SizedBox(height: 20), // Add space between the second and third choices
                          buildChoice('خمسة مباخر'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build choice containers
  Widget buildChoice(String text) {
    // Define border width for bold border
    double borderWidth = 1.0;
    // Define border colors for different choices
    Color borderColor = Colors.transparent;

    // Check if a choice is already selected
    bool alreadySelected = _selectedChoice.isNotEmpty;

    // Check if the current choice is selected
    if (_choicePressed && _selectedChoice == text) {
      if (text == 'ثلاثة مباخر') {
        borderColor = Colors.red; // Red border for the first choice
        borderWidth = 4.0; // Make the border bold
      } else if (text == 'سبعة مباخر') {
        borderColor = Colors.red; // Red border for the second choice
        borderWidth = 4.0; // Make the border bold
      } else if (text == 'خمسة مباخر') {
        borderColor = Colors.green; // Green border for the third choice
        borderWidth = 4.0; // Make the border bold
      }
    }

    return GestureDetector(
      onTap: () {
        // Check if no choice has been selected before allowing selection
        if (!alreadySelected) {
          setState(() {
            _choicePressed = true;
            _selectedChoice = text; // Update the selected choice
          });

          // Navigate to ImagePage with delay
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImagePage()),
            );
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
        margin: EdgeInsets.only(bottom: text == 'خمسة مباخر' ? 20 : 10), // Adjusted margin for third choice
        decoration: BoxDecoration(
          color: Color(0xFFD2B48C), // Light brown color
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: borderWidth), // Apply border color and width
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 25, color: Colors.brown),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_timerSeconds == 0) {
          timer.cancel();
          setState(() {
            _showImage = true;
            startSecondTimer(); // Start the second timer
          });
        } else {
          setState(() {
            _timerSeconds--;
          });
        }
      },
    );
  }

  void startSecondTimer() {
    const oneSec = const Duration(seconds: 1); // Change to 1 second
    _questionTimer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_questionTimerSeconds == 0) {
          timer.cancel();
          // Check if the timer ended without selecting a choice
          if (!_choicePressed || _choicePressed) {
            // Navigate to MainScreen after a 1-second delay
            Future.delayed(Duration(seconds: 1), ()
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            });
          }
        } else {
          setState(() {
            _questionTimerSeconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }
}

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Widget for displaying Question2.png
        Image.asset('assets/images/Question2.png'), // Make it appear after the timer of Question1.png ends
        // Widget for displaying AnimTest on top of Question2.png
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AnimTest(),
          ),
        ),
      ],
    );
  }
}

class AnimTest extends StatefulWidget {
  @override
  _AnimTestState createState() => _AnimTestState();
}

class _AnimTestState extends State<AnimTest> {
  int _rightAnswerIndex = 0; // Index of "لولوة"
  int? tappedIndex;
  bool _isOptionSelected = false;
  int _questionTimerSeconds = 8; // Duration of the timer
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_questionTimerSeconds == 0) {
          timer.cancel();
          // You can add code here to handle timer expiration if needed
        } else {
          setState(() {
            _questionTimerSeconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/Question2.png',
            fit: BoxFit.cover,
          ),
          // Column layout for UI elements
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Adjust vertical spacing
                Text(
                  'الوقت المتبقي: $_questionTimerSeconds ثواني',
                  style: TextStyle(fontSize: 18, color: Colors.brown),
                ),
                SizedBox(height: 20),
                // Add some space between the timer and options
                ...List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Added vertical padding
                    child: InkWell(
                      onTap: _isOptionSelected || _questionTimerSeconds == 0 // Check if the timer has ended
                          ? null
                          : () {
                        setState(() {
                          tappedIndex = index;
                          _isOptionSelected = true;
                        });
                      },
                      child: Container(
                        width: double.infinity, // Set width to fill available space
                        height: 60, // Set fixed height for the choice container
                        margin: EdgeInsets.symmetric(horizontal: 20), // Add horizontal margin
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust padding
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B48C), // Light brown color
                          border: Border.all(
                            color: tappedIndex == index
                                ? (_rightAnswerIndex == index ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7)) // Adjust opacity
                                : Colors.transparent,
                            width: 5.0, // Increase border width
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0), // Top left and right corners
                            bottom: Radius.circular(12.0), // Bottom left and right corners
                          ),
                        ),
                        child: Center(
                          // Center the text vertically
                          child: Text(
                            index == 0 ? 'لولوة' : index == 1 ? 'ليلى' : 'لطيفة',
                            style: TextStyle(
                              fontSize: 25, // Decreased font size to 28
                              color: Colors.brown, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
