import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAFDF4),

        child: const Column(
          children: [
            SizedBox(height: 30),

            Center(
              child: Text(
                '¿A qué contenedor tirarías...?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF298133),
                ),
              ),
            ),

            SizedBox(height: 15), // Separación entre ambos

            Text(
              'Nivel 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF298133),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
