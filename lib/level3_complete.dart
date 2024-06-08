// done to change  all Score to point globelScore
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'mapScreen.dart';
import 'globals.dart';
import 'Quiz.dart';
import 'settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الألوان',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: level3(),
    );
  }
}

class ColorWordPair {
  final Color color;
  final String word;

  ColorWordPair({required this.color, required this.word});
}

class level3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF354B23),
        title: const Text(
          'تعليمات لعبة تأثير ستروب',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/stroop_instrution(lvl3).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100.0), // زيادة التباعد العمودي
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorGameScreen()),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorGameScreen extends StatefulWidget {
  @override
  _ColorGameScreenState createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen> {
  int score = 0;
  List<String> words = ['أحمر', 'أزرق', 'أخضر', 'برتقالي', 'بنفسجي', 'وردي'];
  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink];

  Random random = Random();
  String word = '';
  Color textColor = Colors.black;
  late Timer timer;
  int remainingSeconds = 15;
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
    player.play(AssetSource('sound/lvl3_sound(rain).mp3'), volume: soundEnabled ? 1.0 : 0.0);
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
        isTimerRunning = false;
        // timerMsg("!انتهى الوقت");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      }
    });
    generateQuestion();
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
      //  score+=3;  i change to point globel
        tempPoint +=3;
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
                child: Text('حاول مجددا'),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF354B23),
        title: const Text(
          ' لعبة تأثير ستروب',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Third_Level_BKG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 60.0,
            left: 185.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((point+tempPoint).toString(), // i change to point globel
                    style: TextStyle(fontSize: 22,  color: Colors.black)),
                Text(' عودة ', style: TextStyle(fontSize: 22, color: Colors.black)),
              ],
            ),
          ),
          Positioned(
            top: 270.0,
            left: 120.0,
            child: Text(
              'الوقت المتبقي: $remainingSeconds ثواني',
              style: TextStyle(fontSize: 20.0,),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
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
                    style: ElevatedButton.styleFrom(backgroundColor: colors[index]),
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
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF354B23),
        title: const Text(
          'تعليمات لعبة توصيل العناصر',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dots_instruction(lvl3).jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100.0), // زيادة التباعد العمودي
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAp()),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MyAp extends StatelessWidget {
  const MyAp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: const Color(0xFF354B23),
            title: const Text(
              'لعبة توصيل العناصر ',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            centerTitle: true,
          ),
        ),

        body: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dots_BKG(lvl3).png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [ GameScreen(),

             /* Padding(  //return button
              padding: const  EdgeInsets.only(top: 5),
              child: Positioned(
              bottom: 700,
              right: 400 ,
              child: TextButton(
              onPressed: (){
             add logic
              },
              /*child: Image.asset(
                      'Assets/Images/return_BTN (LVL3).png',
                      width: 1.75 * 38.582,
                      height: 2 * 38.582,
                    ),*/
               ),
              ),
               ), */
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
  final int requiredPoints = 6;
  int score = 0; //number of tries
  int rollNumber = 0;
  bool correctPathSelected = false;
  late Timer timer;
  int remainingSeconds = 20;
  bool isTimerRunning = true;
  int scoreN=0; //players score

  /* void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        remainingTime = max(0, remainingTime - 1);
      });

      if (remainingTime == 0) {
        // timerMsg(" انتهى الوقت! ");
      }
    });
  }*/

  void countdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer)
    {
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
  List<int> correctPathIndices = [6,11,12,17,18,19,14,13];
  List<List<int>> correctPathsIndicesList = [
    [6,11,12,13], [6,11,12,17,18,13], //mnt paths
    [10,11,12,17,22,21], [10,15,20,21], //flwr paths
    [16,17,18,23], [16,17,22,23], //plt paths
    [9,14,19,24], //hll path
    [7,8,3,4], //pep path
    [2,1,0,5], //sdo path
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
    countdown();
  }

  @override
  Widget build(BuildContext context) {
    final ksize = MediaQuery
        .of(context)
        .size;
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
            const SizedBox(
                height: 43 ),
            Text(
              '     عودة\t${(point+tempPoint).toString()}',// i change to point globel
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 22,
              ),
            ),

            Text(
              '\n الوقت المتبقي: $remainingSeconds ثواني',
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
              ),
            ),

            const SizedBox(
              height: 13,
            ),
            Text(
              'من 6 إحتمالات\t$score',
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            rollNumber == 6
                ? const SizedBox(
             /* child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetGame();
                    rollNumber = 0;
                    score = 0;
                  });
                }, child: null,
              ), */
            ) :

            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  buildGrid(),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                ? const Color(0xFF005D22)
                                : Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF005D22),
                              width: 1.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned( //top row sdo
                    left: (12 % columns) * (310 / columns),
                    top: (2.7 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/sdo(lvl3).png',
                        width: 53,
                        height: 60,
                      ),
                    ),
                  ),

                  Positioned( //second row sdo
                    left: (5.06 % columns) * (340 / columns),
                    top: (6.8 ~/ columns) * (280/ rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/sdo(lvl3).png',
                        width: 49,
                        height: 60,
                      ),
                    ),
                  ),

                  Positioned( //top row pep
                    left: (13.5 % columns) * (350 / columns),
                    top: (2.5 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/pep(lvl3).png',
                        width: 50,
                        height: 70,
                      ),
                    ),
                  ),

                  Positioned( // second row pep
                    left: (12 % columns) * (310 / columns),
                    top: (7 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/pep(lvl3).png',
                        width: 50,
                        height: 70,
                      ),
                    ),
                  ),

                  Positioned( //second row mnt
                    left: (6 % columns) * (310 / columns),
                    top: (7 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/mnt(lvl3).png',
                        width: 55,
                        height: 60,
                      ),
                    ),
                  ),

                  Positioned( //third row mnt
                    left: (12.91 % columns) * (310 / columns),
                    top: (10.2 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/mnt(lvl3).png',
                        width: 55,
                        height: 61,
                      ),
                    ),
                  ),

                  Positioned( //third row flwr
                    left: (5.1 % columns) * (200 / columns),
                    top: (10.2 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/flwr(lvl3).png',
                        width: 50,
                        height: 60,
                      ),
                    ),
                  ),

                  Positioned( //bottom row flwr
                    left: (6.1% columns) * (310 / columns),
                    top: (20.1 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/flwr(lvl3).png',
                        width: 50,
                        height: 60,
                      ),
                    ),
                  ),

                  Positioned( //fourth row plt
                    left: (6 % columns) * (310 / columns),
                    top: (18 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/plt(lvl3).png',
                        width: 57,
                        height: 70,
                      ),
                    ),
                  ),

                  Positioned( //bottom row plt
                    left: (12.9 % columns) * (310 / columns),
                    top: (20.1 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/plt(lvl3).png',
                        width: 57,
                        height: 70,
                      ),
                    ),
                  ),

                  Positioned( //second row hll
                    left: (13.9 % columns) * (310 / columns),
                    top: (7.1 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/hll(lvl3).png',
                        width: 57,
                        height: 70,
                      ),
                    ),
                  ),

                  Positioned( //bottom row hll
                    left: (13.9 % columns) * (310 / columns),
                    top: (20.1 ~/ columns) * (300 / rows),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        'assets/images/hll(lvl3).png',
                        width: 57,
                        height: 70,
                      ),
                    ),
                  ),

                  CustomPaint(painter: LinePainter(points),
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
              color: pressedStates[index] ? Colors.green : Colors.transparent,
              border: Border.all(
                color: const Color(0xFF45E729),
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
         // scoreN+=20; i change to point globel
          tempPoint +=15;
        });
        _resetGame();

        if (rollNumber == 6) {
          _showDialog('                أحسنت \n !لقد اخترت الطرق الصحيحة');
        }
      }
    } else {
      correctPathSelected = false;
     // scoreN-=10; i change to point globel
      tempPoint -=10;
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
        for (int index in correctPathsIndicesList.expand((
            indices) => indices)) {
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
    return cm * 38.5826771654;  }



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
                isTimerRunning=false;
              },
              child: Text("X"),
            ),
          ],
        );
      },
    );
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
}




