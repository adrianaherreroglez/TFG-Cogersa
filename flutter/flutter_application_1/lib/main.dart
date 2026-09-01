import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

// -------------------------
// CONFIGURACIÓN DEL ROUTER
// -------------------------

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(
        title: 'Home Page',
      ),
    ),

    GoRoute(
      path: '/first',
      builder: (context, state) => const FirstPage(),
    ),
  ],
);

// -------------------------
// APP
// -------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),

      routerConfig: _router,
    );
  }
}

// -------------------------
// HOME PAGE
// -------------------------

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

            ElevatedButton(
              onPressed: () {

                // Ir a /first
                context.go('/first');

              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 18, 66, 25),

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

// -------------------------
// PRIMERA PANTALLA
// -------------------------

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