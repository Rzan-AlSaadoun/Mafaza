import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'mapScreen.dart';
import 'globals.dart';
import 'Rewards.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(), // Wrap MapScreen with MaterialApp
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const level1(),
    );
  }
}

class level1 extends StatefulWidget {
  const level1({Key? key}) : super(key: key);

  @override
  _level1State createState() => _level1State();
}

class _level1State extends State<level1> {
  bool _isFirstCodeVisible = true;
  bool _isSecondCodeVisible = false;

  void _startSecondCode() {
    setState(() {
      _isFirstCodeVisible = false;
      _isSecondCodeVisible = true;
    });
  }

  void _startFirstCode() {
    setState(() {
      _isFirstCodeVisible = true;
      _isSecondCodeVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFirstCodeVisible || _isSecondCodeVisible
          ? AppBar(
              backgroundColor: _isFirstCodeVisible
                  ? const Color(0xFFA17135)
                  : const Color(0xFFA17135),
              title: _isFirstCodeVisible
                  ? const Text(
                      'لعبة تأثير ستروب',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : const Text('لعبة تأثير ستروب'),
              centerTitle: true,
            )
          : null,
      body: _isFirstCodeVisible
          ? FirstCode(
              onButtonPressed: _startSecondCode,
            )
          : _isSecondCodeVisible
              ? ColorGameScreen(
                  onTimeEnded: _startFirstCode,
                )
              : const SizedBox(),
    );
  }
}

class FirstCode extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const FirstCode({Key? key, required this.onButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/stroop_instrution(lvl1).png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 279),
            child: Align(
              alignment: Alignment.center,
              /* child: Text(
                'خذ التعليمات قبل ان تنطلق ! \nستظهر لك الأن لعبة تأثير ستروب \nعليك اختيار لون الكلمة الظاهرة امامك وليس المعنى \nلديك اربعة ثواني للإجابة على اكبر عدد من الأسئلة!',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ), */
            ),
          ),
        ),
        Positioned(
          left: (MediaQuery.of(context).size.width - 4 * 38.5826771654) / 2,
          bottom: 240,
          child: TextButton(
            onPressed: onButtonPressed,
            child: Image.asset(
              'assets/images/go_BTN(LVL1).png',
              width: 4 * 38.5826771654,
              height: 3 * 38.5826771654,
            ),
          ),
        ),
      ],
    );
  }
}

class ColorGameScreen extends StatefulWidget {
  final VoidCallback onTimeEnded;

  const ColorGameScreen({Key? key, required this.onTimeEnded})
      : super(key: key);

  @override
  _ColorGameScreenState createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen> {
  int score = 0;
  List<String> words = ['أحمر', 'أزرق', 'أخضر', 'أصفر'];
  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

  Random random = Random();
  String word = '';
  Color textColor = Colors.black;
  late Timer timer;
  int remainingSeconds = 10;
  bool isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    countdown();
    if (soundEnabled) {
      playBKG();
    }
  }

  AudioPlayer player = AudioPlayer();
  void playBKG() {
    player.play(AssetSource('sound/lvl1_sound(campFire).mp3'),
        volume: soundEnabled ? 1.0 : 0.0);
  }

  void stopBKG() {
    player.stop();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void countdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0 && isTimerRunning) {
        setState(() {
          remainingSeconds--;
        });
      } else if (isTimerRunning) {
        setState(() {
          isTimerRunning = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdScreenOne()),
          );
        });
      }
    });
    generateQuestion(); // استدعاء الدالة هنا لإظهار الكلمة عند بدء الشاشة
  }

  void generateQuestion() {
    int index = random.nextInt(words.length);
    int colorIndex = random.nextInt(colors.length);
    word = words[index];
    textColor = colors[colorIndex];
  }

  void checkAnswer(isCorrect) {
    if (isCorrect) {
      setState(() {
        //score++;i change to point globel
        tempPoint++;
      });
      generateQuestion();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("               !!خطأ"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  generateQuestion();
                },
                child: Text('حاول مجددًا'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/First_Level_BKG.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50.0,
            left: 185.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((point+tempPoint).toString(), //i change to point
                    style: const TextStyle(fontSize: 22, color: Colors.black)),
                const Text(' عودة ',
                    style: TextStyle(fontSize: 22, color: Colors.black)),
              ],
            ),
          ),
          Positioned(
            top: 270.0,
            left: 120.0,
            child: Text(
              'الوقت المتبقي: $remainingSeconds ثواني',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                ':اختر لون الكلمة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(height: 1.0),
              Text(
                word,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36.0, color: textColor),
              ),
              SizedBox(height: 90.0),
              Wrap(
                alignment: WrapAlignment.center,
                children: List<Widget>.generate(
                  words.length,
                  (index) => ElevatedButton(
                    onPressed: () => checkAnswer(textColor == colors[index]),
                    child: Text(words[index]),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors[index]),
                  ),
                ),
              ),
              SizedBox(height: 200.0),
            ],
          ),
        ],
      ),
    );
  }
}

class ThirdScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: const Color(0xFFA17135),
            title: const Text(
              'لعبة توصيل النقاط',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dots_instructions(lvl1).png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 279),
                child: Align(
                  alignment: Alignment.center,
                ),
              ),
              Positioned(
                left:
                    (MediaQuery.of(context).size.width - 4 * 38.5826771654) / 2,
                bottom: 240,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FourthScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/go_BTN(LVL1).png',
                    width: 4 * 38.5826771654,
                    height: 3 * 38.5826771654,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FourthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: const Color(0xFFA17135),
            title: const Text(
              'لعبة توصيل النقاط',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dots_BKG(lvl1)1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              GameScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Offset> points = [];
  int rows = 5;
  int columns = 5;
  List<bool> pressedStates = List.generate(25, (index) => false);
  int selectedPoints = 0;
  final int requiredPoints = 3;
  int score = 0; //number of tries
  int rollNumber = 0;
  bool correctPathSelected = false;
  late Timer timer;
  int remainingSeconds = 22;
  int scoreN = 0;
  bool isTimerRunning = true; //players score

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0 && isTimerRunning) {
        setState(() {
          remainingSeconds--;
        });
      } else if (isTimerRunning) {
        setState(() {
          isTimerRunning = false;
          timerMsg("!انتهى الوقت");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FifthScreen()),
          );
        });
      }
    });
  }

  //correct grid paths
  List<int> correctPathIndices = [
    9,
    4,
    3,
    2,
    7,
    6,
    11,
    10,
    15,
    20,
    21,
    22,
    17,
    16
  ];
  List<List<int>> correctPathsIndicesList = [
    [9, 14, 19, 18, 17, 16], [9, 8, 7, 6, 11, 16], [9, 8, 7, 12, 17, 16],
    [9, 8, 7, 12, 11, 10, 15, 16], //تمر paths
    [1, 6, 11, 12, 13], [1, 2, 7, 12, 13], [1, 2, 3, 8, 13],
    [1, 6, 7, 8, 13], //دله paths
    [5, 10, 15, 20, 21, 22, 23],
    [5, 6, 7, 12, 17, 22, 23],
    [5, 6, 11, 12, 17, 18, 23],
    [5, 6, 7, 12, 17, 18, 23],
    [5, 6, 11, 12, 17, 22, 23],
    [5, 6, 7, 12, 17, 18, 19, 24, 23], //فنجال paths
  ];

  void _resetGame() {
    setState(() {
      points.clear();
      pressedStates = List.generate(25, (index) => false);
      correctPathSelected = false;
      userSelectedPath.clear();
    });
  }

  List<int> userSelectedPath = [];

  @override
  void initState() {
    correctPathSelected = false;
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final ksize = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          points.add(details.globalPosition);
          updateSquareColor(details.globalPosition);
        });
      },
      onTap: () {
        setState(() {
          int selectedSquare = getSelectedSquareIndex();
          if (selectedSquare != -1) {
            userSelectedPath.add(selectedSquare);
          }
        });
      },
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              '        عودة\t${(tempPoint+point).toString()}', // i change to point globel
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              '\n الوقت المتبقي: $remainingSeconds ثواني',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Text(
              'من 3 إحتمالات\t$score',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            rollNumber == 3
                ? const SizedBox(

                    )
                : SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                      children: [
                        buildGrid(),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: rows,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: rows * columns,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  points.add(Offset(
                                    (index % columns) * (300 / columns),
                                    (index ~/ columns) * (300 / rows),
                                  ));
                                  pressedStates[index] = true;
                                  selectedPoints++;
                                  checkPoints();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: pressedStates[index]
                                      ? const Color(0xFFC9924A)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: const Color(0xFFA17135),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          //second row فنجان
                          left: (5.1 % columns) * (310 / columns),
                          top: (8 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/fng(lvl1).png',
                              width: 53,
                              height: 75,
                            ),
                          ),
                        ),
                        Positioned(
                          //bottom row فنجان
                          left: (2.9 % columns) * (315 / columns),
                          top: (20 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/fng(lvl1).png',
                              width: 57,
                              height: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          //top row دلة
                          left: (6 % columns) * (350 / columns),
                          top: (4 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/dah(lvl1).png',
                              width: 50,
                              height: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          // third row دلة
                          left: (8 % columns) * (310 / columns),
                          top: (10 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/dah(lvl1).png',
                              width: 50,
                              height: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          //second row تمر
                          left: (8.9 % columns) * (310 / columns),
                          top: (7.1 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/dates(lvl1).png',
                              width: 57,
                              height: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          //forth row تمر
                          left: (6 % columns) * (310 / columns),
                          top: (15.99 ~/ columns) * (300 / rows),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Image.asset(
                              'assets/images/dates(lvl1).png',
                              width: 57,
                              height: 70,
                            ),
                          ),
                        ),
                        CustomPaint(
                          painter: LinePainter(points),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: rows * columns,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              points.add(Offset(
                (index % columns) * (300 / columns),
                (index ~/ columns) * (300 / rows),
              ));
              pressedStates[index] = true;
              selectedPoints++;
              checkPoints();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: pressedStates[index] ? Colors.brown : Colors.transparent,
              border: Border.all(
                color: const Color(0xFFA17135),
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.transparent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int getSelectedSquareIndex() {
    if (points.isEmpty) {
      return -1;
    }

    int row = (points.last.dy / (300 / rows)).floor();
    int column = (points.last.dx / (300 / columns)).floor();
    int index = row * columns + column;

    if (index >= 0 && index < pressedStates.length && !pressedStates[index]) {
      return index;
    } else {
      int selectedSquare = index;

      if (isSequentialSelection(selectedSquare)) {
        return selectedSquare;
      }
    }

    return -1;
  }

  bool isSequentialSelection(int selectedSquare) {
    if (userSelectedPath.isNotEmpty) {
      int lastSelectedSquare = userSelectedPath.last;
      int difference = selectedSquare - lastSelectedSquare;

      if (difference == 1 || difference == columns) {
        userSelectedPath.add(selectedSquare);

        return true;
      }
    } else {
      userSelectedPath.add(selectedSquare);
      return true;
    }

    return false;
  }

  void checkPoints() {
    if (!correctPathSelected) {
      bool isCorrectPath = checkCorrectPath();

      if (isCorrectPath) {
        rollNumber++;

        setState(() {
          correctPathSelected = true;
          score++;
          // scoreN += 10; i change to point globel
          tempPoint += 5;
        });
        _resetGame();

        if (rollNumber == 3) {
          _showDialog('                أحسنت \n !لقد اخترت الطرق الصحيحة');
        }
      }
    } else {
      correctPathSelected = false;
      //scoreN -= 5; i change to point globel
      tempPoint -= 5;
    }
  }

  void updateSquareColor(Offset globalPosition) {
    int selectedSquare = getSelectedSquareIndex();

    if (selectedSquare != -1) {
      setState(() {
        pressedStates[selectedSquare] = true;
        selectedPoints++;
        checkPoints();
      });
    }
  }

  bool checkCorrectPath() {
    for (List<int> correctPathIndices in correctPathsIndicesList) {
      if (isCorrectPathForIndices(correctPathIndices)) {
        return true;
      }
    }
    return false;
  }

  bool isCorrectPathForIndices(List<int> correctPathIndices) {
    for (int index in correctPathIndices) {
      if (!pressedStates[index]) {
        return false;
      }
    }
    return true;
  }

  void checkUserPath() {
    // Check if the selected points form a correct path
    bool isCorrectPath = checkCorrectPath();

    setState(() {
      if (isCorrectPath) {
        for (int index
            in correctPathsIndicesList.expand((indices) => indices)) {
          pressedStates[index] = true;
        }
        points.clear();
      } else {
        for (int i = 0; i < pressedStates.length; i++) {
          if (pressedStates[i] && !correctPathIndices.contains(i)) {
            pressedStates[i] = false;
          }
        }
      }

      selectedPoints = 0;
      userSelectedPath.clear();
    });

    _showDialog(isCorrectPath ? 'تم اختيار المسار بنجاح' : 'مسار خاطئ');
  }

  double cmToPixels(double cm) {
    return cm * 38.5826771654;
  }

  void timerMsg(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                Image.asset(
                  'assets/images/timer_ended.png',
                  width: 150,
                  height: 160,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("X"),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                Image.asset(
                  'assets/images/clapping-hands.png',
                  width: 140,
                  height: 130,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FifthScreen()),
                );
                isTimerRunning = false;
              },
              child: Text("X"),
            ),
          ],
        );
      },
    );
  }

  /*void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            content: SizedBox(
              height: 250,
              child: Column(
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/images/clapping-hands.png',
                    width: 150,
                    height: 140,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("X"),
              ),
            ],
          ),
        );
      },
    );
  }*/
}

