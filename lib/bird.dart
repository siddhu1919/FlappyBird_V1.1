import "package:flutter/material.dart";

class Bird extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final birdY;
  final double birdWidth;
  final double birdHeight;
  const Bird(
      {super.key,
      this.birdY,
      required this.birdHeight,
      required this.birdWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        "lib/assets/redbird-upflap.png",
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdWidth / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
