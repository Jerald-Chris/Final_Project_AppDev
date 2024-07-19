import 'package:final_project_appdev/main.dart';
import 'package:final_project_appdev/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreen()
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

class ClimaTechHomePage extends StatelessWidget {
  const ClimaTechHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 29, 3, 45),
              Color.fromARGB(255, 107, 65, 213), 
            ],
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
              const Text('ClimaTech',
                style: TextStyle(
                  fontFamily: 'ArsenalSC-Bold',
                  fontSize: 55,
                  color: Colors.white,
                  fontWeight: FontWeight.w900
                ),
              ),
              const SizedBox(height: 10),
              const Text('Weathering With You',
                style: TextStyle(
                  fontFamily: 'Manrope-Bold',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()),);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 161, 227),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w800
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
