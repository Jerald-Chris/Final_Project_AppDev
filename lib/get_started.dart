import 'package:final_project_appdev/main.dart';
import 'package:final_project_appdev/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreen(),
  ));
}

class ClimaTechApp extends StatelessWidget {
  const ClimaTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Started',
      theme: ThemeData(
        fontFamily: 'Manrope',
      ),
      home: const ClimaTechHomePage(),
    );
  }
}

class ClimaTechHomePage extends StatefulWidget {
  const ClimaTechHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClimaTechHomePageState createState() => _ClimaTechHomePageState();
}

class _ClimaTechHomePageState extends State<ClimaTechHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color.fromARGB(255, 37, 15, 65),
                  Color.fromARGB(255, 129, 19, 198),
                ],
                begin: _topAlignmentAnimation.value,
                end: _bottomAlignmentAnimation.value,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/images/logo-climatech.png'),
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ClimaTech',
                    style: TextStyle(
                      fontFamily: 'ArsenalSC-Bold',
                      fontSize: 55,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Weathering With You',
                    style: TextStyle(
                      fontFamily: 'Manrope-Bold',
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 242, 245, 65),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
