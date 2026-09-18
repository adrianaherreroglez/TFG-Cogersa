import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PuntoLimpioPage extends StatefulWidget {
  const PuntoLimpioPage({super.key});

  @override
  State<PuntoLimpioPage> createState() => _PuntoLimpioPageState();
}

class _PuntoLimpioPageState extends State<PuntoLimpioPage> {
  // Lista de objetos del Punto Limpio
  final List<Map<String, String>> objetos = [
    {
      'nombre': 'botella',
      'imagen': 'assets/icons/objetos/amarillo/botella-de-plastico.png',
      'contenedor': 'amarillo',
    },
    {
      'nombre': 'avion',
      'imagen': 'assets/icons/objetos/azul/avion-de-papel.png',
      'contenedor': 'azul',
    },
    {
      'nombre': 'botella de vidrio',
      'imagen': 'assets/icons/objetos/verde/botella-de-vidrio.png',
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
      setState(() {
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
        //context.go('/second',extra: puntos);
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
            const SizedBox(height: 10),

            // OBJETOARRASTRABLE
            Image.asset(
              'assets/icons/puntolimpio/telefono-inteligente.png',
              width: 80,
              height: 80,
            ),

            const Spacer(),

            // CONTENEDORES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CONTENEDOR ILUMINACIÓN
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
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
                ),

                const SizedBox(width: 20),

                // CONTENEDOR PEQUEÑOS ELECTRODOMÉSTICOS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
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
                ),

                const SizedBox(width: 20),

                // CONTENEDOR INFORMÁTICA
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
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
                ),

                // CONTENEDOR TÓNER Y CARTUCHOS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
                      child: Text(
                        'TONER Y CARTUCHOS',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // CONTENEDOR DVD-CD Y RADIOGRAFÍAS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
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
                ),

                // CONTENEDOR PILAS Y BATERÍAS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/contenedores/contenedor-de-basura.png',
                      width: 180,
                      height: 180,
                    ),

                    SizedBox(
                      width: 130, // margen respecto a la imagen
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
