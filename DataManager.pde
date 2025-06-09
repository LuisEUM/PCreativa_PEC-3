/**
 * Jardín Koi - DataManager
 * 
 * Sistema de gestión de datos persistentes que maneja:
 * - Puntuaciones del Hall de la Fama
 * - Configuración del usuario (nombre, volumen)
 * - Estadísticas del jugador
 */
class DataManager {
  // Archivo de datos
  String dataFile = "data/koi_survival_progress.txt";
  
  // Referencias a managers
  ProgressManager progressManager;
  
  // Datos en memoria
  ArrayList<ScoreEntry> wavesScores;
  ArrayList<ScoreEntry> endlessScores;
  UserConfig userConfig;
  
  /**
   * Constructor
   */
  DataManager() {
    initializeData();
    loadAllData();
  }
  
  /**
   * Establece la referencia al ProgressManager
   */
  void setProgressManager(ProgressManager pm) {
    this.progressManager = pm;
  }
  
  /**
   * Inicializa las estructuras de datos
   */
  void initializeData() {
    wavesScores = new ArrayList<ScoreEntry>();
    endlessScores = new ArrayList<ScoreEntry>();
    userConfig = new UserConfig();
  }
  
  /**
   * Carga todos los datos desde archivos
   */
  void loadAllData() {
    loadScores();
    loadConfig();
  }
  
  /**
   * Carga las puntuaciones desde archivo
   */
  void loadScores() {
    try {
      // Intentar cargar desde archivo
      // Por ahora, usar datos de ejemplo
      loadDefaultScores();
      println("📊 Puntuaciones cargadas (datos de ejemplo)");
    } catch (Exception e) {
      println("⚠️ Error cargando puntuaciones, usando datos por defecto");
      loadDefaultScores();
    }
  }
  
  /**
   * Carga datos de puntuaciones por defecto
   */
  void loadDefaultScores() {
    // Scores de Waves por defecto
    wavesScores.clear();
    wavesScores.add(new ScoreEntry("LuisEUM", 15750, 5, "2025-01-15", "waves"));
    wavesScores.add(new ScoreEntry("KoiMaster", 14200, 5, "2025-01-14", "waves"));
    wavesScores.add(new ScoreEntry("WaveRider", 13800, 5, "2025-01-13", "waves"));
    wavesScores.add(new ScoreEntry("AquaGuard", 12900, 4, "2025-01-12", "waves"));
    wavesScores.add(new ScoreEntry("PondHero", 11500, 4, "2025-01-11", "waves"));
    wavesScores.add(new ScoreEntry("FishSaver", 10800, 4, "2025-01-10", "waves"));
    wavesScores.add(new ScoreEntry("KoiLord", 9750, 3, "2025-01-09", "waves"));
    wavesScores.add(new ScoreEntry("WaterWise", 8900, 3, "2025-01-08", "waves"));
    wavesScores.add(new ScoreEntry("StreamKing", 7600, 3, "2025-01-07", "waves"));
    wavesScores.add(new ScoreEntry("TideWalker", 6800, 2, "2025-01-06", "waves"));
    
    // Scores de Endless por defecto
    endlessScores.clear();
    endlessScores.add(new ScoreEntry("LuisEUM", 28500, 942, "2025-01-15", "endless")); // 942 segundos = 15:42
    endlessScores.add(new ScoreEntry("EndlessOne", 25200, 868, "2025-01-14", "endless")); // 14:28
    endlessScores.add(new ScoreEntry("Survivor", 22800, 795, "2025-01-13", "endless")); // 13:15
    endlessScores.add(new ScoreEntry("TimeLord", 19900, 723, "2025-01-12", "endless")); // 12:03
    endlessScores.add(new ScoreEntry("Eternal", 17500, 645, "2025-01-11", "endless")); // 10:45
    endlessScores.add(new ScoreEntry("Infinite", 15800, 572, "2025-01-10", "endless")); // 09:32
    endlessScores.add(new ScoreEntry("Forever", 13750, 498, "2025-01-09", "endless")); // 08:18
    endlessScores.add(new ScoreEntry("Lasting", 11900, 425, "2025-01-08", "endless")); // 07:05
    endlessScores.add(new ScoreEntry("Enduring", 9600, 352, "2025-01-07", "endless")); // 05:52
    endlessScores.add(new ScoreEntry("Persistent", 7800, 279, "2025-01-06", "endless")); // 04:39
  }
  
