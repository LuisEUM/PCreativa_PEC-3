/**
 * Clase WavesUIManager
 * 
 * Gestiona la interfaz de usuario para el Modo Waves.
 * Sistema de 5 waves con timer hacia atrás y recursos limitados.
 */
class WavesUIManager {
  PApplet applet;
  KoiManager koiManager;
  
  // Sistema de waves
  int currentWave;
  float waveStartTime;
  float waveDuration; // 2 minutos por wave
  boolean waveComplete;
  
  // Nombres y tiempos de día de las waves
  String[] waveNames = {"DAY", "SUNSET", "NIGHT", "DAWN", "DAY"};
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
    
    // Inicializar waves
    this.currentWave = 1;
    this.waveStartTime = millis();
    this.waveDuration = 120; // 2 minutos en milisegundos
    this.waveComplete = false;
    
    // Inicializar recursos limitados (más recursos que en Endless)
    this.maxFood = 100;
    this.maxRocks = 60;
    this.foodCount = maxFood;
    this.rockCount = maxRocks;
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
      currentWave++;
      waveStartTime = millis();
      waveComplete = false;
      println("🌊 Avanzando a Wave " + currentWave);
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
      applet.text("ALL WAVES COMPLETE!", applet.width/2, 32);
    }
  }
  
  /**
   * Renderiza el timer hacia atrás
   */
  void renderTimer() {
    if (currentWave <= 5 && !waveComplete) {
      float currentTime = millis();
      float timeInWave = currentTime - waveStartTime;
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
    // Fondo de recursos
    applet.fill(backgroundColor);
    applet.rect(applet.width - 140, 20, 120, 50, 5);
    
    // Texto de recursos
    applet.fill(textColor);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    
    // Comida
    color foodColor = foodCount > 20 ? color(100, 255, 100) : color(255, 100, 100);
    applet.fill(foodColor);
    applet.text("FOOD: " + foodCount + "/" + maxFood, applet.width - 130, 35);
    
    // Piedras
    color rockColor = rockCount > 10 ? color(100, 255, 100) : color(255, 100, 100);
    applet.fill(rockColor);
    applet.text("ROCKS: " + rockCount + "/" + maxRocks, applet.width - 130, 55);
  }
  
  /**
   * Renderiza el contador de peces
   */
  void renderFishCounter() {
    int currentFishCount = koiManager.getKoiCount();
    
    // Fondo del contador
    applet.fill(backgroundColor);
    applet.rect(20, 20, 80, 30, 5);
    
    // Texto del contador
    applet.fill(textColor);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("FISH: " + currentFishCount, 60, 35);
  }
} 