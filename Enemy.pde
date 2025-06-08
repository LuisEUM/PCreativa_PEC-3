/**
 * Clase Enemy
 * 
 * Representa un enemigo/depredador en el juego.
 * Los enemigos persiguen y atacan a los koi, pero también pueden ser distraídos.
 */

// Estados de comportamiento del enemigo
enum EnemyState {
  WANDERING,    // Explorando - puede ser distraído por comida y asustado por rocas
  HUNTING,      // Persiguiendo koi - más rojizo, no se distrae
  EXPLORING,    // Exploración natural sin objetivo específico
  FLEEING,      // Huyendo de rocas/amenazas
  FEEDING       // Dirigiéndose hacia comida específica
}

class Enemy {
  Vector2D position;
  Vector2D target;
  EnemyType type;
  float size;
  float speed;
  float angle;
  int damage;
  int health;
  int maxHealth;
  color baseEnemyColor;
  
  // Estados de comportamiento
  boolean isActive;
  float huntingRadius;
  float foodAttractionRadius;
  Koi targetKoi;
  Vector2D targetFood;
  EnemyState currentState;
  
  // Sistema de colisión con rocas
  ArrayList<Rock> rocks;
  Vector2D lastValidPosition;
  
  // Sistema de animación de daño
  boolean isHit;
  float hitTimer;
  float hitDuration;
  float hitFlashIntensity;
  
  // Sistema visual de vida
  boolean showHealthIndicator;
  float healthIndicatorTimer;
  
  // Comportamiento inicial temporal (evitar bordes)
  boolean initialMovement;
  float initialMovementTimer;
  float initialMovementDuration; // Duración del comportamiento inicial
  Vector2D initialDirection; // Dirección para alejarse del borde
  
  // Sistema de exploración mejorado
  Vector2D explorationTarget; // Objetivo de exploración natural
  float explorationTimer; // Tiempo en el objetivo actual
  float explorationDuration; // Duración antes de cambiar objetivo
  
  // Sistema de huida de rocas
  Vector2D lastThreatPosition; // Última posición de amenaza (roca)
  float fleeTimer; // Tiempo huyendo
  float fleeDuration; // Duración de huida
  
  // Navegación inteligente
  float changeDirectionChance; // Probabilidad de cambiar dirección
  float naturalSpeed; // Velocidad base sin modificadores
  
  /**
   * Constructor
   */
  Enemy(float x, float y, EnemyType type) {
    this.position = new Vector2D(x, y);
    this.target = new Vector2D(x, y);
    this.lastValidPosition = new Vector2D(x, y);
    this.type = type;
    this.isActive = true;
    this.targetKoi = null;
    this.targetFood = null;
    this.currentState = EnemyState.WANDERING;
    this.angle = RandomUtils.randomAngle();
    
    // Sistema de daño
    this.isHit = false;
    this.hitTimer = 0;
    this.hitDuration = 500; // 500ms de animación de golpe
    this.hitFlashIntensity = 0;
    
    // Sistema de indicador de vida
    this.showHealthIndicator = false;
    this.healthIndicatorTimer = 0;
    
    // Movimiento inicial temporal para alejarse del borde de spawn
    this.initialMovement = true;
    this.initialMovementTimer = 0;
    this.initialMovementDuration = 3000; // 3 segundos
    this.initialDirection = calculateInitialDirection(x, y);
    
    // Inicializar sistema de exploración mejorado
    this.explorationTarget = new Vector2D(x, y);
    this.explorationTimer = 0;
    this.explorationDuration = RandomUtils.randomFloat(2000, 5000); // 2-5 segundos
    
    // Inicializar sistema de huida
    this.lastThreatPosition = null;
    this.fleeTimer = 0;
    this.fleeDuration = 2000; // 2 segundos huyendo
    
    // Configurar navegación natural
    this.changeDirectionChance = 0.08; // 8% por frame (más natural que 2%)
    this.naturalSpeed = this.speed; // Guardar velocidad base
    
    // Configurar propiedades según el tipo
    switch (type) {
      case SMALL_CATFISH:
        this.size = 25;
        this.speed = 0.7;
        this.damage = 1;
        this.health = 2;
        this.huntingRadius = 80;
        this.foodAttractionRadius = 120;
        this.baseEnemyColor = color(139, 69, 19); // Marrón
        break;
      case MEDIUM_CARP:
        this.size = 35;
        this.speed = 0.8;
        this.damage = 2;
        this.health = 3;
        this.huntingRadius = 100;
        this.foodAttractionRadius = 140;
        this.baseEnemyColor = color(85, 107, 47); // Verde oliva
        break;
      case LARGE_PIKE:
        this.size = 45;
        this.speed = 0.9;
        this.damage = 3;
        this.health = 4;
        this.huntingRadius = 120;
        this.foodAttractionRadius = 160;
        this.baseEnemyColor = color(47, 79, 79); // Gris pizarra
        break;
      case SHARK:
        this.size = 55;
        this.speed = 1.0;
        this.damage = 4;
        this.health = 5;
        this.huntingRadius = 150;
        this.foodAttractionRadius = 180;
        this.baseEnemyColor = color(70, 70, 70); // Gris oscuro
        break;
    }
    
    this.maxHealth = this.health;
  }
  