  /**
   * Carga la configuración del usuario
   */
  void loadConfig() {
    try {
      String[] lines = loadStrings(dataFile);
      if (lines != null) {
        // Parsear el archivo
        for (String line : lines) {
          if (line.trim().length() > 0 && line.contains("=")) {
            String[] parts = line.split("=");
            if (parts.length == 2) {
              String key = parts[0].trim();
              String value = parts[1].trim();
              
              switch (key) {
                case "player_name":
                  userConfig.playerName = value;
                  break;
                case "volume":
                  userConfig.volume = Integer.parseInt(value);
                  break;
                case "games_played":
                  userConfig.gamesPlayed = Integer.parseInt(value);
                  break;
                case "best_score":
                  userConfig.bestScore = Integer.parseInt(value);
                  break;
                case "total_play_time":
                  userConfig.totalPlayTime = Integer.parseInt(value);
                  break;
              }
            }
          }
        }
        println("Configuración cargada desde archivo");
      } else {
        setDefaultConfig();
      }
    } catch (Exception e) {
      println("Error cargando configuración, usando valores por defecto");
      setDefaultConfig();
    }
  }
  
  /**
   * Establece configuración por defecto
   */
  void setDefaultConfig() {
    userConfig.playerName = "LuisEUM";
    userConfig.volume = 70;
    userConfig.gamesPlayed = 0;
    userConfig.bestScore = 0;
    userConfig.totalPlayTime = 0;
  }
  
  /**
   * Guarda todas las puntuaciones
   */
  void saveScores() {
    try {
      // TODO: Implementar guardado real a archivo JSON
      println("💾 Puntuaciones guardadas (simulado)");
    } catch (Exception e) {
      println("❌ Error guardando puntuaciones: " + e.getMessage());
    }
  }
  
  /**
   * Guarda la configuración del usuario
   */
  void saveConfig() {
    try {
      // Crear contenido del archivo
      String[] lines = {
        "waves_completed=" + (progressManager != null ? (progressManager.areWavesCompleted() ? 1 : 0) : 1),
        "endless_unlocked=" + (progressManager != null ? (progressManager.isEndlessModeUnlocked() ? 1 : 0) : 1),
        "player_name=" + userConfig.playerName,
        "volume=" + userConfig.volume,
        "games_played=" + userConfig.gamesPlayed,
        "best_score=" + userConfig.bestScore,
        "total_play_time=" + userConfig.totalPlayTime,
        ""
      };
      
      saveStrings(dataFile, lines);
      println("Configuración guardada en: " + dataFile);
    } catch (Exception e) {
      println("Error guardando configuración: " + e.getMessage());
    }
  }
  
  /**
   * Añade una nueva puntuación
   */
  void addScore(String playerName, int score, int waveOrTime, String gameMode) {
    String date = getCurrentDate();
    ScoreEntry newScore = new ScoreEntry(playerName, score, waveOrTime, date, gameMode);
    
    if (gameMode.equals("waves")) {
      wavesScores.add(newScore);
      sortScoresByScore(wavesScores);
      // Mantener solo top 10
      if (wavesScores.size() > 10) {
        wavesScores.remove(wavesScores.size() - 1);
      }
    } else if (gameMode.equals("endless")) {
      endlessScores.add(newScore);
      sortScoresByScore(endlessScores);
      // Mantener solo top 10
      if (endlessScores.size() > 10) {
        endlessScores.remove(endlessScores.size() - 1);
      }
    }
    
    saveScores();
    println("🏆 Nueva puntuación añadida: " + playerName + " - " + score + " pts (" + gameMode + ")");
  }
  
  /**
   * Ordena las puntuaciones por score (mayor a menor)
   */
  void sortScoresByScore(ArrayList<ScoreEntry> scores) {
    scores.sort((a, b) -> Integer.compare(b.score, a.score));
  }
  
  /**
   * Obtiene las puntuaciones de Waves
   */
  ArrayList<ScoreEntry> getWavesScores() {
    return wavesScores;
  }
  
  /**
   * Obtiene las puntuaciones de Endless
   */
  ArrayList<ScoreEntry> getEndlessScores() {
    return endlessScores;
  }
  
  /**
   * Obtiene la configuración del usuario
   */
  UserConfig getUserConfig() {
    return userConfig;
  }
  
  /**
   * Actualiza el nombre del jugador
   */
  void updatePlayerName(String newName) {
    userConfig.playerName = newName;
    saveConfig();
  }
  
