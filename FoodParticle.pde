/**
 * Clase FoodParticle
 * 
 * Representa una partícula de comida para los peces en el estanque.
 * Las partículas se crean cuando el usuario hace clic y atraen
 * a los peces koi hacia ellas.
 */
class FoodParticle {
  Vector2D position; // Posición base
  float size; // Tamaño de la partícula
  color particleColor; // Color de la partícula
  float opacity; // Opacidad (0-1)
  float sinkSpeed; // Velocidad de hundimiento
  Vector2D offset; // Desplazamiento aleatorio
  float lifetime; // Tiempo de vida restante
  
  /**
   * Constructor
   * 
   * @param x Posición inicial x
   * @param y Posición inicial y
   */
  FoodParticle(float x, float y) {
    this.position = new Vector2D(x, y);
    this.size = RandomUtils.randomFloat(1, 3);
    this.particleColor = color(
      RandomUtils.randomInt(230, 255),  // R (amarillo-naranja)
      RandomUtils.randomInt(150, 200),  // G
      RandomUtils.randomInt(0, 60),     // B
      255  // Alpha
    );
    this.opacity = 1;
    this.sinkSpeed = RandomUtils.randomFloat(0.1, 0.3);
    this.offset = new Vector2D(
      (RandomUtils.randomFloat(0, 1) - 0.5) * 20,
      (RandomUtils.randomFloat(0, 1) - 0.5) * 20
    );
    this.lifetime = RandomUtils.randomFloat(100, 300);
  }
  
  /**
   * Actualiza el estado de la partícula en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    // Se hunde lentamente
    this.position.y += this.sinkSpeed * (deltaTime / 16);
    
    // Disminuye el tiempo de vida
    this.lifetime -= deltaTime;
    
    // Se desvanece a medida que disminuye el tiempo de vida
    if (this.lifetime < 50) {
      this.opacity = this.lifetime / 50;
    }
  }
  
  /**
   * Comprueba si la partícula ha terminado su ciclo de vida
   * 
   * @return true si la partícula debe ser eliminada
   */
  boolean isFinished() {
    return this.lifetime <= 0;
  }
}

