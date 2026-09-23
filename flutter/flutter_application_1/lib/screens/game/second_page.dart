import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart' ;

class SecondPage extends StatefulWidget {
  final int puntosPrevios;

  const SecondPage({super.key, required this.puntosPrevios});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // Lista de objetos del Segundo Nivel
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'platano',
      'imagen': 'assets/icons/objetos/marron/platano.png',
      'contenedor': 'marron',
    },
    {
      'nombre': 'espina',
      'imagen': 'assets/icons/objetos/marron/espina-de-pescado.png',
      'contenedor': 'marron',
    },
    {
      'nombre': 'tarro',
      'imagen': 'assets/icons/objetos/verde/tarro-de-mermelada.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'caja',
      'imagen': 'assets/icons/objetos/azul/caja.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'lata',
      'imagen': 'assets/icons/objetos/amarillo/lata-de-refresco.png',
      'contenedor': 'amarillo',
    },
  ];

  // Lista de objetos mezclada aleatoriamente
  late List<Map<String, String>> objetosMezclados;

  // Índice del objeto que estamos mostrando
  int indiceObjetoActual = 0;

  // Indica si el objeto actual está visible
  bool objetoVisible = true;

  int puntos = 0;

  // INTENTOS DEL OBJETO ACTUAL
  int intentos = 0;

  // Inicializar juego
  @override
  void initState() {
    super.initState();
    puntos = widget.puntosPrevios;
    objetosMezclados = List.from(objetos);
    objetosMezclados.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetosMezclados[indiceObjetoActual];
  }

  void comprobarRespuesta(String contenedor) {
    // Cada vez que se intenta colocar el objeto,
    // aumentamos el número de intentos.
    intentos++;

    // Contenedor correcto del objeto actual
    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
      // Puntos que gana según el intento
      int puntosGanados = 0;

      if (intentos == 1) {
        puntosGanados = 40;
      } else if (intentos == 2) {
        puntosGanados = 30;
      } else if (intentos == 3) {
        puntosGanados = 20;
      }else if (intentos == 4) {
        puntosGanados = 10;
      }

      // Respuesta correcta
      setState(() {
        // Los puntos SE ACUMULAN.
        puntos += puntosGanados;

        indiceObjetoActual++;

        // El contador de intentos empieza de nuevo
        // para el nuevo objeto.
        intentos = 0;

        // Comprobamos si todavía quedan objetos
        if (indiceObjetoActual < objetosMezclados.length) {
          objetoVisible = true;
        } else {
          // Ya se han completado todos los objetos
          objetoVisible = false;
          // Si se acaban pasamos al siguiente nivel
          context.go('/third', extra: puntos);
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
            // BARRA DE NAVEGACIÓN
            const NavBar(),

            const SizedBox(height: 30),

            // Título del juego
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

            // Subtítulo (Nivel X)
            Text(
              'Nivel 2',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF298133),
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

            const SizedBox(height: 10),

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

                  builder:
                      (
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

                  builder:
                      (
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

                  builder:
                      (
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

                const SizedBox(width: 20),

                // Contenedor marron
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('marron');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Image.asset(
                          'assets/icons/contenedores/basura-marron.png',
                          width: 180,
                          height: 180,
                        );
                      },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
