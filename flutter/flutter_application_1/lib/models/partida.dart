class Partida {
  final int? id;
  final int userId;
  final String juego;
  final int puntos;
  final int tiempoSegundos;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  Partida({
    this.id,
    required this.userId,
    required this.juego,
    this.puntos = 0,
    this.tiempoSegundos = 0,
    this.fechaInicio,
    this.fechaFin,
  });

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      juego: json['juego'] as String,
      puntos: json['puntos'] as int,
      tiempoSegundos: json['tiempo_segundos'] as int,
      fechaInicio: json['fecha_inicio'] == null
          ? null
          : DateTime.parse(json['fecha_inicio']),
      fechaFin: json['fecha_fin'] == null
          ? null
          : DateTime.parse(json['fecha_fin']),
    );
  }
}

