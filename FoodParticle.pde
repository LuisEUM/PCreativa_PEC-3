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
  float maxLifetime; // Tiempo de vida máximo (para calcular porcentaje)
  boolean consumed; // Si ya fue consumida por un pez
  boolean canBeEaten; // Si puede ser comida en este momento
  float stabilityTime; // Tiempo que debe permanecer estable antes de poder ser comida
  
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
    this.lifetime = RandomUtils.randomFloat(300, 500); // Tiempo de vida más largo
    this.maxLifetime = this.lifetime;
    this.consumed = false;
    this.canBeEaten = false;
    this.stabilityTime = 60; // 1 segundo antes de poder ser comida
  }
  
  /**
   * Actualiza el estado de la partícula en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    // Solo se hunde si no ha sido consumida
    if (!consumed) {
      // Se hunde lentamente
      this.position.y += this.sinkSpeed * (deltaTime / 16);
      
      // Disminuye el tiempo de vida
      this.lifetime -= deltaTime;
      
      // Controlar el tiempo de estabilidad
      if (stabilityTime > 0) {
        stabilityTime -= deltaTime;
      } else {
        canBeEaten = true;
      }
      
      // Se desvanece más tarde en su vida
      if (this.lifetime < 100) {
        this.opacity = this.lifetime / 100;
      }
    } else {
      // Si fue consumida, desvanece rápidamente
      this.opacity -= deltaTime / 200; // Desvanece en ~0.2 segundos
      if (this.opacity < 0) this.opacity = 0;
    }
  }
  
  /**
   * Comprueba si la partícula ha terminado su ciclo de vida
   * 
   * @return true si la partícula debe ser eliminada
   */
  boolean isFinished() {
    return this.lifetime <= 0 || (consumed && opacity <= 0);
  }
  
  /**
   * Marca la comida como consumida
   */
  void consume() {
    this.consumed = true;
  }
  
  /**
   * Verifica si la comida puede ser comida
   */
  boolean canBeConsumed() {
    return canBeEaten && !consumed;
  }
  
  /**
   * Obtiene el porcentaje de vida restante
   */
  float getLifePercentage() {
    return lifetime / maxLifetime;
  }
}

