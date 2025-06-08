/**
 * Clase Enemy
 * 
 * Representa un enemigo/depredador en el juego.
 * Los enemigos persiguen y atacan a los koi, pero también pueden ser distraídos.
 */

// Estados de comportamiento del enemigo
enum EnemyState {
  WANDERING,    // Explorando - puede ser distraído por comida y asustado por rocas
  HUNTING       // Persiguiendo koi - más rojizo, no se distrae
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
   * Calcula la dirección inicial para alejarse del borde de spawn
   */
  Vector2D calculateInitialDirection(float spawnX, float spawnY) {
    float centerX = 300; // Centro del canvas
    float centerY = 300;
    
    // Calcular dirección hacia el centro desde la posición de spawn
    float dirX = centerX - spawnX;
    float dirY = centerY - spawnY;
    
    // Normalizar la dirección
    float magnitude = sqrt(dirX * dirX + dirY * dirY);
    if (magnitude > 0) {
      dirX /= magnitude;
      dirY /= magnitude;
    }
    
    return new Vector2D(dirX, dirY);
  }
  
  /**
   * Actualiza el movimiento inicial temporal
   */
  void updateInitialMovement(float deltaTime) {
    initialMovementTimer += deltaTime;
    
    // Finalizar movimiento inicial después del tiempo establecido
    if (initialMovementTimer >= initialMovementDuration) {
      initialMovement = false;
      return;
    }
    
    // Calcular posición objetivo alejándose del borde
    float distanceFromCenter = 150; // Distancia mínima del centro
    float targetX = position.x + (initialDirection.x * distanceFromCenter);
    float targetY = position.y + (initialDirection.y * distanceFromCenter);
    
    // Aplicar influencia hacia esta dirección
    float influence = 0.4; // Influencia del 40%
    target.x = target.x * (1 - influence) + targetX * influence;
    target.y = target.y * (1 - influence) + targetY * influence;
  }
  
  /**
   * Actualiza el comportamiento principal del enemigo
   */
  void updateBehavior(ArrayList<Koi> kois, ArrayList<FoodParticle> foodParticles) {
    // Prioridad 1: Buscar koi objetivo
    findNearestKoi(kois);
    
    if (targetKoi != null) {
      // Estado HUNTING: perseguir koi
      currentState = EnemyState.HUNTING;
      target.x = targetKoi.position.x;
      target.y = targetKoi.position.y;
      
      // Verificar si puede atacar
      float distance = Vector2D.distance(position, targetKoi.position);
      if (distance < size/2 + targetKoi.length/2) {
        attackKoi(targetKoi);
      }
    } else {
      // Estado WANDERING: buscar comida o moverse aleatoriamente
      currentState = EnemyState.WANDERING;
      
      // Buscar comida si está en modo wandering
      findNearestFood(foodParticles);
      
      if (targetFood != null) {
        // Ir hacia la comida
        target.x = targetFood.x;
        target.y = targetFood.y;
      } else {
        // Movimiento aleatorio
        moveRandomly(width, height);
      }
    }
  }
  
  /**
   * Busca la comida más cercana
   */
  void findNearestFood(ArrayList<FoodParticle> foodParticles) {
    if (currentState != EnemyState.WANDERING) {
      targetFood = null;
      return;
    }
    
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
    } else {
      targetFood = null;
    }
  }
  
  /**
   * Atrae al enemigo hacia un punto (comida del jugador)
   */
  void attractToPoint(float x, float y, float radius) {
    if (currentState != EnemyState.WANDERING) return; // Solo si no está cazando
    
    float distance = Vector2D.distance(position, new Vector2D(x, y));
    if (distance < radius) {
      target.x = x + random(-20, 20); // Pequeña variación
      target.y = y + random(-20, 20);
      targetFood = new Vector2D(x, y); // Temporalmente
    }
  }
  
  /**
   * Repele al enemigo de un punto (rocas)
   */
  void repelFromPoint(float x, float y, float radius) {
    if (currentState != EnemyState.WANDERING) return; // Solo si no está cazando
    
    float distance = Vector2D.distance(position, new Vector2D(x, y));
    if (distance < radius) {
      // Calcular dirección opuesta
      float angle = Vector2D.angle(new Vector2D(x, y), position);
      
      // Moverse en dirección opuesta
      float escapeDistance = radius + RandomUtils.randomFloat(50, 150);
      target.x = x + cos(angle) * escapeDistance;
      target.y = y + sin(angle) * escapeDistance;
      
      // Limpiar objetivo de comida
      targetFood = null;
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
   * Verifica colisiones con rocas
   */
  void checkRockCollisions() {
    for (Rock rock : rocks) {
      float distance = Vector2D.distance(position, rock.position);
      
      if (distance < (size/2 + rock.size)) {
        // Colisión detectada - regresar a la última posición válida
        position.x = lastValidPosition.x;
        position.y = lastValidPosition.y;
        
        // Cambiar dirección para evitar quedarse atascado
        angle += PI/2 + random(-PI/4, PI/4);
        
        // Buscar nuevo objetivo o dirección aleatoria
        if (targetKoi != null) {
          // Intentar rodear la roca
          Vector2D avoidDirection = position.subtract(rock.position);
          Vector2D normalizedDirection = avoidDirection.normalize();
          Vector2D scaledDirection = normalizedDirection.multiply(rock.size + size/2 + 20); // Distancia de seguridad
          
          target.x = rock.position.x + scaledDirection.x;
          target.y = rock.position.y + scaledDirection.y;
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
   * Movimiento aleatorio cuando no hay objetivo
   */
  void moveRandomly(float canvasWidth, float canvasHeight) {
    if (random(1) < 0.02) { // 2% chance per frame to change direction
      target.x = random(50, canvasWidth - 50);
      target.y = random(50, canvasHeight - 50);
    }
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
    
    // Color según estado
    if (currentState == EnemyState.HUNTING) {
      // Más rojizo cuando está cazando
      return color(
        min(255, red(baseEnemyColor) * 1.5),
        green(baseEnemyColor) * 0.7,
        blue(baseEnemyColor) * 0.7
      );
    } else {
      // Color normal cuando está explorando
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
    if (currentState == EnemyState.HUNTING) {
      fill(255, 0, 0); // Rojos cuando caza
    } else {
      fill(255, 255, 0); // Amarillos cuando explora
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