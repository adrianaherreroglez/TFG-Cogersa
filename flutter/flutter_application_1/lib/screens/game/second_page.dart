import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'service/game_service.dart';
import 'service/Nivel.dart';
import 'service/SegundoNivel.dart';

import '../../widgets/nav_bar.dart';

class SecondPage extends StatefulWidget {
  final int puntosPrevios;

  const SecondPage({super.key, required this.puntosPrevios});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // Servicio del juego
  final GameService gameService = GameService();

  // Instancia del nivel
  final Nivel nivel = SegundoNivel();

  late List<Map<String, String>> objetos;


  // Índice del objeto que estamos mostrando
  int indiceObjetoActual = 0;

  // Indica si el objeto actual está visible
  bool objetoVisible = true;

  int puntos = 0;

  // INTENTOS DEL OBJETO ACTUAL
  int intentos = 0;

  // Objetos que están actualmente en cada contenedor
  String? objetoEnAmarillo;
  String? objetoEnAzul;
  String? objetoEnVerde;
  String? objetoEnMarron;

  // Inicializar juego
  @override
  void initState() {
    super.initState();
    puntos = widget.puntosPrevios;
    objetos = gameService.getObjetosSegundoNivel();
    objetos.shuffle(Random());
  }

  Map<String, String> get objetoActual {
    return objetos[indiceObjetoActual];
  }


  void comprobarRespuesta(String contenedor) {
    // Cada vez que se intenta colocar el objeto,
    // aumentamos el número de intentos.
    intentos++;

    // Guardamos el objeto actual antes de pasar al siguiente.
    final objeto = objetoActual;

    // Contenedor correcto del objeto actual
    final contenedorCorrecto = objetoActual['contenedor'];

    if (contenedor == contenedorCorrecto) {
 
      puntos = puntos + nivel.sumarPuntosRespuestaCorrecta();

      // Respuesta correcta
      setState(() {

        // Guardamos el objeto en el contenedor
        if (contenedor == 'amarillo') {
          objetoEnAmarillo = objeto['nombre'];
        } else if (contenedor == 'azul') {
          objetoEnAzul = objeto['nombre'];
        } else if (contenedor == 'verde') {
          objetoEnVerde = objeto['nombre'];
        } else if (contenedor == 'marron') {
          objetoEnMarron = objeto['nombre'];
        }

        indiceObjetoActual++;

        // El contador de intentos empieza de nuevo
        // para el nuevo objeto.
        intentos = 0;

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
        context.go('/third', extra: puntos);
      }
    }
    // Respuesta incorrecta
    else {
      puntos = puntos - nivel.restarPuntosRespuestaIncorrecta();
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
            if (objetoVisible && indiceObjetoActual < objetos.length)
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
                            gameService.imagenDelObjeto(objetoEnAmarillo!,objetos)!,
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
                            gameService.imagenDelObjeto(objetoEnAzul!,objetos)!,
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

                const SizedBox(width: 20),


                // CONTENEDOR MARRÓN
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('marron');
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
                          'assets/icons/contenedores/basura-marron.png',
                          width: 180,
                          height: 180,
                        ),

                        // Objeto que quedó dentro
                        if (objetoEnMarron != null)
                          Image.asset(
                            gameService.imagenDelObjeto(objetoEnMarron!,objetos)!,
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
