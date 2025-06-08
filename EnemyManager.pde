/**
 * Clase EnemyManager
 * 
 * Gestiona todos los enemigos en el juego.
 * Maneja spawn, comportamiento y escalada de dificultad.
 */
class EnemyManager {
  ArrayList<Enemy> enemies;
  ArrayList<SpawnIndicator> spawnIndicators; // Indicadores de spawn
  float canvasWidth;
  float canvasHeight;
  ArrayList<Rock> rocks; // Referencia a las rocas para colisiones
  
  // Sistema de spawn para Waves
  float waveSpawnTimer;
  float waveSpawnInterval;
  int currentWave;
  boolean waveStarted; // Para manejar la alerta inicial
  float initialAlertTimer; // Timer para la alerta inicial
  boolean showingInitialAlert; // Si está mostrando la alerta inicial
  
  // Sistema de spawn para Endless
  float endlessSpawnTimer;
  float endlessSpawnInterval;
  float difficultyTimer;
  int difficultyLevel;
  boolean endlessStarted; // Para manejar la alerta inicial
  float endlessInitialAlertTimer; // Timer para la alerta inicial en endless
  boolean showingEndlessInitialAlert; // Si está mostrando la alerta inicial en endless
  
  // Configuración de enemigos por wave
  float[][] waveEnemyProbabilities = {
    // Wave 1: {Bagre, Carpa, Lucio, Tiburón}
    {0.9f, 0.1f, 0.0f, 0.0f},
    // Wave 2  
    {0.6f, 0.3f, 0.1f, 0.0f},
    // Wave 3
    {0.4f, 0.3f, 0.2f, 0.1f},
    // Wave 4
    {0.3f, 0.3f, 0.25f, 0.15f},
    // Wave 5
    {0.2f, 0.35f, 0.45f, 0.0f} // Sin tiburones en Wave 5 según README
  };
  
  int[] waveSpawnCounts = {1, 2, 3, 4, 5}; // Enemigos por spawn según wave
  
  /**
   * Constructor
   */
  EnemyManager(float canvasWidth, float canvasHeight) {
    this.enemies = new ArrayList<Enemy>();
    this.spawnIndicators = new ArrayList<SpawnIndicator>();
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.rocks = new ArrayList<Rock>(); // Inicializar lista vacía
    
    // Configuración para Waves
    this.waveSpawnTimer = 0;
    this.waveSpawnInterval = 5000; // Cambiado a 5 segundos
    this.currentWave = 1;
    this.waveStarted = false;
    this.initialAlertTimer = 0;
    this.showingInitialAlert = false;
    
    // Configuración para Endless
    this.endlessSpawnTimer = 0;
    this.endlessSpawnInterval = 5000; // Cambiado a 5 segundos
    this.difficultyTimer = 0;
    this.difficultyLevel = 1;
    this.endlessStarted = false;
    this.endlessInitialAlertTimer = 0;
    this.showingEndlessInitialAlert = false;
  }
  
  /**
   * Establece las rocas para colisión con enemigos
   */
  void setRocks(ArrayList<Rock> rocks) {
    this.rocks = rocks;
    
    // Pasar rocas a enemigos existentes
    for (Enemy enemy : enemies) {
      enemy.setRocks(rocks);
    }
  }
  
  /**
   * Actualiza todos los enemigos
   */
  void update(float deltaTime, ArrayList<Koi> kois, String gameMode, ArrayList<FoodParticle> foodParticles) {
    // Actualizar indicadores de spawn
    updateSpawnIndicators(deltaTime);
    
    // Actualizar enemigos existentes
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      
      if (enemy.isActive()) {
        enemy.update(deltaTime, kois, canvasWidth, canvasHeight, foodParticles);
      } else {
        // Enemigo muerto, remover
        enemies.remove(i);
      }
    }
    
