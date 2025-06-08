/**
 * Jardín Koi  - ScoreManager
 * 
 * Gestor del sistema de puntuación y records para los diferentes modos de juego.
 * Maneja puntuaciones, multiplicadores, estadísticas y guardado de records.
 * 
 * CARACTERÍSTICAS:
 * - Records separados por modo (Waves, Endless, Zen)
 * - Sistema de multiplicadores por ronda/tiempo
 * - Estadísticas detalladas por sesión
 * - Guardado local de records personales
 * 
 * SISTEMA DE PUNTUACIÓN:
 * - Waves: Puntos por supervivientes + bonus + multiplicadores por ronda
 * - Endless: Puntos por tiempo + depredadores + multiplicadores temporales
 * - Zen: Sin puntuación (enfoque en creatividad)
 * 
 * CÓDIGO ORIGINAL: 100% (nueva implementación para el sistema de puntuación)
 */

class ScoreManager {
  // Records por modo
  int wavesRecord;
  int endlessRecord;
  
  // Puntuación actual
  int currentScore;
  int roundScore;      // Solo para Waves
  float multiplier;    // Multiplicador activo
  
  // Estadísticas de sesión
  int koiSaved;
  int predatorsDefeated;
  int koiGrown;
  long sessionStartTime;
  
  int totalScore = 0;
  int koiScore = 0;
  int enemyScore = 0;
  int powerUpScore = 0;
  
  // Estadísticas detalladas
  int totalKoiCollected = 0;
  int totalEnemiesDefeated = 0;
  int totalPowerUpsCollected = 0;
  
  // Desglose por tamaño
  int smallKoiCollected = 0;
  int mediumKoiCollected = 0;
  int largeKoiCollected = 0;
  
  int smallEnemiesDefeated = 0;
  int mediumEnemiesDefeated = 0;
  int largeEnemiesDefeated = 0;
  int sharkEnemiesDefeated = 0;
  
  // Multiplicadores por tamaño
  final int SMALL_KOI_POINTS = 100;
  final int MEDIUM_KOI_POINTS = 200;
  final int LARGE_KOI_POINTS = 300;
  
  final int SMALL_ENEMY_POINTS = 150;
  final int MEDIUM_ENEMY_POINTS = 300;
  final int LARGE_ENEMY_POINTS = 500;
  final int SHARK_ENEMY_POINTS = 1000;
  
  final int POWER_UP_POINTS = 50;
  
  /**
   * Constructor
   */
  ScoreManager() {
    // Inicializar con valores por defecto
    this.wavesRecord = 0;
    this.endlessRecord = 0;
    this.currentScore = 0;
    this.roundScore = 0;
    this.multiplier = 1.0;
    this.sessionStartTime = millis();
    
    // Cargar records guardados (futuro)
    loadRecords();
    
    println("📊 ScoreManager inicializado");
  }
  
  /**
   * Reinicia la puntuación para una nueva partida
   */
  void resetScore() {
    this.currentScore = 0;
    this.roundScore = 0;
    this.multiplier = 1.0;
    this.koiSaved = 0;
    this.predatorsDefeated = 0;
    this.koiGrown = 0;
    this.sessionStartTime = millis();
  }
  
  /**
   * Añade puntos al marcador actual
   */
  void addPoints(int points) {
    int finalPoints = round(points * multiplier);
    this.currentScore += finalPoints;
    this.roundScore += finalPoints;
  }
  
  /**
   * Establece el multiplicador actual
   */
  void setMultiplier(float multiplier) {
    this.multiplier = multiplier;
  }
  
  /**
   * Incrementa estadísticas específicas
   */
  void addKoiSaved(int count) {
    this.koiSaved += count;
  }
  
  void addPredatorDefeated() {
    this.predatorsDefeated++;
  }
  
  void addKoiGrown() {
    this.koiGrown++;
  }
  
  /**
   * Finaliza una ronda (solo Waves)
   */
  void completeRound() {
    // Futuro: bonus por completar ronda
    this.roundScore = 0; // Reset para nueva ronda
  }
  
  /**
   * Finaliza una partida y actualiza records
   */
  void endGame(String mode) {
    switch(mode.toLowerCase()) {
      case "waves":
        if (currentScore > wavesRecord) {
          wavesRecord = currentScore;
          println("🏆 ¡Nuevo record en Modo Waves: " + wavesRecord + "!");
        }
        break;
        
      case "endless":
        if (currentScore > endlessRecord) {
          endlessRecord = currentScore;
          println("🏆 ¡Nuevo record en Modo Endless: " + endlessRecord + "!");
        }
        break;
    }
    
    // Guardar records (futuro)
    saveRecords();
  }
  
  /**
   * Obtiene el record para un modo específico
   */
  int getRecord(String mode) {
    switch(mode.toLowerCase()) {
      case "waves": return wavesRecord;
      case "endless": return endlessRecord;
      default: return 0;
    }
  }
  
  /**
   * Obtiene la puntuación actual
   */
  int getCurrentScore() {
    return currentScore;
  }
  
