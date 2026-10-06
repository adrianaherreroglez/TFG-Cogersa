
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart';

class SalasPage extends StatefulWidget {
  const SalasPage({super.key});

  @override
  State<SalasPage> createState() => _SalasPageState();
}

class _SalasPageState extends State<SalasPage> {

  // DATOS DE EJEMPLO
  final List<Map<String, dynamic>> salas = [
    {
      'nombre': 'Sala Verde',
      'usuario': 'Carlos',
      'jugadores': 2,
      'maxJugadores': 4,
    },
    {
      'nombre': 'Recicladores',
      'usuario': 'Lucía',
      'jugadores': 3,
      'maxJugadores': 4,
    },
    {
      'nombre': 'Eco Warriors',
      'usuario': 'Mario',
      'jugadores': 1,
      'maxJugadores': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: Column(
        children: [
          // BARRA DE NAVEGACIÓN
          const NavBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 35,
              ),
              child: Column(
                children: [

                  // TÍTULO
                  Text(
                    'Salas',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF298133),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Crea una sala o únete a una partida',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF644633),
                    ),
                  ),

                  const SizedBox(height: 35),


                  // LISTA DE SALAS
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 1100,
                    ),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFD8EDD5),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // CABECERA
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8EDD5),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.meeting_room_rounded,
                                size: 34,
                                color: Color(0xFF298133),
                              ),
                            ),

                            const SizedBox(width: 18),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salas disponibles',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF298133),
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  'Elige una sala para comenzar a jugar',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF644633),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // LISTA
                        if (salas.isEmpty)
                          _buildEmptyState()
                        else
                          Column(
                            children: [
                              for (int i = 0; i < salas.length; i++) ...[
                                _buildSalaCard(salas[i]),

                                if (i != salas.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

  
                  // BOTÓN AÑADIR
                  SizedBox(
                    width: 220,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/crearSala');
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 28,
                      ),
                      label: Text(
                        'Añadir',
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF298133),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // TARJETA DE SALA
  Widget _buildSalaCard(Map<String, dynamic> sala) {
    final int jugadores = sala['jugadores'];
    final int maxJugadores = sala['maxJugadores'];

    final bool salaLlena = jugadores >= maxJugadores;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAEF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD8EDD5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // ICONO DE SALA
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EDD5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.meeting_room_rounded,
              size: 30,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(width: 16),

          // INFORMACIÓN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sala['nombre'],
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF298133),
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.person_rounded,
                      size: 17,
                      color: Color(0xFF644633),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      'Creada por ${sala['usuario']}',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF644633),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // JUGADORES
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    size: 20,
                    color: Color(0xFF298133),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    '$jugadores/$maxJugadores',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF298133),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: salaLlena
                      ? const Color(0xFFF3D6D6)
                      : const Color(0xFFD8EDD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  salaLlena ? 'Llena' : 'Disponible',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: salaLlena
                        ? const Color(0xFF9B3030)
                        : const Color(0xFF298133),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          // BOTÓN UNIRSE
          ElevatedButton(
            onPressed: salaLlena
                ? null
                : () {
                    // Aquí posteriormente pondremos
                    // la lógica para unirse a la sala.
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF298133),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD5D5D5),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Unirse',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

 
  // NO HAY SALAS
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(
            Icons.meeting_room_outlined,
            size: 70,
            color: Color(0xFFB5D5B1),
          ),

          const SizedBox(height: 15),

          Text(
            'No hay salas disponibles',
            style: GoogleFonts.quicksand(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '¡Crea la primera sala y empieza a jugar!',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF644633),
            ),
          ),
        ],
      ),
    );
  }
}