    // Manejo de spawn según el modo
    if (gameMode.equals("waves")) {
      updateWaveSpawning(deltaTime);
    } else if (gameMode.equals("endless")) {
      updateEndlessSpawning(deltaTime);
    }
  }
  
  /**
   * Actualiza los indicadores de spawn
   */
  void updateSpawnIndicators(float deltaTime) {
    for (int i = spawnIndicators.size() - 1; i >= 0; i--) {
      SpawnIndicator indicator = spawnIndicators.get(i);
      indicator.update(deltaTime);
      
      if (indicator.shouldSpawn()) {
        // Crear enemigo en la posición del indicador
        Enemy newEnemy = new Enemy(indicator.position.x, indicator.position.y, indicator.enemyType);
        newEnemy.setRocks(rocks); // Establecer rocas para colisión
        enemies.add(newEnemy);
        spawnIndicators.remove(i);
      } else if (indicator.isExpired()) {
        // Indicador expirado sin spawn
        spawnIndicators.remove(i);
      }
    }
  }
  
  /**
   * Actualiza el spawn de enemigos para modo Waves
   */
  void updateWaveSpawning(float deltaTime) {
    if (!waveStarted) {
      // Mostrar alerta inicial
      if (!showingInitialAlert) {
        showingInitialAlert = true;
        initialAlertTimer = 0;
      }
      
      initialAlertTimer += deltaTime;
      
      if (initialAlertTimer >= 5000) { // 5 segundos de alerta
        waveStarted = true;
        showingInitialAlert = false;
        waveSpawnTimer = 0; // Reiniciar timer de spawn
      }
      return;
    }
    
    waveSpawnTimer += deltaTime;
    
    if (waveSpawnTimer >= waveSpawnInterval) {
      scheduleWaveEnemySpawn(); // Cambio para programar spawn con indicador
      waveSpawnTimer = 0;
    }
  }
  
  /**
   * Actualiza el spawn de enemigos para modo Endless
   */
  void updateEndlessSpawning(float deltaTime) {
    if (!endlessStarted) {
      // Mostrar alerta inicial
      if (!showingEndlessInitialAlert) {
        showingEndlessInitialAlert = true;
        endlessInitialAlertTimer = 0;
      }
      
      endlessInitialAlertTimer += deltaTime;
      
      if (endlessInitialAlertTimer >= 5000) { // 5 segundos de alerta
        endlessStarted = true;
        showingEndlessInitialAlert = false;
        endlessSpawnTimer = 0; // Reiniciar timer de spawn
        difficultyTimer = 0; // Empezar contador de dificultad
      }
      return;
    }
    
    // Aumentar dificultad cada 30 segundos
    difficultyTimer += deltaTime;
    if (difficultyTimer >= 30000) { // 30 segundos
      increaseDifficulty();
      difficultyTimer = 0;
    }
    
    endlessSpawnTimer += deltaTime;
    
    if (endlessSpawnTimer >= endlessSpawnInterval) {
      scheduleEndlessEnemySpawn(); // Cambio para programar spawn con indicador
      endlessSpawnTimer = 0;
    }
  }
  
  /**
   * Programa spawn de enemigos para modo Waves con indicadores
   */
  void scheduleWaveEnemySpawn() {
    if (currentWave < 1 || currentWave > 5) return;
    
    int waveIndex = currentWave - 1;
    int spawnCount = waveSpawnCounts[waveIndex];
    
    for (int i = 0; i < spawnCount; i++) {
      EnemyType type = selectEnemyTypeForWave(waveIndex);
      Vector2D spawnPos = getRandomSpawnPosition();
      
      // Crear indicador de spawn en lugar de enemigo directo
      SpawnIndicator indicator = new SpawnIndicator(spawnPos.x, spawnPos.y, type, 2000); // 2 segundos
      spawnIndicators.add(indicator);
    }
  }
  
  /**
   * Programa spawn de enemigos para modo Endless con indicadores
   */
  void scheduleEndlessEnemySpawn() {
    int spawnCount = getEndlessSpawnCount();
    
    for (int i = 0; i < spawnCount; i++) {
      EnemyType type = selectEnemyTypeForEndless();
      Vector2D spawnPos = getRandomSpawnPosition();
      
      // Crear indicador de spawn en lugar de enemigo directo
      SpawnIndicator indicator = new SpawnIndicator(spawnPos.x, spawnPos.y, type, 2000); // 2 segundos
      spawnIndicators.add(indicator);
    }
  }
  
  /**
   * Selecciona tipo de enemigo para Waves basado en probabilidades
   */
  EnemyType selectEnemyTypeForWave(int waveIndex) {
    float[] probabilities = waveEnemyProbabilities[waveIndex];
    float roll = random(1);
    
    float cumulative = 0;
    for (int i = 0; i < probabilities.length; i++) {
      cumulative += probabilities[i];
      if (roll <= cumulative) {
        return EnemyType.values()[i];
      }
    }
    
    return EnemyType.SMALL_CATFISH; // Fallback
  }
  
  /**
   * Selecciona tipo de enemigo para Endless basado en nivel de dificultad
   */
  EnemyType selectEnemyTypeForEndless() {
    float roll = random(1);
    
    if (difficultyLevel <= 2) {
      // 0-60 segundos: Solo bagres
      return EnemyType.SMALL_CATFISH;
    } else if (difficultyLevel <= 4) {
      // 60-120 segundos: Bagres + Carpas
      return roll < 0.7 ? EnemyType.SMALL_CATFISH : EnemyType.MEDIUM_CARP;
    } else if (difficultyLevel <= 6) {
      // 120-180 segundos: Bagres + Carpas + Lucios
      if (roll < 0.5) return EnemyType.SMALL_CATFISH;
      if (roll < 0.8) return EnemyType.MEDIUM_CARP;
      return EnemyType.LARGE_PIKE;
    } else {
      // 180+ segundos: Todos los tipos
      if (roll < 0.3) return EnemyType.SMALL_CATFISH;
      if (roll < 0.6) return EnemyType.MEDIUM_CARP;
      if (roll < 0.85) return EnemyType.LARGE_PIKE;
      return EnemyType.SHARK;
    }
  }
  
  /**
   * Obtiene la cantidad de enemigos a spawner en Endless
   */
  int getEndlessSpawnCount() {
    if (difficultyLevel <= 1) return 1;
    if (difficultyLevel <= 3) return 2;
    if (difficultyLevel <= 5) return 3;
    if (difficultyLevel <= 7) return 4;
    return 5; // Máximo
  }
  
  /**
   * Aumenta la dificultad en modo Endless
   */
  void increaseDifficulty() {
    difficultyLevel++;
    
    // Reducir intervalo de spawn gradualmente
    if (endlessSpawnInterval > 1500) { // Mínimo 1.5 segundos
      endlessSpawnInterval -= 200;
    }
    
    println("🔥 Dificultad aumentada a nivel " + difficultyLevel);
  }
  
  /**
   * Obtiene una posición de spawn aleatoria en los bordes
   */
  Vector2D getRandomSpawnPosition() {
    int edge = (int)random(4); // 0=arriba, 1=derecha, 2=abajo, 3=izquierda
    
    switch (edge) {
      case 0: // Arriba
        return new Vector2D(random(0, canvasWidth), -30);
      case 1: // Derecha  
        return new Vector2D(canvasWidth + 30, random(0, canvasHeight));
      case 2: // Abajo
        return new Vector2D(random(0, canvasWidth), canvasHeight + 30);
      case 3: // Izquierda
        return new Vector2D(-30, random(0, canvasHeight));
      default:
        return new Vector2D(0, 0);
    }
  }
  
  /**
   * Verifica colisiones con rocas lanzadas
   */
  void checkRockCollisions(float rockX, float rockY, float rockRadius) {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      
      if (!enemy.isActive()) continue;
      
      float distance = Vector2D.distance(enemy.position, new Vector2D(rockX, rockY));
      
      if (distance < enemy.size/2 + rockRadius) {
        // Impacto directo
        boolean died = enemy.takeDamage(1);
        
        if (died) {
          // Enemigo eliminado - la notificación se manejará desde los managers principales
          // que tienen acceso al UI Manager correspondiente
        }
      }
    }
  }
  
  /**
   * Verifica colisiones con rocas lanzadas y notifica al UI Manager
   */
  void checkRockCollisions(float rockX, float rockY, float rockRadius, Object uiManager) {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      
      if (!enemy.isActive()) continue;
      
      float distance = Vector2D.distance(enemy.position, new Vector2D(rockX, rockY));
      
      if (distance < enemy.size/2 + rockRadius) {
        // Impacto directo
        boolean died = enemy.takeDamage(1);
        
        if (died) {
          // Notificar al UI Manager correspondiente
          if (uiManager instanceof WavesUIManager) {
            // WavesUIManager no tiene método killEnemy, pero se puede añadir
          } else if (uiManager instanceof EndlessUIManager) {
            ((EndlessUIManager)uiManager).killEnemy();
          }
        }
      }
    }
  }
  
  /**
   * Establece la wave actual (para modo Waves)
   */
  void setCurrentWave(int wave) {
    // Reiniciar sistema de alerta para nueva wave
    if (wave != this.currentWave) {
      waveStarted = false;
      showingInitialAlert = false;
      initialAlertTimer = 0;
      println("🌊 Reiniciando alerta para Wave " + wave);
    }
    
    this.currentWave = wave;
  }
  
  /**
   * Reinicia el sistema de alerta para modo Endless
   */
  void restartEndlessAlert() {
    endlessStarted = false;
    showingEndlessInitialAlert = false;
    endlessInitialAlertTimer = 0;
    println("♾️ Reiniciando alerta para modo Endless");
  }
  
  /**
   * Limpia todos los enemigos
   */
  void clearAllEnemies() {
    enemies.clear();
    spawnIndicators.clear();
    
    // Reiniciar timers según el modo
    if (waveStarted) {
      // Reset del sistema de waves
      waveStarted = false;
      showingInitialAlert = false;
      initialAlertTimer = 0;
      waveSpawnTimer = 0;
    }
    
    if (endlessStarted) {
      // Reset del sistema endless 
      endlessStarted = false;
      showingEndlessInitialAlert = false;
      endlessInitialAlertTimer = 0;
      endlessSpawnTimer = 0;
    }
    
    println("🧹 Todos los enemigos han sido eliminados");
  }
  
  /**
   * Renderiza todos los enemigos e indicadores
   */
  void render() {
    // Renderizar indicadores de spawn
    for (SpawnIndicator indicator : spawnIndicators) {
      indicator.render();
    }
    
    // Renderizar enemigos
    for (Enemy enemy : enemies) {
      enemy.render();
    }
  }
  
  /**
   * Obtiene todos los enemigos
   */
  ArrayList<Enemy> getEnemies() {
    return enemies;
  }
  
  /**
   * Obtiene el número de enemigos activos
   */
  int getActiveEnemyCount() {
    int count = 0;
    for (Enemy enemy : enemies) {
      if (enemy.isActive()) count++;
    }
    return count;
  }
  
  /**
   * Obtiene si está mostrando alerta inicial para Waves
   */
  boolean isShowingWaveAlert() {
    return showingInitialAlert;
  }
  
  /**
   * Obtiene si está mostrando alerta inicial para Endless
   */
  boolean isShowingEndlessAlert() {
    return showingEndlessInitialAlert;
  }
  
  /**
   * Obtiene el tiempo restante de la alerta inicial para Waves
   */
  float getWaveAlertTimeRemaining() {
    if (!showingInitialAlert) return 0;
    return max(0, 5000 - initialAlertTimer);
  }
  
  /**
   * Obtiene el tiempo restante de la alerta inicial para Endless
   */
  float getEndlessAlertTimeRemaining() {
    if (!showingEndlessInitialAlert) return 0;
    return max(0, 5000 - endlessInitialAlertTimer);
  }
  
  /**
   * Reinicia el sistema para un nuevo juego
   */
  void reset() {
    enemies.clear();
    spawnIndicators.clear();
    
    // Reset Waves
    waveStarted = false;
    showingInitialAlert = false;
    initialAlertTimer = 0;
    waveSpawnTimer = 0;
    
    // Reset Endless
    endlessStarted = false;
    showingEndlessInitialAlert = false;
    endlessInitialAlertTimer = 0;
    endlessSpawnTimer = 0;
    difficultyTimer = 0;
    difficultyLevel = 1;
    endlessSpawnInterval = 5000;
  }
  
  /**
   * Atrae a todos los enemigos hacia un punto (comida del jugador)
   */
  void attractToPoint(float x, float y, float radius) {
    for (Enemy enemy : enemies) {
      if (enemy.isActive()) {
        enemy.attractToPoint(x, y, radius);
      }
    }
  }
  
  /**
   * Repele a todos los enemigos de un punto (rocas)
   */
  void repelFromPoint(float x, float y, float radius) {
    for (Enemy enemy : enemies) {
      if (enemy.isActive()) {
        enemy.repelFromPoint(x, y, radius);
      }
    }
  }
}

