/**
 * Clase EndlessUIManager
 * 
 * Gestiona la interfaz de usuario para el Modo Endless.
 * Sin botones de creación, solo información de supervivencia.
 */
class EndlessUIManager {
  PApplet applet;
  KoiManager koiManager;
  
  // Sistema de tiempo
  float startTime;
  
  // Sistema de puntuación
  int score;
  int fishFed;
  int enemiesKilled;
  
  // Sistema de recursos
  int foodCount;
  int rockCount;
  int maxFood;
  int maxRocks;
  
  // Colores
  color textColor = color(255, 255, 255);
  color backgroundColor = color(0, 0, 0, 120);
  
  /**
   * Constructor
   */
  EndlessUIManager(PApplet applet, KoiManager koiManager) {
    this.applet = applet;
    this.koiManager = koiManager;
    
    // Inicializar tiempo
    this.startTime = millis();
    
    // Inicializar puntuación
    this.score = 0;
    this.fishFed = 0;
    this.enemiesKilled = 0;
    
    // Inicializar recursos limitados
    this.maxFood = 50;
    this.maxRocks = 30;
    this.foodCount = maxFood;
    this.rockCount = maxRocks;
  }
  
  /**
   * Actualiza la UI
   */
  void update() {
    // Calcular puntuación por tiempo sobrevivido
    float timeAlive = (millis() - startTime) / 1000.0; // segundos
    int timeScore = (int)(timeAlive / 10); // 1 punto cada 10 segundos
    
    // Puntuación total
    score = (fishFed * 10) + (enemiesKilled * 50) + timeScore;
  }
  
  /**
   * Maneja los clics del ratón
   */
  boolean handleClick(float mouseX, float mouseY) {
    // No hay botones que manejar en Endless mode
    return false;
  }
  
  /**
   * Usa comida (devuelve true si se pudo usar)
   */
  boolean useFood() {
    if (foodCount > 0) {
      foodCount--;
      fishFed++;
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
   * Registra un enemigo eliminado
   */
  void killEnemy() {
    enemiesKilled++;
  }
  
  /**
   * Renderiza todos los elementos de la UI
   */
  void render() {
    renderTimer();
    renderScore();
    renderResources();
    renderFishCounter();
  }
  
  /**
   * Renderiza el reloj contando hacia arriba
   */
  void renderTimer() {
    float timeAlive = (millis() - startTime) / 1000.0;
    int minutes = (int)(timeAlive / 60);
    int seconds = (int)(timeAlive % 60);
    
    String timeString = nf(minutes, 2) + ":" + nf(seconds, 2);
    
    // Fondo del timer
    applet.fill(backgroundColor);
    applet.noStroke();
    applet.rect(applet.width/2 - 40, 20, 80, 30, 5);
    
    // Texto del timer
    applet.fill(textColor);
    applet.textSize(16);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text(timeString, applet.width/2, 35);
  }
  
  /**
   * Renderiza la puntuación
   */
  void renderScore() {
    String scoreText = "SCORE: " + score;
    
    // Fondo de la puntuación
    applet.fill(backgroundColor);
    applet.rect(20, 60, 120, 25, 5);
    
    // Texto de la puntuación
    applet.fill(textColor);
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text(scoreText, 30, 72);
    
    // Desglose de puntuación (más pequeño)
    applet.textSize(10);
    applet.text("Fish: " + fishFed + " | Enemies: " + enemiesKilled, 30, 90);
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
    color foodColor = foodCount > 10 ? color(100, 255, 100) : color(255, 100, 100);
    applet.fill(foodColor);
    applet.text("FOOD: " + foodCount + "/" + maxFood, applet.width - 130, 35);
    
    // Piedras
    color rockColor = rockCount > 5 ? color(100, 255, 100) : color(255, 100, 100);
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