  /**
   * Actualiza el volumen
   */
  void updateVolume(int newVolume) {
    userConfig.volume = constrain(newVolume, 0, 100);
    saveConfig();
  }
  
  /**
   * Incrementa el contador de partidas jugadas
   */
  void incrementGamesPlayed() {
    userConfig.gamesPlayed++;
    saveConfig();
  }
  
  /**
   * Actualiza la mejor puntuación si es necesario
   */
  void updateBestScore(int score) {
    if (score > userConfig.bestScore) {
      userConfig.bestScore = score;
      saveConfig();
    }
  }
  
  /**
   * Añade tiempo de juego
   */
  void addPlayTime(int seconds) {
    userConfig.totalPlayTime += seconds;
    saveConfig();
  }
  
  /**
   * Obtiene la fecha actual en formato string
   */
  String getCurrentDate() {
    return year() + "-" + nf(month(), 2) + "-" + nf(day(), 2);
  }
  
  /**
   * Formatea tiempo en segundos a MM:SS
   */
  String formatTime(int seconds) {
    int minutes = seconds / 60;
    int secs = seconds % 60;
    return nf(minutes, 2) + ":" + nf(secs, 2);
  }
  
  /**
   * Formatea tiempo de juego total en horas y minutos
   */
  String formatTotalPlayTime() {
    int hours = userConfig.totalPlayTime / 3600;
    int minutes = (userConfig.totalPlayTime % 3600) / 60;
    return hours + "h " + minutes + "m";
  }
  
  /**
   * Obtiene estadísticas de peces salvados por tamaño desde el WavesManager
   */
  int[] getKoiStatsBySize(WavesManager wavesManager) {
    if (wavesManager == null || wavesManager.koiManager == null) {
      return new int[]{3, 5, 4, 2, 1}; // Datos por defecto
    }
    
    // TODO: Implementar conteo real por tamaños cuando esté disponible
    // Por ahora retornar datos de ejemplo
    return new int[]{3, 5, 4, 2, 1};
  }
  
  /**
   * Obtiene estadísticas de enemigos derrotados por tipo
   */
  int[] getEnemyStatsByType(WavesManager wavesManager) {
    if (wavesManager == null || wavesManager.enemyManager == null) {
      return new int[]{15, 8, 4, 1}; // Datos por defecto
    }
    
    // TODO: Implementar conteo real por tipos cuando esté disponible
    // Por ahora retornar datos de ejemplo
    return new int[]{15, 8, 4, 1};
  }
  
  /**
   * Obtiene el número total de koi actualmente vivos
   */
  int getCurrentKoiCount(WavesManager wavesManager) {
    if (wavesManager == null || wavesManager.koiManager == null) {
      return 5; // Valor por defecto
    }
    
    return wavesManager.koiManager.getKoiCount();
  }
  
  /**
   * Obtiene el número total de enemigos derrotados en la sesión actual
   */
  int getCurrentEnemiesDefeated(WavesManager wavesManager) {
    if (wavesManager == null || wavesManager.enemyManager == null) {
      return 28; // Valor por defecto
    }
    
    // TODO: Implementar contador real cuando esté disponible
    return 28;
  }
}

/**
 * Clase para representar una entrada de puntuación
 */
class ScoreEntry {
  String playerName;
  int score;
  int waveOrTime; // Oleadas completadas para Waves, tiempo en segundos para Endless
  String date;
  String gameMode;
  
  ScoreEntry(String playerName, int score, int waveOrTime, String date, String gameMode) {
    this.playerName = playerName;
    this.score = score;
    this.waveOrTime = waveOrTime;
    this.date = date;
    this.gameMode = gameMode;
  }
  
  /**
   * Obtiene el tiempo formateado para modo Endless
   */
  String getFormattedTime() {
    if (gameMode.equals("endless")) {
      int minutes = waveOrTime / 60;
      int seconds = waveOrTime % 60;
      return nf(minutes, 2) + ":" + nf(seconds, 2);
    }
    return waveOrTime + "/5"; // Para waves
  }
}

/**
 * Clase para la configuración del usuario
 */
class UserConfig {
  String playerName = "LuisEUM";
  int volume = 70;
  int gamesPlayed = 0;
  int bestScore = 0;
  int totalPlayTime = 0; // En segundos
  
  UserConfig() {
    // Constructor por defecto
  }
} 