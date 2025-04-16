/**
 * Clase Koi
 * 
 * Representa un pez koi en el estanque con todas sus propiedades físicas y de comportamiento.
 * Gestiona su movimiento, apariencia y estados como la excitación durante la alimentación.
 */
class Koi {
  Vector2D position; // Posición actual
  float length; // Longitud del pez
  float width; // Ancho del pez
  float angle; // Ángulo de orientación (radianes)
  float speed; // Velocidad de movimiento
  float turnSpeed; // Velocidad de giro
  float tailAmplitude; // Amplitud del movimiento de la cola
  float tailFrequency; // Frecuencia del movimiento de la cola
  Vector2D target; // Posición objetivo
  float targetTime; // Tiempo restante en el objetivo actual
  String koiColor; // Color principal del pez
  ArrayList<Spot> spots; // Manchas del pez
  float shadowOffset; // Desplazamiento de sombra para efecto 3D
  boolean excited; // Estado de excitación (durante alimentación)
  float excitedTime; // Tiempo restante en estado de excitación
  
  // Variables para el estado de hundimiento
  boolean sinking; // Si el pez está hundiéndose
  float sinkingTime; // Tiempo total de la animación de hundimiento
  float sinkingProgress; // Progreso de la animación (0-1)
  float opacity; // Opacidad del pez
  
  /**
   * Constructor
   * 
   * @param x Posición inicial x
   * @param y Posición inicial y
   * @param length Longitud del pez
   * @param koiColor Color principal del pez
   */
  Koi(float x, float y, float length, String koiColor) {
    this.position = new Vector2D(x, y);
    this.length = length;
    this.width = length * 0.4;
    this.angle = RandomUtils.randomAngle();
    this.speed = RandomUtils.randomFloat(0.2, 0.5);
    this.turnSpeed = RandomUtils.randomFloat(0.01, 0.03);
    this.tailAmplitude = RandomUtils.randomFloat(0.15, 0.25);
    this.tailFrequency = RandomUtils.randomFloat(0.05, 0.1);
    this.target = new Vector2D(x, y);
    this.targetTime = 0;
    this.koiColor = koiColor;
    this.spots = new ArrayList<Spot>();
    this.shadowOffset = RandomUtils.randomFloat(3, 8);
    this.excited = false;
    this.excitedTime = 0;
    
    // Inicialización de las variables de hundimiento
    this.sinking = false;
    this.sinkingTime = 360; // Aproximadamente 6 segundos a 60 FPS (más lento que antes)
    this.sinkingProgress = 0;
    this.opacity = 1.0;
  }
  
  /**
   * Establece un nuevo objetivo para el pez
   * 
   * @param x Coordenada x del objetivo
   * @param y Coordenada y del objetivo
   * @param time Tiempo para permanecer en este objetivo
   */
  void setTarget(float x, float y, float time) {
    this.target = new Vector2D(x, y);
    this.targetTime = time;
  }
  
  /**
   * Activa el estado de excitación del pez
   * 
   * @param duration Duración del estado de excitación en fotogramas
   */
  void setExcited(float duration) {
    this.excited = true;
    this.excitedTime = duration;
    this.speed = RandomUtils.randomFloat(0.5, 1.0); // Velocidad aumentada cuando está excitado
  }
  
  /**
   * Activa el estado de hundimiento del pez
   */
  void setSinking() {
    this.sinking = true;
    this.sinkingProgress = 0;
    this.opacity = 1.0;
    
    // Detenemos al pez inmediatamente cuando comienza a hundirse
    this.speed = 0;
  }
  
  /**
   * Verifica si el pez ha terminado de hundirse y debe ser eliminado
   * 
   * @return true si el pez debe ser eliminado
   */
  boolean isFinished() {
    return this.sinking && this.sinkingProgress >= 1.0;
  }
  
