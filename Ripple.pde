/**
 * Clase Ripple
 * 
 * Representa una ondulación en la superficie del agua.
 * Las ondulaciones son creadas por interacciones como clics,
 * pétalos que caen o peces moviéndose cerca de la superficie.
 */
class Ripple {
  Vector2D position; // Posición central
  float radius; // Radio actual
  float maxRadius; // Radio máximo antes de desaparecer
  float opacity; // Opacidad (0-1)
  float growthSpeed; // Velocidad de crecimiento
  
  /**
   * Constructor
   * 
   * @param x Posición x del centro
   * @param y Posición y del centro
   * @param initialOpacity Opacidad inicial (0-1)
   * @param maxRadius Radio máximo antes de desaparecer
   */
  Ripple(float x, float y, float initialOpacity, float maxRadius) {
    this.position = new Vector2D(x, y);
    this.radius = 1;
    this.maxRadius = maxRadius;
    this.opacity = initialOpacity;
    this.growthSpeed = RandomUtils.randomFloat(0.3, 0.5);
  }
  
  /**
   * Actualiza el estado de la ondulación en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    // Hace crecer la ondulación
    this.radius += this.growthSpeed * (deltaTime / 16);
    this.opacity -= 0.01 * (deltaTime / 16);
  }
  
  /**
   * Comprueba si la ondulación ha terminado su ciclo de vida
   * 
   * @return true si la ondulación debe ser eliminada
   */
  boolean isFinished() {
    return this.opacity <= 0 || this.radius > this.maxRadius;
  }
}