class LinePainter extends CustomPainter {
  final List<Offset> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
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
            backgroundColor: const Color(0xFF354B23),
            title: const Text(
              'تعليمات لعبة صور و كلمة',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/picsNword_instruction(lvl3).jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [


              Positioned(
                left: (MediaQuery.of(context).size.width - 4 * 38.5826771654) / 2,
                bottom: 240,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>SixithScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/go_BTN(lvl3).png',
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
          title: Center(child: Text(' صور وكلمة')),
          backgroundColor: Color(0xFF354B23), // تم تغيير لون الخلفية هنا
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Third_Level_BKG.jpg'),
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
  String correctAnswer = 'السودة';
  List<String> letters = ["ة","ب","د","ج","ر","و","ط","س","ف","ل","ن","ا"];
  List<String> chosenLetters = [];
  int remainingSeconds = 20;
  bool isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    countdown();
  }


  AudioPlayer player = AudioPlayer();
  void stopBKG(){
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
                  MaterialPageRoute(builder: (context) => Quiz()),
                );
              },
              child: Text("X"),
            ),
          ],
        );
        stopBKG();
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
        isTimerRunning = false;
        timerMsg("!انتهى الوقت");
        stopBKG();
        /*showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('انتهى الوقت!'),
            content: Text('إنتهى الوقت إضغط على التالي للإنتقال للخريطة'),
            actions: [
              TextButton(
                onPressed: () {
                  resetGame();

                },
                child: Text('التالي'),
              ),
            ],
          ),
        ); */

      }
    });
  }

  void resetGame() {
    setState(() {
      selectedLetter = '';
      chosenLetters.clear();
      remainingSeconds = 20;
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
        }
    );
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
                Image.asset('assets/images/PnW_c(lvl3).jpg', width: 170, height: 150), // زيادة حجم الصورة هنا
                SizedBox(width: 20),
                Image.asset('assets/images/PnW_t(lvl3).jpg', width: 170, height: 150), // زيادة حجم الصورة هنا
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Color(0xFFFFCC80),
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
                      backgroundColor:  Color(0xFF1B5E20), // تغيير لون الخلفية إلى الأزرق هنا
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(color: Colors.white), // تغيير لون النص إلى الأسود هنا
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
                    backgroundColor:  Colors.white, //
                  ),
                  child: Text(
                    'مسح',
                    style: TextStyle(color: Colors.black),
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
                    //score += 24; i change to point globel
                    tempPoint +=20;
                  });
                  if(userAnswer == correctAnswer &&  tempPoint >= 80){
                    point += tempPoint;
                    tempPoint = 0;
                    reward3 = true;
                    lvl3 = true; // i change to point globel
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.zero, // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/tolOudPopup.png'),
                                fit: BoxFit.cover,
                              ),
                            ),

                            child: Stack(
                              //   children: [
                              //Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Positioned(
                                  top: 30,
                                  bottom: 0,
                                  left: 160,
                                  right: 0,
                                  //child: SizedBox(height: 10),
                                  // Add SizedBox
                                  child: Text(
                                    '${point+tempPoint}',// i change to point globel
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF004E18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 170,
                                  bottom: 0,
                                  left: 225,
                                  right: 0,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Quiz()));
                                    },
                                    child: Icon(
                                      Icons.arrow_circle_right_rounded,
                                      color: Color(
                                          0xFF004E18), // Use the RGB value of the color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //],
                          ),
                        ));} stopBKG();
                } else {
                  _showDialog("  خطأ \n حاول مجددًا");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.white,
              ),
              child: const Text(
                'تحقق',
                style: TextStyle(color: Colors.black), // تغيير لون النص إلى الأسود هنا
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment(0, -0.7),
          child: Text('الوقت المتبقي: $remainingSeconds ثواني', style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
        Align(
          alignment: Alignment(0, -0.84),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' عودة ', style: TextStyle(fontSize: 20, color: Colors.black)),
              Text((point+tempPoint).toString(), // i change to point globel
                  style: TextStyle(fontSize: 22, color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}