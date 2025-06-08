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
  Vector2D targetFood; // Posición de la comida objetivo
  float targetTime; // Tiempo restante en el objetivo actual
  boolean seekingFood; // Si está persiguiendo comida
  int competitionPriority; // Prioridad en la competencia por comida
  String koiColor; // Color principal del pez
  ArrayList<Spot> spots; // Manchas del pez
  float shadowOffset; // Desplazamiento de sombra para efecto 3D
  boolean excited; // Estado de excitación (durante alimentación)
  float excitedTime; // Tiempo restante en estado de excitación
  
  // Sistema de crecimiento
  int growthLevel; // Nivel actual (0-4, corresponde a XS, S, M, L, XL)
  boolean isGrowing; // Si está en animación de crecimiento
  float growthTimer; // Tiempo de la animación de crecimiento
  float growthDuration; // Duración de la animación de crecimiento
  float originalLength; // Tamaño original antes del crecimiento
  float targetLength; // Tamaño objetivo después del crecimiento
  boolean justAte; // Si acaba de comer (para animación especial)
  float ateAnimationTimer; // Timer para animación de "acaba de comer"
  
  // Variables para el estado de hundimiento
  boolean sinking; // Si el pez está hundiéndose
  float sinkingTime; // Tiempo total de la animación de hundimiento
  float sinkingProgress; // Progreso de la animación (0-1)
  float opacity; // Opacidad del pez
  
  // Sistema de invulnerabilidad
  boolean isInvulnerable;
  float invulnerabilityTimer;
  float invulnerabilityDuration;
  float blinkTimer;
  float blinkInterval;
  boolean isVisible;
  
  Vector2D velocity;
  Vector2D acceleration;
  
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
    this.targetFood = null;
    this.targetTime = 0;
    this.seekingFood = false;
    this.competitionPriority = 0;
    this.koiColor = koiColor;
    this.spots = new ArrayList<Spot>();
    this.shadowOffset = RandomUtils.randomFloat(3, 8);
    this.excited = false;
    this.excitedTime = 0;
    
    // Inicializar sistema de crecimiento
    this.growthLevel = getLevelFromSize(length);
    this.isGrowing = false;
    this.growthTimer = 0;
    this.growthDuration = 1000; // 1 segundo de animación
    this.originalLength = length;
    this.targetLength = length;
    this.justAte = false;
    this.ateAnimationTimer = 0;
    
    // Inicialización de las variables de hundimiento
    this.sinking = false;
    this.sinkingTime = 360; // Aproximadamente 6 segundos a 60 FPS (más lento que antes)
    this.sinkingProgress = 0;
    this.opacity = 1.0;
    
    // Inicializar sistema de invulnerabilidad
    this.isInvulnerable = false;
    this.invulnerabilityTimer = 0;
    this.invulnerabilityDuration = 180; // 3 segundos (60 frames * 3)
    this.blinkTimer = 0;
    this.blinkInterval = 8; // Parpadeo cada 8 frames
    this.isVisible = true;
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
   * Verifica si el pez ha terminado de hundirse
   * 
   * @return true si el pez debe ser eliminado
   */
  boolean isFinished() {
    // Si el pez está hundiéndose y ha completado la animación
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
    
    // Si está buscando comida, actualiza el objetivo
    if (this.seekingFood && this.targetFood != null) {
      setTarget(this.targetFood.x, this.targetFood.y, 60);
      
      // Si llega cerca de la comida, deja de buscarla
      if (getDistanceToFood(this.targetFood) < 5) {
        this.seekingFood = false;
        this.targetFood = null;
        this.competitionPriority = 0;
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
    
    // Actualizar invulnerabilidad
    if (isInvulnerable) {
      invulnerabilityTimer += deltaTime;
      blinkTimer += deltaTime;
      
      // Efecto de parpadeo
      if (blinkTimer >= blinkInterval) {
        isVisible = !isVisible;
        blinkTimer = 0;
      }
      
      // Terminar invulnerabilidad
      if (invulnerabilityTimer >= invulnerabilityDuration) {
        isInvulnerable = false;
        isVisible = true;
      }
    }
    
    // Actualizar animaciones de crecimiento y comer
    updateGrowthAnimations(deltaTime);
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
   * Función de suavizado para el cambio de tamaño durante el hundimiento
   * 
   * @param x Valor entre 0 y 1
   * @return Valor suavizado entre 0 y 1
   */
  float easeInOutQuad(float x) {
    return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
  }
  
  /**
   * Obtiene la distancia a una comida específica (Vector2D)
   */
  float getDistanceToFood(Vector2D foodPosition) {
    return Vector2D.distance(position, foodPosition);
  }
  
  /**
   * Obtiene la distancia a una comida específica (PVector) - Compatibilidad Processing
   */
  float getDistanceToFood(PVector foodPosition) {
    return PVector.dist(new PVector(position.x, position.y), foodPosition);
  }
  
  /**
   * Establece una comida como objetivo (Vector2D)
   */
  void setFoodTarget(Vector2D foodPosition, int priority) {
    this.targetFood = foodPosition.clone();
    this.seekingFood = true;
    this.competitionPriority = priority;
    
    // Dirigirse inmediatamente hacia la comida
    setTarget(foodPosition.x, foodPosition.y, 60);
    setExcited(60);
  }
  
  /**
   * Establece una comida como objetivo (PVector) - Compatibilidad Processing
   */
  void setFoodTarget(PVector foodPosition, int priority) {
    this.targetFood = new Vector2D(foodPosition.x, foodPosition.y);
    this.seekingFood = true;
    this.competitionPriority = priority;
    
    // Dirigirse inmediatamente hacia la comida
    setTarget(foodPosition.x, foodPosition.y, 60);
    setExcited(60);
  }
  
  /**
   * Activa el período de invulnerabilidad
   */
  void makeInvulnerable() {
    isInvulnerable = true;
    invulnerabilityTimer = 0;
    blinkTimer = 0;
    isVisible = true;
  }
  
  /**
   * Recibe daño y retorna true si el koi muere
   */
  boolean takeDamage(int damage) {
    if (isInvulnerable) return false;
    
    // Activar invulnerabilidad
    makeInvulnerable();
    
    // Reducir tamaño si el daño no mata al koi
    if (length > 10 && damage < getHealthPoints()) {
      length = getPreviousSize();
      width = length * 0.4; // Mantener la proporción
      return false;
    }
    
    // El koi muere
    return true;
  }
  
  /**
   * Obtiene los puntos de vida basados en el tamaño
   */
  int getHealthPoints() {
    if (length >= 35) return 5;      // XL
    if (length >= 28) return 4;      // L
    if (length >= 20) return 3;      // M
    if (length >= 15) return 2;      // S
    return 1;                      // XS
  }
  
  /**
   * Obtiene el tamaño del nivel anterior
   */
  float getPreviousSize() {
    if (length >= 35) return 28;     // XL -> L
    if (length >= 28) return 20;     // L -> M
    if (length >= 20) return 15;     // M -> S
    return 10;                     // S -> XS
  }
  
  /**
   * Convierte un tamaño a nivel de crecimiento
   */
  int getLevelFromSize(float size) {
    if (size >= 35) return 4;      // XL
    if (size >= 28) return 3;      // L
    if (size >= 20) return 2;      // M
    if (size >= 15) return 1;      // S
    return 0;                    // XS
  }
  
  /**
   * Obtiene el tamaño del siguiente nivel
   */
  float getNextSize() {
    if (length < 15) return 15;     // XS -> S
    if (length < 20) return 20;     // S -> M
    if (length < 28) return 28;     // M -> L
    if (length < 35) return 35;     // L -> XL
    return 35;                     // Ya es XL (máximo)
  }
  
  /**
   * Método para hacer que el pez crezca al siguiente nivel
   */
  void eatFood() {
    // Solo puede crecer si no está ya creciendo y no está al máximo nivel
    if (!isGrowing && growthLevel < 4) {
      // Activar animación de "acaba de comer"
      justAte = true;
      ateAnimationTimer = 0;
      
      // Activar excitación por haber comido
      setExcited(120); // 2 segundos de excitación
      
      // Preparar para el crecimiento
      originalLength = length;
      targetLength = getNextSize();
      growthLevel++;
      
      // Iniciar animación de crecimiento después de un breve delay
      // Para que se vea primero la animación de "comer"
      isGrowing = true;
      growthTimer = 0;
    } else if (!isGrowing) {
      // Si ya está al máximo nivel, solo mostrar animación de comer
      justAte = true;
      ateAnimationTimer = 0;
      setExcited(60); // 1 segundo de excitación
    }
  }
  
  /**
   * Actualiza las animaciones de crecimiento y comer
   */
  void updateGrowthAnimations(float deltaTime) {
    // Actualizar animación de "acaba de comer"
    if (justAte) {
      ateAnimationTimer += deltaTime;
      if (ateAnimationTimer >= 500) { // 0.5 segundos
        justAte = false;
        ateAnimationTimer = 0;
      }
    }
    
    // Actualizar animación de crecimiento
    if (isGrowing) {
      growthTimer += deltaTime;
      
      if (growthTimer >= growthDuration) {
        // Finalizar crecimiento
        isGrowing = false;
        length = targetLength;
        width = length * 0.4;
        growthTimer = 0;
      } else {
        // Interpolación suave del tamaño
        float progress = growthTimer / growthDuration;
        // Usar función de easing para una animación más natural
        float easedProgress = easeInOutBack(progress);
        length = lerp(originalLength, targetLength, easedProgress);
        width = length * 0.4;
      }
    }
  }
  
  /**
   * Función de easing con efecto de rebote para el crecimiento
   */
  float easeInOutBack(float x) {
    float c1 = 1.70158;
    float c2 = c1 * 1.525;
    
    return x < 0.5
      ? (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
      : (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;
  }
  
  /**
   * Obtiene el tamaño actual considerando animaciones
   */
  float getCurrentAnimatedLength() {
    float currentLength = getCurrentLength(); // Ya considera hundimiento
    
    // Aplicar efecto de "acaba de comer" (ligero aumento de tamaño)
    if (justAte) {
      float eatProgress = ateAnimationTimer / 500.0;
      float eatScale = 1.0 + (sin(eatProgress * PI * 4) * 0.1 * (1 - eatProgress));
      currentLength *= eatScale;
    }
    
    return currentLength;
  }
  
  /**
   * Obtiene el ancho actual considerando animaciones
   */
  float getCurrentAnimatedWidth() {
    float currentWidth = getCurrentWidth(); // Ya considera hundimiento
    
    // Aplicar efecto de "acaba de comer"
    if (justAte) {
      float eatProgress = ateAnimationTimer / 500.0;
      float eatScale = 1.0 + (sin(eatProgress * PI * 4) * 0.1 * (1 - eatProgress));
      currentWidth *= eatScale;
    }
    
    return currentWidth;
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

