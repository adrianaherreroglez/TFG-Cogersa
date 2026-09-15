import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  // Lista de objetos
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'botella',
      'imagen':
          'assets/icons/objetos/amarillo/botella-de-plastico.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'avion',
      'imagen':
          'assets/icons/objetos/azul/avion-de-papel.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'botella de vidrio',
      'imagen':
          'assets/icons/objetos/verde/botella-de-vidrio.png',
      'contenedor': 'verde',
    },
  ];

  // Lista de objetos mezclada aleatoriamente
  late List<Map<String, String>> objetosMezclados;

  // Índice del objeto que estamos mostrando
  int indiceObjetoActual = 0;

  // Indica si el objeto actual está visible
  bool objetoVisible = true;


  // Inicializar juego
  @override
  void initState() {
    super.initState();
    objetosMezclados = List.from(objetos);
    objetosMezclados.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetosMezclados[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    // Contenedor correcto del objeto actual
    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
      // Respuesta correcta
      setState(() {
        indiceObjetoActual++;

        // Comprobamos si todavía quedan objetos
        if (indiceObjetoActual < objetosMezclados.length) {
          objetoVisible = true;
        } else {
          // Ya se han completado todos los objetos
          objetoVisible = false;
        }
      });
    } else {
      // Respuesta incorrecta
      // No cambiamos el índice.
      // Por tanto, el mismo objeto sigue apareciendo.
      setState(() {
        objetoVisible = true;
      });
    }
  }



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

            // Subtítulo (Nivel X)
            Text(
              'Nivel 1',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                color: Color(0xFF298133),
              ),
            ),


            const SizedBox(height: 40),

            // Objeto arrastable
            if (objetoVisible && indiceObjetoActual < objetosMezclados.length)
              Draggable<String>(
                // Nombre del objeto
                data: objetoActual['nombre']!,

                // Imagen arrastable
                feedback: Image.asset(
                  objetoActual['imagen']!,
                  width: 90,
                  height: 90,
                ),

                // Imagen que queda en la posición original
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: Image.asset(
                    objetoActual['imagen']!,
                    width: 90,
                    height: 90,
                  ),
                ),

                //Imagen normal
                child: Image.asset(
                  objetoActual['imagen']!,
                  width: 90,
                  height: 90,
                ),
              ),

            const Spacer(),

            // Contenedores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Contenedor amarillo
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('amarillo');
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

                // Contenedor azul
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('azul');
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

                // Contenedor verde
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('verde');
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