  /**
   * Actualiza el estado del pez en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   * @param canvasWidth Ancho del lienzo
   * @param canvasHeight Alto del lienzo
   */
  void update(float deltaTime, float canvasWidth, float canvasHeight) {
    // Si el pez está hundiéndose, actualiza la animación
    if (this.sinking) {
      // Incrementa el progreso de hundimiento de forma más suave
      float increment = deltaTime / this.sinkingTime;
      
      // Hace que el hundimiento sea más lento al principio y al final
      if (this.sinkingProgress < 0.2) {
        // Más lento al principio
        increment *= 0.7;
      } else if (this.sinkingProgress > 0.8) {
        // Más lento al final
        increment *= 0.5;
      }
      
      this.sinkingProgress += increment;
      this.sinkingProgress = min(this.sinkingProgress, 1.0);
      
      // Actualiza la opacidad con una curva no lineal para un efecto más dramático
      // Mantiene la opacidad alta por más tiempo y luego desvanece más rápido al final
      if (this.sinkingProgress < 0.6) {
        this.opacity = 1.0 - (this.sinkingProgress / 1.5); // Disminución más lenta al principio
      } else {
        this.opacity = 0.6 - (this.sinkingProgress - 0.6) * 1.5; // Disminución más rápida al final
      }
      this.opacity = max(0, this.opacity);
      
      // No necesitamos actualizar nada más si el pez se está hundiendo
      return;
    }
    
    // Actualiza el tiempo del objetivo
    this.targetTime--;
    
    // Actualiza el estado de excitación
    if (this.excited) {
      this.excitedTime -= deltaTime / 16;
      if (this.excitedTime <= 0) {
        this.excited = false;
        this.speed = RandomUtils.randomFloat(0.2, 0.5); // Volver a la velocidad normal
      }
    }
    
    // Calcula el ángulo hacia el objetivo
    float targetAngle = Vector2D.angle(this.position, this.target);
    
    // Gira gradualmente hacia el objetivo
    float angleDiff = targetAngle - this.angle;
    
    // Normaliza la diferencia de ángulo para que esté entre -PI y PI
    while (angleDiff > PI) angleDiff -= TWO_PI;
    while (angleDiff < -PI) angleDiff += TWO_PI;
    
    // Gira más rápido cuando está excitado
    float currentTurnSpeed = this.excited ? this.turnSpeed * 1.5 : this.turnSpeed;
    this.angle += angleDiff * currentTurnSpeed;
    
    // Se mueve en la dirección actual
    this.position.x += cos(this.angle) * this.speed * (deltaTime / 16);
    this.position.y += sin(this.angle) * this.speed * (deltaTime / 16);
    
    // Se mantiene dentro del lienzo
    if (this.position.x < 0) this.position.x = 0;
    if (this.position.x > canvasWidth) this.position.x = canvasWidth;
    if (this.position.y < 0) this.position.y = 0;
    if (this.position.y > canvasHeight) this.position.y = canvasHeight;
  }
  
  /**
   * Obtiene el tamaño actual del pez, teniendo en cuenta la animación de hundimiento
   *
   * @return Tamaño actual del pez
   */
  float getCurrentLength() {
    if (this.sinking) {
      // Aplicamos una función de suavizado para el cambio de tamaño
      float scaleFactor = 1.0 - easeInOutQuad(this.sinkingProgress) * 0.8;
      return this.length * scaleFactor;
    }
    return this.length;
  }
  
  /**
   * Obtiene el ancho actual del pez, teniendo en cuenta la animación de hundimiento
   *
   * @return Ancho actual del pez
   */
  float getCurrentWidth() {
    if (this.sinking) {
      // Aplicamos una función de suavizado para el cambio de tamaño
      float scaleFactor = 1.0 - easeInOutQuad(this.sinkingProgress) * 0.8;
      return this.width * scaleFactor;
    }
    return this.width;
  }
  
  /**
   * Función de suavizado para las animaciones (ease-in-out quad)
   * Hace que la animación sea más suave al principio y al final
   *
   * @param t Valor de progreso entre 0 y 1
   * @return Valor suavizado entre 0 y 1
   */
  private float easeInOutQuad(float t) {
    return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
  }
}

/**
 * Clase Spot
 * 
 * Define la estructura de las manchas en los peces koi.
 * Cada mancha tiene una posición relativa, tamaño y color.
 */
class Spot {
  float x; // Posición relativa x (0-1)
  float y; // Posición relativa y (0-1)
  float size; // Tamaño relativo (0-1)
  String spotColor; // Color CSS
  
  /**
   * Constructor
   * 
   * @param x Posición relativa x
   * @param y Posición relativa y
   * @param size Tamaño relativo
   * @param spotColor Color de la mancha
   */
  Spot(float x, float y, float size, String spotColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.spotColor = spotColor;
  }
}