  /**
   * Obtiene el multiplicador actual
   */
  float getMultiplier() {
    return multiplier;
  }
  
  /**
   * Obtiene estadísticas de la sesión
   */
  String getSessionStats() {
    long sessionTime = (millis() - sessionStartTime) / 1000;
    return "Tiempo: " + sessionTime + "s • Koi salvados: " + koiSaved + 
           " • Depredadores: " + predatorsDefeated + " • Koi crecidos: " + koiGrown;
  }
  
  /**
   * Carga records guardados del disco (futuro)
   */
  void loadRecords() {
    // Futuro: cargar desde archivo local
    // Por ahora usar valores por defecto
  }
  
  /**
   * Guarda records al disco (futuro)
   */
  void saveRecords() {
    // Futuro: guardar en archivo local
    println("💾 Records guardados: Waves=" + wavesRecord + ", Endless=" + endlessRecord);
  }
  
  void addKoiScore(float koiSize) {
    int points;
    if (koiSize <= 15) {
      points = SMALL_KOI_POINTS;
      smallKoiCollected++;
    } else if (koiSize <= 25) {
      points = MEDIUM_KOI_POINTS;
      mediumKoiCollected++;
    } else {
      points = LARGE_KOI_POINTS;
      largeKoiCollected++;
    }
    
    koiScore += points;
    totalScore += points;
    totalKoiCollected++;
  }
  
  void addEnemyScore(String enemyType) {
    int points;
    switch (enemyType) {
      case "SMALL_CATFISH":
        points = SMALL_ENEMY_POINTS;
        smallEnemiesDefeated++;
        break;
      case "MEDIUM_CARP":
        points = MEDIUM_ENEMY_POINTS;
        mediumEnemiesDefeated++;
        break;
      case "LARGE_PIKE":
        points = LARGE_ENEMY_POINTS;
        largeEnemiesDefeated++;
        break;
      case "SHARK":
        points = SHARK_ENEMY_POINTS;
        sharkEnemiesDefeated++;
        break;
      default:
        points = 0;
    }
    
    enemyScore += points;
    totalScore += points;
    totalEnemiesDefeated++;
  }
  
  void addPowerUpScore() {
    powerUpScore += POWER_UP_POINTS;
    totalScore += POWER_UP_POINTS;
    totalPowerUpsCollected++;
  }
  
  void renderScoreBreakdown(float x, float y) {
    textAlign(LEFT);
    textSize(16);
    fill(255);
    
    text("Puntuación Total: " + totalScore, x, y);
    text("Koi Recolectados: " + totalKoiCollected, x, y + 30);
    text("  - Pequeños: " + smallKoiCollected + " (" + (smallKoiCollected * SMALL_KOI_POINTS) + " pts)", x + 20, y + 50);
    text("  - Medianos: " + mediumKoiCollected + " (" + (mediumKoiCollected * MEDIUM_KOI_POINTS) + " pts)", x + 20, y + 70);
    text("  - Grandes: " + largeKoiCollected + " (" + (largeKoiCollected * LARGE_KOI_POINTS) + " pts)", x + 20, y + 90);
    
    text("Enemigos Derrotados: " + totalEnemiesDefeated, x, y + 130);
    text("  - Bagres: " + smallEnemiesDefeated + " (" + (smallEnemiesDefeated * SMALL_ENEMY_POINTS) + " pts)", x + 20, y + 150);
    text("  - Carpas: " + mediumEnemiesDefeated + " (" + (mediumEnemiesDefeated * MEDIUM_ENEMY_POINTS) + " pts)", x + 20, y + 170);
    text("  - Lucios: " + largeEnemiesDefeated + " (" + (largeEnemiesDefeated * LARGE_ENEMY_POINTS) + " pts)", x + 20, y + 190);
    text("  - Tiburones: " + sharkEnemiesDefeated + " (" + (sharkEnemiesDefeated * SHARK_ENEMY_POINTS) + " pts)", x + 20, y + 210);
    
    text("Power-ups Recolectados: " + totalPowerUpsCollected + " (" + powerUpScore + " pts)", x, y + 250);
  }
  
  void renderSimpleScore(float x, float y) {
    textAlign(LEFT);
    textSize(16);
    fill(255);
    
    text("Puntuación Total: " + totalScore, x, y);
    text("Koi Vivos: " + totalKoiCollected, x, y + 30);
    text("Enemigos Derrotados: " + totalEnemiesDefeated, x, y + 60);
  }
  
  void reset() {
    totalScore = 0;
    koiScore = 0;
    enemyScore = 0;
    powerUpScore = 0;
    totalKoiCollected = 0;
    totalEnemiesDefeated = 0;
    totalPowerUpsCollected = 0;
    smallKoiCollected = 0;
    mediumKoiCollected = 0;
    largeKoiCollected = 0;
    smallEnemiesDefeated = 0;
    mediumEnemiesDefeated = 0;
    largeEnemiesDefeated = 0;
    sharkEnemiesDefeated = 0;
  }
} 