  /**
   * Establece las rocas para detección de colisiones
   */
  void setRocks(ArrayList<Rock> rocks) {
    this.rocks = rocks;
  }
  
  /**
   * Actualiza el comportamiento del enemigo
   */
  void update(float deltaTime, ArrayList<Koi> kois, float canvasWidth, float canvasHeight, ArrayList<FoodParticle> foodParticles) {
    if (!isActive) return;
    
    // Actualizar animaciones
    updateAnimations(deltaTime);
    
    // Actualizar comportamiento normal (incluyendo atracción/repulsión)
    updateBehavior(kois, foodParticles);
    
    // Si todavía está en movimiento inicial, añadir influencia para alejarse del borde
    if (initialMovement) {
      updateInitialMovement(deltaTime);
    }
    
    // Guardar posición actual como válida
    lastValidPosition.x = position.x;
    lastValidPosition.y = position.y;
    
    // Moverse hacia el objetivo
    moveTowardsTarget(deltaTime);
    
    // Verificar colisiones con rocas
    if (rocks != null) {
      checkRockCollisions();
    }
    
    // Mantener dentro del canvas
    position.x = constrain(position.x, 0, canvasWidth);
    position.y = constrain(position.y, 0, canvasHeight);
  }
  
  /**
   * Calcula la dirección inicial para alejarse del borde más cercano
   */
  Vector2D calculateInitialDirection(float spawnX, float spawnY) {
    float canvasWidth = 600;
    float canvasHeight = 600;
    
    // Encontrar distancias a cada borde
    float distToLeft = spawnX;
    float distToRight = canvasWidth - spawnX;
    float distToTop = spawnY;
    float distToBottom = canvasHeight - spawnY;
    
    // Encontrar el borde más cercano
    float minDist = min(min(distToLeft, distToRight), min(distToTop, distToBottom));
    
    float dirX = 0;
    float dirY = 0;
    
    // Alejarse del borde más cercano
    if (minDist == distToLeft) {
      // Muy cerca del borde izquierdo - ir hacia la derecha
      dirX = 1;
    } else if (minDist == distToRight) {
      // Muy cerca del borde derecho - ir hacia la izquierda
      dirX = -1;
    }
    
    if (minDist == distToTop) {
      // Muy cerca del borde superior - ir hacia abajo
      dirY = 1;
    } else if (minDist == distToBottom) {
      // Muy cerca del borde inferior - ir hacia arriba
      dirY = -1;
    }
    
    // Si está en una esquina, combinar direcciones
    // Añadir algo de aleatoriedad para naturalidad
    dirX += random(-0.3, 0.3);
    dirY += random(-0.3, 0.3);
    
    // Normalizar la dirección
    float magnitude = sqrt(dirX * dirX + dirY * dirY);
    if (magnitude > 0) {
      dirX /= magnitude;
      dirY /= magnitude;
    }
    
    return new Vector2D(dirX, dirY);
  }
  
