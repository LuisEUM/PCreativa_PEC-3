/**
 * Clase Petal
 * 
 * Representa un pétalo de flor de cerezo flotando en el estanque.
 * Gestiona su ciclo de vida completo desde la aparición hasta el hundimiento,
 * incluyendo animaciones y movimientos.
 */
class Petal {
  Vector2D position; // Posición actual
  float finalSize; // Tamaño final del pétalo
  float size; // Tamaño actual
  float speed; // Velocidad de movimiento
  float angle; // Ángulo de movimiento
  float rotation; // Rotación del pétalo
  float rotationSpeed; // Velocidad de rotación
  String state; // Estado actual: "appearing", "active", "sinking"
  float opacity; // Opacidad (0-1)
  float animationProgress; // Progreso actual de la animación (0-1)
  float scaleFactor; // Factor de escala para animación
  boolean rippleCreated; // Indica si se ha creado una onda
  float lifetime; // Tiempo de vida restante
  
  /**
   * Constructor
   * 
   * @param x Posición x inicial
   * @param y Posición y inicial
   */
  Petal(float x, float y) {
    this.position = new Vector2D(x, y);
    // Tamaño final más pequeño
    this.finalSize = RandomUtils.randomFloat(0.8, 2.5);
    this.size = this.finalSize;
    this.speed = RandomUtils.randomFloat(0.01, 0.03);
    this.angle = RandomUtils.randomAngle();
    this.rotation = RandomUtils.randomAngle();
    this.rotationSpeed = (RandomUtils.randomFloat(0, 1) - 0.5) * 0.003;
    this.state = "appearing";
    this.opacity = 1;
    this.animationProgress = 0;
    // Factor de escala inicial más pequeño
    this.scaleFactor = RandomUtils.randomFloat(1.3, 1.6);
    this.rippleCreated = false;
    this.lifetime = RandomUtils.randomFloat(600, 1800);
  }
  
  /**
   * Actualiza el estado del pétalo en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    if (this.state.equals("appearing")) {
      // Animación de aparición más lenta
      this.animationProgress += 0.008 * (deltaTime / 16);
      
      // Cuando la animación se completa, transición al estado activo
      if (this.animationProgress >= 1) {
        this.state = "active";
        this.animationProgress = 1;
      }
    } 
    else if (this.state.equals("active")) {
      // Movimiento muy ligero
      this.position.x += cos(this.angle) * this.speed * (deltaTime / 16);
      this.position.y += sin(this.angle) * this.speed * (deltaTime / 16);
      this.rotation += this.rotationSpeed * (deltaTime / 16);
      
      // Disminuye el tiempo de vida
      this.lifetime -= deltaTime;
      
      // Comprueba si el pétalo debe comenzar a hundirse
      if (this.lifetime <= 0) {
        this.state = "sinking";
        this.animationProgress = 1;
      }
    } 
    else if (this.state.equals("sinking")) {
      // Animación de hundimiento más lenta
      this.animationProgress -= 0.006 * (deltaTime / 16);
      this.opacity = this.animationProgress;
      
      // Aumenta la rotación mientras se hunde, pero más lentamente
      this.rotation += this.rotationSpeed * 1.2 * (deltaTime / 16);
    }
  }
  
  /**
   * Comprueba si el pétalo debe reiniciarse
   * 
   * @return true si el pétalo ha completado su ciclo de vida
   */
  boolean shouldReset() {
    return this.state.equals("sinking") && this.animationProgress <= 0;
  }
  
  /**
   * Calcula el tamaño actual basado en el estado
   * 
   * @return Tamaño actual del pétalo
   */
  float getCurrentSize() {
    if (this.state.equals("appearing")) {
      // Durante la aparición, el tamaño va de grande a normal
      return this.finalSize * (this.scaleFactor - (this.scaleFactor - 1) * this.animationProgress);
    } 
    else if (this.state.equals("sinking")) {
      // Durante el hundimiento, el tamaño disminuye gradualmente
      return this.finalSize * (1 - (1 - this.animationProgress) * 0.3);
    } 
    else {
      // Tamaño normal durante el estado activo
      return this.finalSize;
    }
  }
}

