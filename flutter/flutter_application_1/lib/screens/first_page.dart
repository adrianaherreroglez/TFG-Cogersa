import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primera pantalla'),
      ),

      body: const Center(
        child: Text(
          'Primera pantalla',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
