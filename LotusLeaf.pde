/**
 * Clase LotusLeaf
 * 
 * Representa una hoja de loto flotando en la superficie del estanque.
 * Las hojas de loto son elementos decorativos que añaden realismo
 * y profundidad visual al estanque.
 */
class LotusLeaf {
  Vector2D position; // Posición central
  float size; // Tamaño de la hoja
  float rotation; // Rotación en radianes
  float shadowOffset; // Desplazamiento de sombra
  float variation; // Variación de forma (0-1)
  float wavePhase; // Fase de onda
  float waveSpeed; // Velocidad de onda
  float opacity; // Opacidad (0-1)
  
  /**
   * Constructor
   * 
   * @param x Posición x del centro
   * @param y Posición y del centro
   */
  LotusLeaf(float x, float y) {
    this.position = new Vector2D(x, y);
    // Tamaño más variable con máximo menor
    this.size = RandomUtils.randomFloat(20, 45); // Ajustado para mejor visualización
    this.rotation = RandomUtils.randomAngle();
    this.shadowOffset = RandomUtils.randomFloat(2, 5);
    this.variation = RandomUtils.randomFloat(0.8, 1.2); // Variación de forma
    this.wavePhase = RandomUtils.randomFloat(0, TWO_PI);
    this.waveSpeed = RandomUtils.randomFloat(0.001, 0.003);
    this.opacity = RandomUtils.randomFloat(0.9, 1); // Mayor opacidad para mejor visibilidad
  }
  
  /**
   * Actualiza el estado de la hoja en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   * @param time Tiempo global para animaciones
   */
  void update(float deltaTime, float time) {
    // Actualiza la fase de onda para un movimiento suave
    this.wavePhase += this.waveSpeed * deltaTime;
    
    // Mantiene la fase en el rango 0-2π
    if (this.wavePhase > TWO_PI) {
      this.wavePhase -= TWO_PI;
    }
  }
  
  /**
   * Calcula el desplazamiento actual de la onda
   * 
   * @param time Tiempo global para animaciones
   * @return Desplazamiento de onda
   */
  float getWaveOffset(float time) {
    return sin(time * 0.5 + this.wavePhase) * 0.5;
  }
}