  /**
   * Actualiza el movimiento inicial temporal - solo alejarse del borde
   */
  void updateInitialMovement(float deltaTime) {
    initialMovementTimer += deltaTime;
    
    // Finalizar movimiento inicial después del tiempo establecido
    if (initialMovementTimer >= initialMovementDuration) {
      initialMovement = false;
      // Configurar exploración inicial cuando termina el movimiento inicial
      resetExploration();
      return;
    }
    
    // Solo influenciar si está muy cerca de los bordes
    float margin = 80;
    boolean nearBorder = (position.x < margin || position.x > 520 || 
                         position.y < margin || position.y > 520);
    
    if (nearBorder) {
      // Calcular posición de seguridad alejándose del borde
      float safeDistance = 100;
      float targetX = position.x + (initialDirection.x * safeDistance);
      float targetY = position.y + (initialDirection.y * safeDistance);
      
      // Mantener dentro del área válida
      targetX = constrain(targetX, margin, 600 - margin);
      targetY = constrain(targetY, margin, 600 - margin);
      
      // Aplicar influencia SOLO si está cerca del borde
      float influence = 0.6; // Influencia más fuerte pero temporal
      target.x = target.x * (1 - influence) + targetX * influence;
      target.y = target.y * (1 - influence) + targetY * influence;
    }
    // Si no está cerca del borde, permitir comportamiento normal
  }
  
  /**
   * Actualiza el comportamiento principal del enemigo con prioridades claras
   */
  void updateBehavior(ArrayList<Koi> kois, ArrayList<FoodParticle> foodParticles) {
    // SISTEMA DE PRIORIDADES:
    // 1. Huir de amenazas (rocas)
    // 2. Buscar y comer comida
    // 3. Cazar koi 
    // 4. Explorar naturalmente
    
    // Actualizar timers
    updateBehaviorTimers();
    
    // Prioridad 1: ¿Está huyendo?
    if (currentState == EnemyState.FLEEING) {
      updateFleeingBehavior();
      return;
    }
    
    // Prioridad 2: ¿Hay comida cerca?
    if (findAndTargetFood(foodParticles)) {
      currentState = EnemyState.FEEDING;
      return;
    }
    
    // Prioridad 3: ¿Hay koi para cazar?
    findNearestKoi(kois);
    if (targetKoi != null) {
      currentState = EnemyState.HUNTING;
      target.x = targetKoi.position.x;
      target.y = targetKoi.position.y;
      
      // Verificar si puede atacar
      float distance = Vector2D.distance(position, targetKoi.position);
      if (distance < size/2 + targetKoi.length/2) {
        attackKoi(targetKoi);
      }
      return;
    }
    
    // Prioridad 4: Explorar naturalmente
    currentState = EnemyState.EXPLORING;
    updateExplorationBehavior();
  }
  
  /**
   * Actualiza los timers de comportamiento
   */
  void updateBehaviorTimers() {
    // Timer de exploración
    if (currentState == EnemyState.EXPLORING) {
      explorationTimer += 16; // Aproximadamente 16ms por frame
    }
    
    // Timer de huida
    if (currentState == EnemyState.FLEEING) {
      fleeTimer += 16;
      if (fleeTimer >= fleeDuration) {
        // Terminar huida
        currentState = EnemyState.EXPLORING;
        fleeTimer = 0;
        lastThreatPosition = null;
      }
    }
  }
  
  /**
   * Busca y se dirige hacia comida con alta prioridad
   */
  boolean findAndTargetFood(ArrayList<FoodParticle> foodParticles) {
    float nearestDistance = Float.MAX_VALUE;
    FoodParticle nearestFood = null;
    
    for (FoodParticle food : foodParticles) {
      if (food.isFinished()) continue;
      
      float distance = Vector2D.distance(position, food.position);
      if (distance < foodAttractionRadius && distance < nearestDistance) {
        nearestDistance = distance;
        nearestFood = food;
      }
    }
    
    if (nearestFood != null) {
      targetFood = nearestFood.position;
      target.x = targetFood.x;
      target.y = targetFood.y;
      return true;
    }
    
    targetFood = null;
    return false;
  }
  
  /**
   * Actualiza el comportamiento de huida
   */
  void updateFleeingBehavior() {
    if (lastThreatPosition != null) {
      // Continuar alejándose de la última amenaza
      float angle = Vector2D.angle(lastThreatPosition, position);
      
      // Moverse más lejos de la amenaza
      float escapeDistance = 100;
      target.x = position.x + cos(angle) * escapeDistance;
      target.y = position.y + sin(angle) * escapeDistance;
      
      // Mantener dentro del canvas
      target.x = constrain(target.x, 50, 550);
      target.y = constrain(target.y, 50, 550);
    }
  }
  
  /**
   * Actualiza el comportamiento de exploración natural
   */
  void updateExplorationBehavior() {
    // ¿Es tiempo de cambiar objetivo?
    if (explorationTimer >= explorationDuration || 
        Vector2D.distance(position, explorationTarget) < 30) {
      
      // Elegir nuevo objetivo de exploración
      setNewExplorationTarget();
      explorationTimer = 0;
      explorationDuration = RandomUtils.randomFloat(3000, 8000); // 3-8 segundos
    }
    
    // Moverse hacia el objetivo de exploración
    target.x = explorationTarget.x;
    target.y = explorationTarget.y;
  }
  
