import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PuntoLimpioPage extends StatefulWidget {
  const PuntoLimpioPage({super.key});

  @override
  State<PuntoLimpioPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<PuntoLimpioPage> {
  // Lista de objetos del Punto Limpio
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'telefono',
      'imagen': 'assets/icons/puntolimpio/telefono-inteligente.png',
      'contenedor': 'informatica',
    },
    {
      'nombre': 'microondas',
      'imagen': 'assets/icons/puntolimpio/horno-microondas.png',
      'contenedor': 'electrodomesticos',
    },
    {
      'nombre': 'cd',
      'imagen': 'assets/icons/puntolimpio/cd.png',
      'contenedor': 'dvd',
    },
    {
      'nombre': 'bombilla',
      'imagen': 'assets/icons/puntolimpio/bombilla.png',
      'contenedor': 'iluminacion',
    },
    {
      'nombre': 'bateria',
      'imagen': 'assets/icons/puntolimpio/bateria.png',
      'contenedor': 'pilas',
    },
    {
      'nombre': 'cartucho',
      'imagen': 'assets/icons/puntolimpio/cartucho-de-tinta.png',
      'contenedor': 'toner',
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
        context.go('/mygame', extra: puntos);
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
            // =========================
            // BARRA DE NAVEGACIÓN
            // =========================
            Container(
              width: double.infinity,
              height: 80,
              color: const Color(0xFF298133),

              child: Row(
                children: [
                  const SizedBox(width: 40),

                  Text(
                    'EcoKids',
                    style: GoogleFonts.quicksand(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      'Inicio',
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  TextButton(
                    onPressed: () {
                      context.go('/listgame');
                    },
                    child: Text(
                      'Juegos',
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  const SizedBox(width: 40),
                ],
              ),
            ),

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

            // OBJETO ARRASTRABLE
            if (objetoVisible && indiceObjetoActual < objetosMezclados.length)
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
                // CONTENEDOR ILUMINACIÓN
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('iluminacion');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'ILUMINACIÓN',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),

                const SizedBox(width: 20),

                // CONTENEDOR ELECTRODOMÉSTICOS
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('electrodomesticos');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'ELECTRODOMÉSTICOS',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),

                const SizedBox(width: 20),

                // CONTENEDOR INFORMATICA
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('informatica');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'INFORMÁTICA',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),

                // CONTENEDOR TÓNER Y CARTUCHOS
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('toner');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'TÓNER Y CARTUCHOS',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),

                // CONTENEDOR DVD-CD Y RADIOGRAFÍAS
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('dvd');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'DVD-CD Y RADIOGRAFÍAS',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),

                // CONTENEDOR PILAS Y BATERÍAS
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('pilas');
                  },

                  builder:
                      (
                        BuildContext context,
                        List<String?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/contenedores/contenedor-de-basura.png',
                              width: 180,
                              height: 180,
                            ),

                            SizedBox(
                              width: 130,
                              child: Text(
                                'PILAS Y BATERÍAS',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
