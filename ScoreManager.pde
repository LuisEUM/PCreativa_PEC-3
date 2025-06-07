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
} 