  /**
   * Establece un nuevo objetivo de exploración aleatorio pero inteligente
   */
  void setNewExplorationTarget() {
    // Evitar las esquinas y mantenerse en áreas interesantes
    float margin = 80;
    float canvasWidth = 600;
    float canvasHeight = 600;
    
    // Área central más probable, pero permitir toda el área
    float targetX, targetY;
    
    if (random(1) < 0.7) {
      // 70% probabilidad de ir al área central (más natural)
      targetX = random(margin * 2, canvasWidth - margin * 2);
      targetY = random(margin * 2, canvasHeight - margin * 2);
    } else {
      // 30% probabilidad de explorar toda el área
      targetX = random(margin, canvasWidth - margin);
      targetY = random(margin, canvasHeight - margin);
    }
    
    explorationTarget.x = targetX;
    explorationTarget.y = targetY;
  }
  
  /**
   * Atrae al enemigo hacia un punto (comida del jugador)
   */
  void attractToPoint(float x, float y, float radius) {
    // Solo si no está cazando activamente o huyendo
    if (currentState == EnemyState.HUNTING || currentState == EnemyState.FLEEING) return;
    
    float distance = Vector2D.distance(position, new Vector2D(x, y));
    if (distance < radius) {
      // Cambiar a estado FEEDING con alta prioridad
      currentState = EnemyState.FEEDING;
      target.x = x + random(-15, 15); // Pequeña variación
      target.y = y + random(-15, 15);
      targetFood = new Vector2D(x, y);
    }
  }
  
  /**
   * Repele al enemigo de un punto (rocas) con memoria
   */
  void repelFromPoint(float x, float y, float radius) {
    // Las rocas pueden interrumpir cualquier comportamiento excepto hunting intenso
    if (currentState == EnemyState.HUNTING && targetKoi != null) {
      // Solo huir si la roca está muy cerca durante caza
      float distance = Vector2D.distance(position, new Vector2D(x, y));
      if (distance > radius * 0.6) return; // Permitir cazar cerca de rocas
    }
    
    float distance = Vector2D.distance(position, new Vector2D(x, y));
    if (distance < radius) {
      // Activar estado de huida con memoria
      currentState = EnemyState.FLEEING;
      lastThreatPosition = new Vector2D(x, y);
      fleeTimer = 0;
      
      // Calcular dirección de escape inmediata
      float angle = Vector2D.angle(new Vector2D(x, y), position);
      float escapeDistance = radius + RandomUtils.randomFloat(80, 150);
      
      target.x = x + cos(angle) * escapeDistance;
      target.y = y + sin(angle) * escapeDistance;
      
      // Mantener dentro del canvas
      target.x = constrain(target.x, 50, 550);
      target.y = constrain(target.y, 50, 550);
      
      // Limpiar otros objetivos
      targetFood = null;
      targetKoi = null;
    }
  }
  
  /**
   * Actualiza las animaciones del enemigo
   */
  void updateAnimations(float deltaTime) {
    // Actualizar animación de golpe
    if (isHit) {
      hitTimer += deltaTime;
      
      // Calcular intensidad del flash (oscila)
      float progress = hitTimer / hitDuration;
      hitFlashIntensity = sin(progress * PI * 6) * (1.0 - progress) * 100;
      
      if (hitTimer >= hitDuration) {
        isHit = false;
        hitTimer = 0;
        hitFlashIntensity = 0;
      }
    }
    
    // Actualizar indicador de vida
    if (showHealthIndicator) {
      healthIndicatorTimer += deltaTime;
      
      if (healthIndicatorTimer >= 2000) { // Mostrar por 2 segundos
        showHealthIndicator = false;
        healthIndicatorTimer = 0;
      }
    }
  }
  
