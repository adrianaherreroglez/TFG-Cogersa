import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // Indica si la botella sigue visible
  bool botellaVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAFDF4),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // Título del juego
            Text(
              '¿A qué contenedor tirarías...?',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 15),

            // Subtítulo
            Text(
              'Nivel 1',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                color: const Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 40),

            // Botella arrastable
            if (botellaVisible)
              Draggable<String>(
                data: 'botella',

                // Imagen que se muestra mientras arrastramos
                feedback: Image.asset(
                  'assets/icons/objetos/amarillo/botella-de-plastico.png',
                  width: 90,
                  height: 90,
                ),

                // Qué queda en la posición original mientras se arrastra
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: Image.asset(
                    'assets/icons/objetos/amarillo/botella-de-plastico.png',
                    width: 90,
                    height: 90,
                  ),
                ),

                // Botella normalmente
                child: Image.asset(
                  'assets/icons/objetos/amarillo/botella-de-plastico.png',
                  width: 90,
                  height: 90,
                ),
              ),

            const Spacer(),

            // Tres contenedores a los que se puede arrastrar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Contenedor amarillo
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    if (details.data == 'botella') {
                      setState(() {
                        botellaVisible = false;
                      });
                    }
                  },

                  builder: (
                    BuildContext context,
                    List<String?> candidateData,
                    List<dynamic> rejectedData,
                  ) {
                    return Image.asset(
                      'assets/icons/contenedores/basura-amarilla.png',
                      width: 180,
                      height: 180,
                    );
                  },
                ),

                const SizedBox(width: 20),

                // Contendor azul
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    if (details.data == 'botella') {
                      // Si falla, la botella vuelve automáticamente
                      // porque no hemos cambiado botellaVisible.
                      setState(() {
                        botellaVisible = true;
                      });
                    }
                  },

                  builder: (
                    BuildContext context,
                    List<String?> candidateData,
                    List<dynamic> rejectedData,
                  ) {
                    return Image.asset(
                      'assets/icons/contenedores/basura-azul.png',
                      width: 180,
                      height: 180,
                    );
                  },
                ),

                const SizedBox(width: 20),

                // Contendor verde
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    if (details.data == 'botella') {
                      // Si falla, la botella vuelve automáticamente
                      setState(() {
                        botellaVisible = true;
                      });
                    }
                  },

                  builder: (
                    BuildContext context,
                    List<String?> candidateData,
                    List<dynamic> rejectedData,
                  ) {
                    return Image.asset(
                      'assets/icons/contenedores/basura-verde.png',
                      width: 180,
                      height: 180,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
