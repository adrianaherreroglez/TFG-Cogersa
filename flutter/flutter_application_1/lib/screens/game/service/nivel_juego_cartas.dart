class NivelJuegoCartas {
  int sumarPuntosRespuestaCorrecta() {
    return 30;
  }

  // Bonus por completar el juego con pocos intentos.
  int calcularBonusIntentos(int intentos) {
    if (intentos <= 15) return 100;
    if (intentos <= 25) return 60;
    if (intentos <= 35) return 30;
    return 0;
  }


  int sumarPuntosFinalizacion() {
    return 50;
  }

  int calcularPuntuacionFinal(int puntos, int intentos) {
    return puntos +
        calcularBonusIntentos(intentos) +
        sumarPuntosFinalizacion();
  }
}