import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin {
  double top = 1;
  double left = 1;
  final double boxSize = 50.0;
  bool isPlay = false;

  void _moveBox() {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      // Calculate random position within screen bounds
      top = Random().nextDouble() * (screenSize.height - boxSize - 50);
      left = Random().nextDouble() * (screenSize.width - boxSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // 1. Your background content goes here
            Image.asset(
              'assets/images/bg1.jpg',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ), // Background
            // 2. Create a layer for liquid glass effects
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              top: top,
              left: left,
              onEnd: () {
                if (isPlay) {
                  _moveBox();
                }
              },
              child: LiquidGlassLayer(
                settings: LiquidGlassSettings(
                  blur: 3.5
                ),
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 30),
                  child: const SizedBox.square(dimension: 100),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: LiquidGlassLayer(
        child: GestureDetector(
          onTap: () {
            isPlay = !isPlay;
            _moveBox();
          },
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 30),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                !isPlay ? Icons.play_arrow : Icons.pause
              ),
            ),
          ),
        ),
      ),
    );
  }
}