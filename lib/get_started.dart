import 'package:flutter/material.dart';

void main() {
  runApp(const ClimaTechApp());
}

class ClimaTechApp extends StatelessWidget {
  const ClimaTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaTech',
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
              Color.fromARGB(255, 29, 3, 45), // Top color
              Color.fromARGB(255, 107, 65, 213), // Bottom color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.cloud, // Replace this with your custom cloud icon if available
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'ClimaTech',
                style: TextStyle(
                  fontSize: 55,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Weathering With You',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Yellow color for the button
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 29, 3, 45),
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
