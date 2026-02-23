import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Offset position = const Offset(100, 200);
  final double boxSize = 100;

  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void moveToBottom() {
    final screenHeight = MediaQuery.of(context).size.height;

    animation = Tween<Offset>(
      begin: position,
      end: Offset(position.dx, screenHeight - boxSize - 40),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        setState(() {
          position = animation.value;
        });
      });

    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final newX = position.dx + details.delta.dx;
                  final newY = position.dy + details.delta.dy;

                  position = Offset(
                    newX.clamp(0, screenSize.width - boxSize),
                    newY.clamp(0, screenSize.height - boxSize),
                  );
                });
              },
              child: LiquidGlassLayer(
                settings: const LiquidGlassSettings(blur: 6),
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 30),
                  child: SizedBox.square(
                    dimension: boxSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: moveToBottom,
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}