/**
 * Clase WavesUIManager
 * 
 * He implementado la interfaz de usuario para el Modo Waves.
 * Sistema de 5 waves con timer hacia atrás y recursos limitados.
 */
class WavesUIManager {
  PApplet applet;
  KoiManager koiManager;
  EnemyManager enemyManager; // Referencia para limpiar enemigos entre waves
  IconRenderer iconRenderer; // Renderizador de iconos
  
  // Sistema de waves
  int currentWave;
  float waveStartTime;
  float waveDuration; // 2 minutos por wave
  boolean waveComplete;
  
  // Nombres y tiempos de día de las waves
  String[] waveNames = {"DÍA", "ATARDECER", "NOCHE", "AMANECER", "DÍA"};
  int[] waveTimes = {0, 1, 2, 3, 0}; // 0=día, 1=atardecer, 2=noche, 3=amanecer
  
  // Sistema de recursos
  int foodCount;
  int rockCount;
  int maxFood;
  int maxRocks;
  
  // Colores
  color textColor = color(255, 255, 255);
  color backgroundColor = color(0, 0, 0, 120);
  color waveColor = color(255, 215, 0); // Dorado para wave
  
  /**
   * Constructor
   */
  WavesUIManager(PApplet applet, KoiManager koiManager) {
    this.applet = applet;
    this.koiManager = koiManager;
    this.enemyManager = null; // Se asignará después
    this.iconRenderer = new IconRenderer(); // Inicializar renderizador de iconos
    
    // Inicializar waves
    this.currentWave = 1;
    this.waveStartTime = millis();
    this.waveDuration = 12000; // 2 minutos en milisegundos
    this.waveComplete = false;
    
    // Inicializar recursos limitados (más recursos que en Endless)
    this.maxFood = 100;
    this.maxRocks = 100;
    this.foodCount = maxFood;
    this.rockCount = maxRocks;
  }
  
  /**
   * Establece la referencia al EnemyManager
   */
  void setEnemyManager(EnemyManager enemyManager) {
    this.enemyManager = enemyManager;
  }
  
  /**
   * Actualiza la UI y el sistema de waves
   */
  void update() {
    float currentTime = millis();
    float timeInWave = currentTime - waveStartTime;
    
    // Verificar si la wave actual ha terminado
    if (timeInWave >= waveDuration && !waveComplete) {
      completeWave();
    }
  }
  
  /**
   * Completa la wave actual y avanza a la siguiente
   */
  void completeWave() {
    waveComplete = true;
    
    if (currentWave < 5) {
      // La wave está completa, pero esperamos al upgrade antes de avanzar
      // El avance real se hará desde UpgradeScreen.continueToNextWave()
      
      // Reponer algunos recursos entre waves
      foodCount = min(maxFood, foodCount + 20);
      rockCount = min(maxRocks, rockCount + 10);
    } else {
      // Juego completado - las 5 waves terminadas
      // Aquí se podría mostrar pantalla de victoria
    }
  }
  
  /**
   * Avanza a la siguiente wave (llamado desde UpgradeScreen)
   */
  void advanceToNextWave() {
    if (currentWave < 5) {
      // Limpiar todos los enemigos antes de avanzar
      if (enemyManager != null) {
        enemyManager.clearAllEnemies();
        println("🌊 Enemigos limpiados al avanzar a Wave " + (currentWave + 1));
      }
      
      currentWave++;
      waveStartTime = millis();
      waveComplete = false;
      println("Avanzando a la Oleada " + currentWave);
    }
  }
  
  /**
   * Obtiene el tiempo del día actual según la wave
   */
  int getCurrentTimeOfDay() {
    if (currentWave <= 5) {
      return waveTimes[currentWave - 1];
    }
    return 0; // Día por defecto
  }
  
  /**
   * Maneja los clics del ratón
   */
  boolean handleClick(float mouseX, float mouseY) {
    // No hay botones que manejar en Waves mode
    return false;
  }
  
  /**
   * Usa comida (devuelve true si se pudo usar)
   */
  boolean useFood() {
    if (foodCount > 0) {
      foodCount--;
      return true;
    }
    return false;
  }
  
  /**
   * Usa piedra (devuelve true si se pudo usar)
   */
  boolean useRock() {
    if (rockCount > 0) {
      rockCount--;
      return true;
    }
    return false;
  }
  
  /**
   * Verifica si todas las waves han sido completadas
   */
  boolean isGameComplete() {
    return currentWave > 5;
  }
  
  /**
   * Renderiza todos los elementos de la UI
   */
  void render() {
    renderWaveInfo();
    renderTimer();
    renderResources();
    renderFishCounter();
    renderEnemyAlert();
  }
  
  /**
   * Renderiza información de la wave actual
   */
  void renderWaveInfo() {
    if (currentWave <= 5) {
      String waveText = "WAVE " + currentWave + " - " + waveNames[currentWave - 1];
      
      // Fondo de la wave
      applet.fill(backgroundColor);
      applet.noStroke();
      applet.rect(applet.width/2 - 80, 20, 160, 25, 5);
      
      // Texto de la wave
      applet.fill(waveColor);
      applet.textSize(14);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(waveText, applet.width/2, 32);
    } else {
      // Juego completado
      applet.fill(backgroundColor);
      applet.rect(applet.width/2 - 80, 20, 160, 25, 5);
      
      applet.fill(color(100, 255, 100));
      applet.textSize(14);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text("¡TODAS LAS OLEADAS COMPLETAS!", applet.width/2, 32);
    }
  }
  
