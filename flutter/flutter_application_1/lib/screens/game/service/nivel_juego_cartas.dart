class NivelJuegoCartas {
  int sumarPuntosRespuestaCorrecta() {
    return 30;
  }

  int calcularBonusIntentos(int intentos) {
    if (intentos <= 12) return 100;
    if (intentos <= 16) return 60;
    if (intentos <= 20) return 30;
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