class LinePainter extends CustomPainter {
  final List<Offset> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 0.5;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FifthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: const Color(0xFFA17135),
            title: const Text(
              'لعبة صور وكلمة',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/picsNword_instrucion(lvl1).png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              /*   Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Positioned(
                  bottom: 700,
                  right: 400,
                  child: TextButton(
                    onPressed: () {
                      // Add logic for return button
                    },
                    child: Image.asset(
                      'images/return_BTN (LVL1).jpg',
                      width: 1.75 * 38.5826771654,
                      height: 1.5 * 38.5826771654,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 279),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    ' خذ التعليمات قبل أن تنطلق\nستظهر لك الان لعبة صور وكلمة\nعليك  إكتشاف الرابط بين الصور\nوإختيار الحروف الملائمة لتشكيل كلمة الرابط!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
              ), */
              Positioned(
                left:
                    (MediaQuery.of(context).size.width - 4 * 38.5826771654) / 2,
                bottom: 240,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SixithScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/go_BTN(LVL1).png',
                    width: 4 * 38.5826771654,
                    height: 3 * 38.5826771654,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SixithScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('صور وكلمة')),
          backgroundColor: Color(0xFFA17135),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/First_Level_BKG.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: MyGame(),
        ),
      ),
    );
  }
}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  int score = 0;
  String selectedLetter = '';
  String correctAnswer = 'نخل';
  List<String> letters = ["ر", "ل", "ط", "خ", "ف", "م", "ن", "ت"];
  List<String> chosenLetters = [];
  int remainingSeconds = 15;
  bool isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    countdown();
  }

  AudioPlayer player = AudioPlayer();
  void stopBKG() {
    player.stop();
  }

  void timerMsg(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                Image.asset(
                  'assets/images/timer_ended.png',
                  width: 150,
                  height: 160,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                tempPoint = 0;
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text("X"),
            ),
          ],
        );
      },
    );
  }

  void countdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (remainingSeconds > 0 && isTimerRunning) {
        setState(() {
          remainingSeconds--;
        });
        countdown();
      } else if (isTimerRunning) {
        // setState(() {
        isTimerRunning = false;
        timerMsg("!انتهى الوقت");
        stopBKG();

      }
    });
  }

  void resetGame() {
    setState(() {
      selectedLetter = '';
      chosenLetters.clear();
      remainingSeconds = 15;
      isTimerRunning = true;
    });
    countdown();
  }

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              content: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Text(
                      msg,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text("محاولة مجددًا"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/PnW_d(lvl1).jpg',
                    width: 170, height: 120), // زيادة حجم الصورة هنا
                SizedBox(width: 35),
                Image.asset('assets/images/PnW_p(lvl1).jpg',
                    width: 170, height: 120), // زيادة حجم الصورة هنا
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Color(0xFF8D6E63),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                chosenLetters.join(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (String letter in letters)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLetter = letter;
                        chosenLetters.add(letter);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA17135),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                          color:
                              Colors.white60), // تغيير لون النص إلى الأسود هنا
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (chosenLetters.isNotEmpty) {
                      setState(() {
                        chosenLetters.removeLast();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // تغيير لون الخلفية إلى الأزرق هنا
                  ),
                  child: Text(
                    'مسح',
                    style: TextStyle(
                        color: Colors.black), // تغيير لون النص إلى الأسود هنا
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isTimerRunning = false;
                String userAnswer = chosenLetters.join();
                if (userAnswer == correctAnswer) {
                  setState(() {
                    //score += 12; i change to point globel
                    tempPoint += 10;
                  });
                  if (userAnswer == correctAnswer && tempPoint >= 20) {
                    point += tempPoint;
                    tempPoint = 0;
                    reward1 = true;
                    lvl2 = true;
                    //i change to point globel
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              contentPadding:
                                  EdgeInsets.zero, // Remove default padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/candyPopup.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                child: Stack(
                                  //   children: [
                                  //Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Positioned(
                                      top: 42,
                                      bottom: 0,
                                      left: 155,
                                      right: 0,
                                      //child: SizedBox(height: 10),
                                      // Add SizedBox
                                      child: Text(
                                        '${tempPoint+point}', //i change to point globel
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF603D38),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 170,
                                      bottom: 0,
                                      left: 220,
                                      right: 0,
                                      child: TextButton(
                                        onPressed: () {
                                          // tempPoint += point;
                                          // tempPoint = 0;
                                          // reward1 = true;
                                          // lvl2 = true;
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapScreen()));
                                        },
                                        child: Icon(
                                          Icons.arrow_circle_right_rounded,
                                          color: Color(
                                              0xFF603D38), // Use the RGB value of the color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //],
                              ),
                            ));
                  }
                  stopBKG();
                } else {
                 _showDialog("خطأ  \nحاول مجددًا");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // تغيير لون الخلفية إلى الأزرق هنا
              ),
              child: Text(
                'تحقق',
                style: TextStyle(
                    color: Colors.black), // تغيير لون النص إلى الأسود هنا
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment(0, -0.6),
          child: Text('الوقت المتبقي: $remainingSeconds ثواني',
              style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
        Align(
          alignment: Alignment(0, -0.85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' عودة ',
                  style: TextStyle(fontSize: 22, color: Colors.black)),
              Text((point+tempPoint).toString(), //i change to point globel
                  style: TextStyle(fontSize: 22, color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