  /**
   * Renderiza el timer hacia atrás
   */
  void renderTimer() {
    if (currentWave <= 5 && !waveComplete) {
      float timerTime = millis();
      float timeInWave = timerTime - waveStartTime;
      float timeRemaining = max(0, waveDuration - timeInWave);
      
      int minutes = (int)(timeRemaining / 60000);
      int seconds = (int)((timeRemaining % 60000) / 1000);
      
      String timeString = nf(minutes, 1) + ":" + nf(seconds, 2);
      
      // Color del timer según el tiempo restante
      color timerColor = textColor;
      if (timeRemaining < 30000) { // Últimos 30 segundos
        timerColor = color(255, 100, 100); // Rojo
      } else if (timeRemaining < 60000) { // Último minuto
        timerColor = color(255, 255, 100); // Amarillo
      }
      
      // Fondo del timer
      applet.fill(backgroundColor);
      applet.noStroke();
      applet.rect(applet.width/2 - 30, 50, 60, 25, 5);
      
      // Texto del timer
      applet.fill(timerColor);
      applet.textSize(16);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(timeString, applet.width/2, 62);
    }
  }
  
  /**
   * Renderiza los recursos disponibles
   */
  void renderResources() {
    // Contenedores más pequeños y separados
    float containerWidth = 85;
    float containerHeight = 25;
    float spacing = 5;
    
    // Contenedor de comida - más hacia adentro
    applet.fill(backgroundColor);
    applet.rect(applet.width - containerWidth - 15, 20, containerWidth, containerHeight, 5);
    
    // Contenedor de rocas - más hacia adentro
    applet.fill(backgroundColor);
    applet.rect(applet.width - containerWidth - 15, 20 + containerHeight + spacing, containerWidth, containerHeight, 5);
    
    // Iconos y texto de recursos
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    
    // Comida
    color foodColor = foodCount > 20 ? color(100, 255, 100) : color(255, 100, 100);
    iconRenderer.drawFoodIcon(applet, applet.width - containerWidth , 32, 14, foodColor);
    applet.fill(foodColor);
    applet.text(foodCount + "/" + maxFood, applet.width - containerWidth + 10, 32);
    
    // Piedras - ahora con color gris claro
    color rockColor = color(180, 180, 180); // Gris claro siempre
    iconRenderer.drawRockIcon(applet, applet.width - containerWidth, 32 + containerHeight + spacing, 14, rockColor);
    applet.fill(rockColor);
    applet.text(rockCount + "/" + maxRocks, applet.width - containerWidth + 10, 32 + containerHeight + spacing);
  }
  
  /**
   * Renderiza el contador de peces
   */
  void renderFishCounter() {
    int currentFishCount = koiManager.getKoiCount();
    
    // Contenedor más pequeño y más a la derecha
    float containerWidth = 60;
    float containerHeight = 25;
    float containerX = 35; // Movido más hacia adentro
    
    // Fondo del contador
    applet.fill(backgroundColor);
    applet.rect(containerX, 20, containerWidth, containerHeight, 5);
    
    // Icono y texto del contador - con color rosa de power-ups
    color pinkColor = color(255, 150, 150); // Color rosa de los power-ups de peces
    iconRenderer.drawFishIcon(applet, containerX + 17, 32, 16, pinkColor);
    applet.fill(textColor);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text(currentFishCount, containerX + 30, 32);
  }
  
  /**
   * Aplica el efecto de un power-up
   */
  void applyPowerUp(PowerUp powerUp) {
    switch (powerUp.type) {
      case ROCKS:
        // Solo añadir rocas hasta el máximo actual (sin exceder el límite)
        int rocksToAdd = min(powerUp.amount, maxRocks - rockCount);
        rockCount += rocksToAdd;
        break;
      case KOI:
        // Los koi se añaden directamente en PowerUpManager
        break;
      case FOOD:
        // Solo añadir comida hasta el máximo actual (sin exceder el límite)
        int foodToAdd = min(powerUp.amount, maxFood - foodCount);
        foodCount += foodToAdd;
        break;
    }
  }
  
  /**
   * Renderiza la alerta de enemigos si está activa
   */
  void renderEnemyAlert() {
    // Esta función será llamada desde el manager principal
    // que tiene acceso al EnemyManager
  }
  
  /**
   * Renderiza alerta de enemigos con información específica
   */
  void renderEnemyAlert(boolean showingAlert, float timeRemaining) {
    if (!showingAlert) return;
    
    int secondsRemaining = (int)ceil(timeRemaining / 1000.0);
    
    // Fondo de alerta
    applet.fill(255, 0, 0, 100);
    applet.noStroke();
    applet.rect(0, 0, applet.width, applet.height);
    
    // Mensaje de alerta central
    applet.fill(255, 255, 255);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.textSize(32);
    applet.text("¡ENEMIGOS SE ACERCAN!", applet.width/2, applet.height/2 - 40);
    
    // Contador
    applet.fill(255, 255, 0);
    applet.textSize(48);
    applet.text(secondsRemaining, applet.width/2, applet.height/2 + 20);
    
    // Texto informativo
    applet.fill(255, 255, 255);
    applet.textSize(16);
    applet.text("Prepárate para defender a tus koi", applet.width/2, applet.height/2 + 80);
  }
} 