/**
 * Clase SpawnIndicator
 * 
 * Indica dónde va a aparecer un enemigo antes de que spawne.
 */
class SpawnIndicator {
  Vector2D position;
  EnemyType enemyType;
  float duration;
  float timer;
  float pulseTimer;
  boolean shouldSpawnNow;
  
  /**
   * Constructor
   */
  SpawnIndicator(float x, float y, EnemyType type, float duration) {
    this.position = new Vector2D(x, y);
    this.enemyType = type;
    this.duration = duration;
    this.timer = 0;
    this.pulseTimer = 0;
    this.shouldSpawnNow = false;
  }
  
  /**
   * Actualiza el indicador
   */
  void update(float deltaTime) {
    timer += deltaTime;
    pulseTimer += deltaTime;
    
    if (timer >= duration) {
      shouldSpawnNow = true;
    }
  }
  
  /**
   * Verifica si debe crear el enemigo
   */
  boolean shouldSpawn() {
    return shouldSpawnNow;
  }
  
  /**
   * Verifica si ha expirado
   */
  boolean isExpired() {
    return timer > duration + 1000; // 1 segundo extra de gracia
  }
  
  /**
   * Renderiza el indicador
   */
  void render() {
    if (shouldSpawnNow) return; // No renderizar si ya debe spawner
    
    pushMatrix();
    translate(position.x, position.y);
    
    // Efecto de pulso
    float pulse = sin(pulseTimer * 0.01) * 0.3 + 0.7;
    float progress = timer / duration;
    
    // Color según tipo de enemigo
    color indicatorColor;
    switch (enemyType) {
      case SMALL_CATFISH:
        indicatorColor = color(139, 69, 19, 150 * pulse); // Marrón
        break;
      case MEDIUM_CARP:
        indicatorColor = color(85, 107, 47, 150 * pulse); // Verde oliva
        break;
      case LARGE_PIKE:
        indicatorColor = color(47, 79, 79, 150 * pulse); // Gris pizarra
        break;
      case SHARK:
        indicatorColor = color(70, 70, 70, 150 * pulse); // Gris oscuro
        break;
      default:
        indicatorColor = color(255, 0, 0, 150 * pulse); // Rojo por defecto
    }
    
    // Círculo exterior pulsante
    noFill();
    stroke(indicatorColor);
    strokeWeight(3);
    float outerRadius = 30 + sin(pulseTimer * 0.02) * 10;
    ellipse(0, 0, outerRadius * 2, outerRadius * 2);
    
    // Círculo interior que se llena con el progreso
    fill(indicatorColor);
    noStroke();
    float innerRadius = 15 * progress;
    ellipse(0, 0, innerRadius * 2, innerRadius * 2);
    
    // Flecha direccional
    stroke(255, 100 * pulse);
    strokeWeight(2);
    
    // Determinar dirección de la flecha hacia el centro
    float centerX = width / 2;
    float centerY = height / 2;
    float directionAngle = atan2(centerY - position.y, centerX - position.x);
    
    pushMatrix();
    rotate(directionAngle);
    line(-20, 0, -10, 0);
    line(-15, -5, -10, 0);
    line(-15, 5, -10, 0);
    popMatrix();
    
    popMatrix();
  }
} 