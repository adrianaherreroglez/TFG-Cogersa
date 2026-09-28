import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart';
import 'service/game_service.dart';
import 'service/Nivel.dart';
import 'service/PrimerNivel.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  // Servicio del juego
  final GameService gameService = GameService();

  // Nivel del juego
  final Nivel primerNivel = PrimerNivel();

  late List<Map<String, String>> objetos;

  // Índice del objeto actual
  int indiceObjetoActual = 0;

  // Indica si el objeto está visible
  bool objetoVisible = true;

  // PUNTOS TOTALES DE LA PARTIDA
  int puntos = 0;

  // INTENTOS DEL OBJETO ACTUAL
  int intentos = 0;

  // Objetos que están actualmente en cada contenedor
  String? objetoEnAmarillo;
  String? objetoEnAzul;
  String? objetoEnVerde;

  @override
  void initState() {
    super.initState();

    objetos = gameService.getObjetosPrimerNivel();
    objetos.shuffle(Random());
  }


  // Objeto actual
  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }


  // Comprobar respuesta
  void comprobarRespuesta(String contenedor) {

    // Cada vez que se intenta colocar el objeto,
    // aumentamos el número de intentos.
    intentos++;


    // Guardamos el objeto actual antes de pasar al siguiente
    final objeto = objetoActual;

    // Contenedor correcto
    final contenedorCorrecto = objeto['contenedor'];

    // Respuesta correcta
    if (contenedor == contenedorCorrecto) {

      puntos = puntos + primerNivel.sumarPuntosRespuestaCorrecta();

      setState(() {
        // Guardamos el objeto en el contenedor
        if (contenedor == 'amarillo') {
          objetoEnAmarillo = objeto['nombre'];
        } else if (contenedor == 'azul') {
          objetoEnAzul = objeto['nombre'];
        } else if (contenedor == 'verde') {
          objetoEnVerde = objeto['nombre'];
        }

        // Pasamos al siguiente objeto
        indiceObjetoActual++;

        // El contador de intentos empieza de nuevo
        intentos = 0;

        // Comprobamos si quedan objetos
        if (indiceObjetoActual < objetos.length) {
          objetoVisible = true;
        } else {
          objetoVisible = false;
        }
      });


      // Fin de nivel
      if (indiceObjetoActual >= objetos.length) {
        context.go(
          '/second',
          extra: puntos,
        );
      }
    }

    // Respuesta incorrecta
    else {
      puntos = puntos - primerNivel.restarPuntosRespuestaIncorrecta();
      setState(() {
        // El objeto continúa visible
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
            // Barra de navegación
            const NavBar(),

            const SizedBox(height: 30),

            // Título
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

            // Nivel
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

            // Puntos
            Text(
              'Puntos: $puntos',
              style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 64, 9),
              ),
            ),

            const SizedBox(height: 10),

            // Objeto arrastrable
            if (objetoVisible &&
                indiceObjetoActual < objetos.length)
              Draggable<String>(
                data: objetoActual['nombre']!,

                // Imagen mientras se arrastra
                feedback: Image.asset(
                  objetoActual['imagen']!,
                  width: 90,
                  height: 90,
                ),

                // Imagen que queda en la posición original
                // mientras se está arrastrando
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

            // Contenedores
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
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Contenedor
                        Image.asset(
                          'assets/icons/contenedores/basura-amarilla.png',
                          width: 180,
                          height: 180,
                        ),

                        // Objeto que quedó dentro
                        if (objetoEnAmarillo != null)
                          Image.asset(
                            gameService.imagenDelObjeto(objetoEnAmarillo!, objetos)!,
                            width: 70,
                            height: 70,
                          ),
                      ],
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
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Contenedor
                        Image.asset(
                          'assets/icons/contenedores/basura-azul.png',
                          width: 180,
                          height: 180,
                        ),

                        // Objeto que quedó dentro
                        if (objetoEnAzul != null)
                          Image.asset(
                            gameService.imagenDelObjeto(objetoEnAzul!, objetos)!,
                            width: 70,
                            height: 70,
                          ),
                      ],
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
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Contenedor
                        Image.asset(
                          'assets/icons/contenedores/basura-verde.png',
                          width: 180,
                          height: 180,
                        ),

                        // Objeto que quedó dentro
                        if (objetoEnVerde != null)
                          Image.asset(
                            gameService.imagenDelObjeto(objetoEnVerde!,objetos)!,
                            width: 70,
                            height: 70,
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