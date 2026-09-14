import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // Empuja el botón hacia abajo
            const Spacer(),

            // Centra el botón horizontalmente
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/first');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF644633),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(120, 45),
                ),

                child: const Text(
                  "Iniciar",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

