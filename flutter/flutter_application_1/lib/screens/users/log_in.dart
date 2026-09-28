import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TÍTULO
            Text(
              //no poner const con GoogleFonts
              'Iniciar Sesión',
              style: GoogleFonts.quicksand(
                fontSize: 82,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 10),

            // Campo de usuario
            TextField(
              decoration: InputDecoration(
                labelText: 'Usuario',
                hintText: 'Introduce tu usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de contraseña
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Introduce tu contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí irá el código para iniciar sesión
                  context.go('/listgame');
                },
                child: const Text('Iniciar sesión'),
              ),
            ),

            const SizedBox(height: 15),

            // Enlace: contraseña olvidada
            TextButton(
              onPressed: () {
                // Ir a recuperar contraseña
              },
              child: const Text('He olvidado mi contraseña'),
            ),

            // Enlace: crear cuenta
            TextButton(
              onPressed: () {
                // Ir a crear cuenta
              },
              child: const Text('No tengo cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
