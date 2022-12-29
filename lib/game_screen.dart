import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  String word = wordslist[Random().nextInt(wordslist.length)];
  List guessedalphabets = [];
  int points = 0;
  int status = 0;
  bool soundOn = true;

  List images = [
    'images/hangman0.png',
    'images/hangman1.png',
    'images/hangman2.png',
    'images/hangman3.png',
    'images/hangman4.png',
    'images/hangman5.png',
    'images/hangman6.png',
  ];

  playSound(String soundPath) async {
    if (soundOn) {
      await audioPlayer.play(AssetSource(soundPath));
    }
  }

  openDialog(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: BoxDecoration(color: Colors.purpleAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: retroStyle(25, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Your points $points ",
                    style: retroStyle(20, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          status = 0;
                          guessedalphabets.clear();
                          points = 0;
                          word = wordslist[Random().nextInt(wordslist.length)];
                        });
                        playSound('restart.mp3');
                      },
                      child: Center(
                        child: Text(
                          "Play Again",
                          style: retroStyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String handleText() {
    String displayword = "";
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (guessedalphabets.contains(char)) {
        displayword += char + " ";
      } else {
        displayword += "? ";
      }
    }
    return displayword;
  }

  checkLetter(String alphabet) {
    if (word.contains(alphabet)) {
      setState(() {
        guessedalphabets.add(alphabet);
        points += 5;
      });
      playSound('correct.mp3');
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
      playSound('wrong.mp3');
    } else {
      openDialog("You Lost! ");
      playSound('lost.mp3');
    }
    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!guessedalphabets.contains(char)) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      openDialog("Hurray, you won!!!! ");
      playSound("won.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 166, 187, 141),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black45,
          title: Text(
            "HANGMAN",
            style: retroStyle(30, Colors.white, FontWeight.w700),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    soundOn = !soundOn;
                  });
                },
                icon: Icon(
                  soundOn ? Icons.volume_up_sharp : Icons.volume_off_sharp,
                  color: Colors.red.shade400,
                  size: 40,
                ))
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 234, 231, 177)),
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 30,
                  child: Text(
                    "$points points",
                    style: retroStyle(15, Colors.black, FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Image(
                  color: Colors.white,
                  image: AssetImage(images[status]),
                  width: 155,
                  height: 155,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 15),
                Text(
                  "${7 - status} lives left",
                  style: retroStyle(18, Colors.black45, FontWeight.w700),
                ),
                SizedBox(height: 30),
                Text(
                  handleText(),
                  style: retroStyle(35, Colors.white, FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 7,
                  padding: EdgeInsets.only(left: 10),
                  childAspectRatio: 1.3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: letters.map(
                    (alphabet) {
                      return InkWell(
                        onTap: () => checkLetter(alphabet),
                        child: Center(
                          child: Text(
                            alphabet,
                            style:
                                retroStyle(25, Colors.white, FontWeight.w700),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