  /**
   * Verifica colisiones con rocas mejoradas
   */
  void checkRockCollisions() {
    for (Rock rock : rocks) {
      float distance = Vector2D.distance(position, rock.position);
      
      if (distance < (size/2 + rock.size)) {
        // Colisión detectada - regresar a la última posición válida
        position.x = lastValidPosition.x;
        position.y = lastValidPosition.y;
        
        // Activar estado de huida con memoria de la roca
        currentState = EnemyState.FLEEING;
        lastThreatPosition = rock.position.clone();
        fleeTimer = 0;
        
        // Calcular dirección de escape desde la roca
        Vector2D escapeDirection = position.subtract(rock.position);
        Vector2D normalizedDirection = escapeDirection.normalize();
        
        // Moverse lejos de la roca
        float escapeDistance = rock.size + size/2 + RandomUtils.randomFloat(80, 120);
        target.x = rock.position.x + normalizedDirection.x * escapeDistance;
        target.y = rock.position.y + normalizedDirection.y * escapeDistance;
        
        // Mantener dentro del canvas
        target.x = constrain(target.x, 50, 550);
        target.y = constrain(target.y, 50, 550);
        
        // Limpiar otros objetivos
        targetFood = null;
        if (currentState != EnemyState.HUNTING || targetKoi == null) {
          targetKoi = null; // Solo limpiar koi si no estaba cazando intensamente
        }
        
        break; // Solo manejar una colisión por frame
      }
    }
  }
  
  /**
   * Busca el koi más cercano
   */
  void findNearestKoi(ArrayList<Koi> kois) {
    float nearestDistance = Float.MAX_VALUE;
    Koi nearestKoi = null;
    
    for (Koi koi : kois) {
      if (koi.sinking || koi.isFinished()) continue;
      
      float distance = Vector2D.distance(position, koi.position);
      if (distance < huntingRadius && distance < nearestDistance) {
        nearestDistance = distance;
        nearestKoi = koi;
      }
    }
    
    targetKoi = nearestKoi;
  }
  
  /**
   * Ataca a un koi
   */
  void attackKoi(Koi koi) {
    if (koi.isInvulnerable) return;
    
    // Aplicar daño basado en el sistema corregido
    applyDamageToKoi(koi, damage);
    
    // Hacer al koi invulnerable temporalmente
    koi.isInvulnerable = true;
    koi.invulnerabilityTimer = 0;
  }
  
  /**
   * Aplica daño a un koi según el nuevo sistema
   */
  void applyDamageToKoi(Koi koi, int damage) {
    // Obtener vidas actuales basadas en el tamaño
    int currentLives = getKoiLives(koi.length);
    
    // Calcular vidas restantes después del daño
    int livesAfterDamage = currentLives - damage;
    
    if (livesAfterDamage <= 0) {
      // El koi muere
      koi.setSinking();
    } else {
      // El koi sobrevive pero pierde niveles
      float newLength = getLengthFromLives(livesAfterDamage);
      koi.length = newLength;
      koi.width = newLength * 0.4;
    }
  }
  
  /**
   * Obtiene las vidas de un koi basadas en su tamaño
   */
  int getKoiLives(float length) {
    if (length >= 35) return 5; // XL
    if (length >= 28) return 4; // L
    if (length >= 20) return 3; // M
    if (length >= 15) return 2; // S
    return 1; // XS
  }
  
  /**
   * Obtiene el tamaño correspondiente a un número de vidas
   */
  float getLengthFromLives(int lives) {
    switch (lives) {
      case 5: return 35; // XL
      case 4: return 28; // L
      case 3: return 20; // M
      case 2: return 15; // S
      case 1: return 10; // XS
      default: return 10;
    }
  }
  
  /**
   * Mueve hacia el objetivo
   */
  void moveTowardsTarget(float deltaTime) {
    float targetAngle = Vector2D.angle(position, target);
    
    // Ajustar ángulo gradualmente
    float angleDiff = targetAngle - angle;
    while (angleDiff > PI) angleDiff -= TWO_PI;
    while (angleDiff < -PI) angleDiff += TWO_PI;
    
    angle += angleDiff * 0.05;
    
    // Mover en la dirección actual
    position.x += cos(angle) * speed * (deltaTime / 16.67);
    position.y += sin(angle) * speed * (deltaTime / 16.67);
  }
  
  /**
   * Reinicia el objetivo de exploración (usado cuando se interrumpe un comportamiento)
   */
  void resetExploration() {
    explorationTimer = 0;
    setNewExplorationTarget();
  }
  
  /**
   * Recibe daño de una roca
   */
  boolean takeDamage(int damage) {
    health -= damage;
    
    // Activar animación de golpe
    isHit = true;
    hitTimer = 0;
    
    // Mostrar indicador de vida
    showHealthIndicator = true;
    healthIndicatorTimer = 0;
    
    if (health <= 0) {
      isActive = false;
      return true; // Enemigo muerto
    }
    
    return false; // Enemigo herido pero vivo
  }
  
