import 'package:flutter/material.dart';

class SecondTab extends StatelessWidget {
  const SecondTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is the second tab content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
