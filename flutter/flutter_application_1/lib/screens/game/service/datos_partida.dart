class DatosPartida {
  int puntos = 0;
  Stopwatch cronometro = Stopwatch();

  DatosPartida();

  int getPuntos(){
    return puntos;
  }

  Stopwatch getCronometro(){
    return cronometro;
  }

  void setPuntos(int puntos){
    this.puntos = puntos;
  }

  
}