import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  // Lista de objetos del Primer Nivel
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

  // Índice del objeto actual
  int indiceObjetoActual = 0;

  // Indica si el objeto está visible
  bool objetoVisible = true;


  // PUNTOS TOTALES DE LA PARTIDA
  int puntos = 0;


  // INTENTOS DEL OBJETO ACTUAL
  int intentos = 0;

  @override
  void initState() {
    super.initState();

    objetosMezclados = List.from(objetos);
    objetosMezclados.shuffle(Random());
  }

  // Objeto actual
  Map<String, String> get objetoActual {
    return objetosMezclados[indiceObjetoActual];
  }

  // COMPROBAR RESPUESTA
  void comprobarRespuesta(String contenedor) {

    // Cada vez que se intenta colocar el objeto,
    // aumentamos el número de intentos.
    intentos++;

    // Contenedor correcto
    final contenedorCorrecto = objetoActual['contenedor'];

    // RESPUESTA CORRECTA
    if (contenedor == contenedorCorrecto) {

      // Puntos que gana según el intento
      int puntosGanados = 0;

      if (intentos == 1) {
        puntosGanados = 30;
      } else if (intentos == 2) {
        puntosGanados = 20;
      } else if (intentos == 3) {
        puntosGanados = 10;
      }

      setState(() {

        // Los puntos SE ACUMULAN.
        puntos += puntosGanados;

        // Pasamos al siguiente objeto
        indiceObjetoActual++;

        // El contador de intentos empieza de nuevo
        // para el nuevo objeto.
        intentos = 0;

        // Comprobamos si quedan objetos
        if (indiceObjetoActual < objetosMezclados.length) {
          objetoVisible = true;
        } else {
          objetoVisible = false;
        }
      });

      // FIN DEL NIVEL
      if (indiceObjetoActual >= objetosMezclados.length) {

        //print('PUNTOS FINALES: $puntos');

        // Pasamos al siguiente nivel
        context.go('/second',extra: puntos);
      }

    } else {

      // RESPUESTA INCORRECTA
      setState(() {
        // El objeto continúa visible
        objetoVisible = true;
      });

      //print('Respuesta incorrecta');
      //print('Intento actual: $intentos');
      //print('Puntos actuales: $puntos');
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

            Text(
              '¿A QUÉ CONTENEDOR TIRARÍAS...?',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Nivel 1',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF298133),
              ),
            ),

            const SizedBox(height: 10),

            // PUNTOS
            Text(
              'Puntos: $puntos',
              style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 64, 9),
              ),
            ),

            const SizedBox(height: 40),

            // OBJETO ARRASTRABLE
            if (objetoVisible &&
                indiceObjetoActual < objetosMezclados.length)
              Draggable<String>(
                data: objetoActual['nombre']!,

                // Imagen mientras se arrastra
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

                // Imagen normal
                child: Image.asset(
                  objetoActual['imagen']!,
                  width: 90,
                  height: 90,
                ),
              ),

            const Spacer(),

            // CONTENEDORES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // CONTENEDOR AMARILLO
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

                // CONTENEDOR AZUL
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

                // CONTENEDOR VERDE
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
