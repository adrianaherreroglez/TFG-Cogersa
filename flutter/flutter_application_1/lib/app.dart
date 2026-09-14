// Aplicación

import 'package:flutter/material.dart';

import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EcoKids', // Nombre de la pestaña

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),

      routerConfig: router,
    );
  }
}

