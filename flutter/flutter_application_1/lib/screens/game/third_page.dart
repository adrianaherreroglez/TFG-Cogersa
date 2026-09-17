import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ThirdPage extends StatefulWidget {
    final int puntosPrevios;

    const ThirdPage({super.key, required this.puntosPrevios});


  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  // Lista de objetos del Tercer Nivel
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'juguete',
      'imagen':
          'assets/icons/objetos/gris/juguete-de-peluche.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'biberon',
      'imagen':
          'assets/icons/objetos/gris/biberon.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'tirita',
      'imagen':
          'assets/icons/objetos/gris/tirita.png',
      'contenedor': 'gris',
    },
    {
      'nombre': 'periodico',
      'imagen':
          'assets/icons/objetos/azul/periodico.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'leche',
      'imagen':
          'assets/icons/objetos/amarillo/leche.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'perfume',
      'imagen':
          'assets/icons/objetos/verde/perfume.png',
      'contenedor': 'verde',
    },
    {
      'nombre': 'manzana',
      'imagen':
          'assets/icons/objetos/marron/manzana.png',
      'contenedor': 'marron',
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
      // Respuesta correcta
      // Puntos que gana según el intento
      int puntosGanados = 0;

      if (intentos == 1) {
        puntosGanados = 50;
      } else if (intentos == 2) {
        puntosGanados = 40;
      } else if (intentos == 3) {
        puntosGanados = 30;
      } else if (intentos == 4) {
        puntosGanados = 20;
      } else if (intentos == 5){
        puntosGanados = 10;
      }

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
          context.go('/mygame', extra: puntos);

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
              'Nivel 3',
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

                const SizedBox(width: 20),
                
                // Contenedor marron
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('marron');
                  },

                  builder: (
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

                const SizedBox(width: 20),

                // Contenedor gris
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    comprobarRespuesta('gris');
                  },

                  builder: (
                    BuildContext context,
                    List<String?> candidateData,
                    List<dynamic> rejectedData,
                  ) {
                    return Image.asset(
                      'assets/icons/contenedores/basura-gris.png',
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