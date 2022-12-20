import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hangman_game/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String word = wordslist[Random().nextInt(wordslist.length)];

  List guessedalphabets = [];

  int points = 0;
  int status = 0;

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
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
    } else {
      print("you lost");
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
      print("Won");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black45,
          title: Text(
            "HANGMAN",
            style: retroStyle(30, Colors.white, FontWeight.w700),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.volume_up_sharp,
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
                  decoration: BoxDecoration(color: Colors.lightBlueAccent),
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
                  image: AssetImage("images/hangman0.png"),
                  width: 155,
                  height: 155,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 15),
                Text(
                  "7 lives left",
                  style: retroStyle(18, Colors.grey, FontWeight.w700),
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
