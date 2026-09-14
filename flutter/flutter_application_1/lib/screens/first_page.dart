import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAFDF4),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // TÍTULO
            const Text(
              '¿A qué contenedor tirarías...?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 15),

            // SUBTÍTULO
            const Text(
              'Nivel 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 40),

            // BOTELLA
            Center(
              child: Image.asset(
                'assets/icons/objetos/botella-de-plastico.png',
                width: 90,
                height: 90,
              ),
            ),

            // Empuja los iconos hacia abajo
            const Spacer(),

            // TRES ICONOS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/contenedores/basura-amarilla.png',
                  width: 180,
                  height: 180,
                ),

                const SizedBox(width: 20),

                Image.asset(
                  'assets/icons/contenedores/basura-azul.png',
                  width: 180,
                  height: 180,
                ),

                const SizedBox(width: 20),

                Image.asset(
                  'assets/icons/contenedores/basura-verde.png',
                  width: 180,
                  height: 180,
                ),
              ],
            ),

            // Separación del borde inferior
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}