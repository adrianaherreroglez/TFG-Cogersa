import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart';

class CrearSalaPage extends StatefulWidget {
  const CrearSalaPage({super.key});

  @override
  State<CrearSalaPage> createState() => _CrearSalaPageState();
}

class _CrearSalaPageState extends State<CrearSalaPage> {
  final TextEditingController nombreController =
      TextEditingController();

  int maxJugadores = 4;

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  void _crearSala() {
    final String nombre = nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Introduce un nombre para la sala',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF298133),
        ),
      );

      return;
    }

    // --------------------------------------------------------------
    // De momento solo se muestra un mensaje
    //
    // Más adelante aquí conectaremos con:
    //
    // Flutter → Node.js → PostgreSQL
    //
    // para guardar la sala en la base de datos.
    // --------------------------------------------------------------

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sala "$nombre" creada correctamente',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF298133),
      ),
    );
  }

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
                horizontal: 30,
                vertical: 35,
              ),
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 750,
                  ),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
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

                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8EDD5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.meeting_room_rounded,
                          size: 50,
                          color: Color(0xFF298133),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Crear una sala',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF298133),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Crea una partida e invita a otros jugadores',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF644633),
                        ),
                      ),

                      const SizedBox(height: 35),


                      // NOMBRE DE LA SALA
                      _buildLabel(
                        'Nombre de la sala',
                        Icons.edit_rounded,
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: nombreController,
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF644633),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. Los Eco Warriors',
                          hintStyle: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: const Color(0xFF9B9B9B),
                          ),
                          prefixIcon: const Icon(
                            Icons.meeting_room_outlined,
                            color: Color(0xFF298133),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3FAEF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF298133),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // MÁXIMO DE JUGADORES
                      _buildLabel(
                        'Máximo de jugadores',
                        Icons.groups_rounded,
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3FAEF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD8EDD5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: maxJugadores,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF298133),
                            ),
                            style: GoogleFonts.quicksand(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF644633),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 2,
                                child: Text('2 jugadores'),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('3 jugadores'),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text('4 jugadores'),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text('5 jugadores'),
                              ),
                              DropdownMenuItem(
                                value: 6,
                                child: Text('6 jugadores'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  maxJugadores = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // INFORMACIÓN DEL CREADOR
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3FAEF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8EDD5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Color(0xFF298133),
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Creador de la sala',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF644633),
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  'Usuario actual',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF298133),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),


                      // BOTÓN CREAR
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: _crearSala,
                          icon: const Icon(
                            Icons.add_rounded,
                            size: 28,
                          ),
                          label: Text(
                            'Crear sala',
                            style: GoogleFonts.quicksand(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF298133),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

  
                      // BOTÓN VOLVER
                      TextButton.icon(
                        onPressed: () {
                          context.go('/salas');
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF644633),
                        ),
                        label: Text(
                          'Volver a las salas',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF644633),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLabel(
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF298133),
        ),

        const SizedBox(width: 7),

        Text(
          text,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF644633),
          ),
        ),
      ],
    );
  }
}
