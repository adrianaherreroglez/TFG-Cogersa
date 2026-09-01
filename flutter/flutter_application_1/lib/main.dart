import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

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

      // Barra superior
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Contenido
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // Esto ocupa todo el espacio disponible
            const Spacer(),

            // Botón abajo
            ElevatedButton(
              onPressed: () {
                print("Has pulsado Iniciar");
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 18, 66, 25),
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
          ],
        ),
      ),
    );
  }
}

