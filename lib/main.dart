import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

// main function calling
// to the MyFlipCard class.
void main() {
  runApp(const MyFlipCard());
}

// Class MyFlipCard is stateful class.
class MyFlipCard extends StatefulWidget {
  const MyFlipCard({super.key});

  @override
  State<MyFlipCard> createState() => _MyFlipCardState();
}

class _MyFlipCardState extends State<MyFlipCard> {
  @override
  Widget build(BuildContext context) {
    // returning MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flip Card"),
        ),
        // body has a center with row child.
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flipcard with vertical
              // direction when flip
              FlipCard(
                direction: FlipDirection.VERTICAL,
                // front of the card
                front: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Text("Front"),
                ),
                // back of the card
                back: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.teal,
                  child: Image.asset(
                    'assets/images/vish.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              // 2nd card showing Horizontal FlipDirection
              FlipCard(
                direction: FlipDirection.HORIZONTAL,
                // front of the card
                front: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Text("Front"),
                ),
                // back of the card
                back: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.teal,
                  child: Image.asset(
                    'assets/images/vish.png',
                    fit: BoxFit.contain,
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
