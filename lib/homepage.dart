// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import "dart:async";
import "package:flappy_bird/barrier.dart";
import "package:flappy_bird/bird.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => Definition();
}

class Definition extends State<HomePage> {
  // Physics Behind the birds jump and Parabolic Path
  static double birdY = 0;
  double inipos = birdY;
  double height = 0;
  double time = 0;
  double halfGravity /*-gt²*/ = -2.9; // (y = -gt² + vt )Eqn - Unit m/s²
  double velocity = 1.5; // m/s
  double birdWidth = 0.05;
  double birdHeight = 0.01;
  // Settings
  bool game_has_started = false;

  // Barriers and Barrier Collision Logic
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    game_has_started = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      height = halfGravity * time * time + velocity * time;

      setState(() {
        birdY = inipos - height;
      });

// Logic to check if the Bird gas died or Not
      if (bird_is_dead()) {
        timer.cancel();
        _showDialog();
      }

// keep the map moving (moving barrier)
      moveMap();

// Time Counter
      time += 0.1;
    });
  }

// moveMap Function Defintion
  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.03;
      });

      // Logics for barriers in left Side of the screen

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

// Reset Game Function
  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      game_has_started = false;
      time = 0;
      inipos = birdY;
    });
  }

// Show Dialog Box Function
  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRect(
                  // borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      "P L A Y A G A I N",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      inipos = birdY;
    });
  }

  bool bird_is_dead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
// hits Barrier
// Checks if the bird is within x coordinates and y coordinates of barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    // If Bird is not dead return false
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: game_has_started ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      Bird(
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                        birdY: birdY,
                      ),

                      // Tap to play

                      // Top Barrier 0
                      Barrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      // Bottom Barrier 0
                      Barrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      // Top Barrier 1
                      Barrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      // Bottom Barrier 1
                      Barrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),

                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          game_has_started ? '' : 'T A P  T O  P L A Y',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
