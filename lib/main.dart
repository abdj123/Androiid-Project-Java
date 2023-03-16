import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String word = generateRandomNoun().toUpperCase();

  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    String ww = word.substring(0, 1) +
        "_ " * (word.length - 2) +
        word.substring(word.length - 1);
    return Scaffold(
      backgroundColor: const Color(0xff39298a),
      appBar: AppBar(
        title: const Text("HangeMan"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff39298a),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                mywidg(game.tries >= 0, "assets/hang.png"),
                mywidg(game.tries >= 1, "assets/head.png"),
                mywidg(game.tries >= 2, "assets/body.png"),
                mywidg(game.tries >= 3, "assets/ra.png"),
                mywidg(game.tries >= 4, "assets/la.png"),
                mywidg(game.tries >= 5, "assets/rl.png"),
                mywidg(game.tries >= 6, "assets/ll.png")
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: Text(
              "Hint: $ww",
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: word
                  .split("")
                  .map((e) => letter(e.toUpperCase(),
                      !game.selectchar.contains(e.toUpperCase())))
                  .toList()),
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
                crossAxisCount: 7,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                padding: const EdgeInsets.all(8.0),
                children: alphabets.map((e) {
                  return RawMaterialButton(
                    onPressed: game.selectchar.contains(e)
                        ? null
                        : () {
                            setState(() {
                              game.selectchar.add(e);
                              if (!word.split("").contains(e.toUpperCase())) {
                                game.tries++;
                                if (game.tries == 6) {
                                  final scaf = ScaffoldMessenger.of(context);
                                  scaf.showSnackBar(SnackBar(
                                      content: Text(
                                          "Game Over!!!!\nThe Word Was $word"),
                                      action: SnackBarAction(
                                          label: "TryAgin",
                                          onPressed: () {
                                            //scaf.removeCurrentSnackBar();
                                            game.selectchar = [];
                                            game.tries = 0;
                                            word = generateRandomNoun();
                                          })));
                                } else if (game.selectchar == word.split("")) {
                                  final scaf = ScaffoldMessenger.of(context);
                                  scaf.showSnackBar(const SnackBar(
                                    content: Text("You Won!!!"),
                                  ));
                                }
                              }
                            });
                          },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    // ignore: sort_child_properties_last
                    child: Text(
                      e,
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                    fillColor: game.selectchar.contains(e)
                        ? Colors.black87
                        : Colors.blue,
                  );
                }).toList()),
          ),
          SizedBox(
            child: ElevatedButton(
              child: const Text("Reset"),
              onPressed: () {
                setState(() {
                  game.tries = 0;
                  game.selectchar = [];
                  word = generateRandomNoun();
                });
                //game.selectchar = ;
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget mywidg(bool visble, String path) {
  return Visibility(
      visible: visble,
      child: Container(
        width: 250,
        height: 250,
        child: Image.asset(path),
      ));
}

Widget letter(String char, bool hidden) {
  return Container(
    height: 65,
    width: 50,
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
        color: const Color(0xff231954),
        borderRadius: BorderRadius.circular(4.0)),
    child: Visibility(
      visible: !hidden,
      child: Text(
        char,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.0),
      ),
    ),
  );
}

// ignore: camel_case_types
class game {
  static int tries = 1;
  static List<String> selectchar = [];
}

String generateRandomNoun() {
  final noun = nouns.takeWhile((noun) => noun.length <= 6).toList();
  final randomIndex = Random().nextInt(noun.length);
  return noun[randomIndex];
}