  /**
   * Obtiene el color actual del enemigo según su estado
   */
  color getCurrentColor() {
    if (isHit) {
      // Efecto de flash rojo cuando es golpeado
      float intensity = hitFlashIntensity;
      return color(
        red(baseEnemyColor) + intensity,
        green(baseEnemyColor),
        blue(baseEnemyColor)
      );
    }
    
    // Color según estado actual
    switch (currentState) {
      case HUNTING:
        // Rojizo y agresivo cuando caza
        return color(
          min(255, red(baseEnemyColor) * 1.4),
          green(baseEnemyColor) * 0.6,
          blue(baseEnemyColor) * 0.6
        );
        
      case FEEDING:
        // Ligeramente más brillante cuando busca comida
        return color(
          min(255, red(baseEnemyColor) * 1.1),
          min(255, green(baseEnemyColor) * 1.2),
          blue(baseEnemyColor)
        );
        
      case FLEEING:
        // Más pálido/asustado cuando huye
        return color(
          red(baseEnemyColor) * 0.8,
          green(baseEnemyColor) * 0.8,
          min(255, blue(baseEnemyColor) * 1.3)
        );
        
      case EXPLORING:
      case WANDERING:
      default:
        // Color normal para exploración
        return baseEnemyColor;
    }
  }
  
  /**
   * Renderiza el enemigo
   */
  void render() {
    if (!isActive) return;
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    
    // Color actual según estado
    color currentColor = getCurrentColor();
    
    // Cuerpo del enemigo
    noStroke();
    fill(currentColor);
    ellipse(0, 0, size, size * 0.6);
    
    // Aletas/cola
    fill(red(currentColor) * 0.7, green(currentColor) * 0.7, blue(currentColor) * 0.7);
    triangle(-size/2, 0, -size * 0.8, -size * 0.3, -size * 0.8, size * 0.3);
    
    // Ojos - diferentes según estado
    switch (currentState) {
      case HUNTING:
        fill(255, 0, 0); // Rojos cuando caza
        break;
      case FEEDING:
        fill(0, 255, 0); // Verdes cuando busca comida
        break;
      case FLEEING:
        fill(255, 255, 255); // Blancos cuando huye (asustado)
        break;
      case EXPLORING:
      case WANDERING:
      default:
        fill(255, 255, 0); // Amarillos cuando explora
        break;
    }
    ellipse(size * 0.2, -size * 0.15, 4, 4);
    ellipse(size * 0.2, size * 0.15, 4, 4);
    
    popMatrix();
    
    // Renderizar indicador de vida si está activo
    if (showHealthIndicator) {
      renderHealthIndicator();
    }
  }
  
  /**
   * Renderiza el indicador visual de vida
   */
  void renderHealthIndicator() {
    float indicatorY = position.y - size/2 - 15;
    float startX = position.x - (maxHealth * 6) / 2; // Centrar los puntos
    
    // Calcular opacidad basada en el tiempo
    float opacity = 255;
    if (healthIndicatorTimer > 1500) { // Fade out en los últimos 500ms
      opacity = map(healthIndicatorTimer, 1500, 2000, 255, 0);
    }
    
    // Dibujar puntos de vida
    for (int i = 0; i < maxHealth; i++) {
      float dotX = startX + (i * 12);
      
      noStroke();
      if (i < health) {
        // Vida restante - puntos rojos
        fill(255, 50, 50, opacity);
      } else {
        // Vida perdida - puntos negros
        fill(50, 50, 50, opacity);
      }
      
      ellipse(dotX, indicatorY, 8, 8);
      
      // Borde blanco para mejor visibilidad
      stroke(255, 255, 255, opacity * 0.8);
      strokeWeight(1);
      noFill();
      ellipse(dotX, indicatorY, 8, 8);
    }
  }
  
  /**
   * Obtiene el estado actual
   */
  EnemyState getState() {
    return currentState;
  }
  
  /**
   * Verifica si está activo
   */
  boolean isActive() {
    return isActive;
  }
}

/**
 * Tipos de enemigos disponibles
 */
enum EnemyType {
  SMALL_CATFISH,  // Bagre pequeño
  MEDIUM_CARP,    // Carpa mediana  
  LARGE_PIKE,     // Lucio grande
  SHARK           // Tiburón
} 