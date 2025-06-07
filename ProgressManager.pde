/**
 * ProgressManager
 * 
 * Gestor de progreso del jugador que maneja desbloqueos y persistencia.
 * Guarda/carga el progreso del jugador usando archivos locales.
 */
class ProgressManager {
  // Estados de desbloqueo
  boolean endlessModeUnlocked = false;
  boolean wavesCompleted = false;
  
  // Archivo de guardado
  String saveFileName = "koi_survival_progress.txt";
  
  /**
   * Constructor
   */
  ProgressManager() {
    loadProgress();
    println("💾 ProgressManager inicializado");
  }
  
  /**
   * Marca las waves como completadas y desbloquea Endless
   */
  void completeWaves() {
    if (!wavesCompleted) {
      wavesCompleted = true;
      endlessModeUnlocked = true;
      saveProgress();
      
      println("¡Waves completado por primera vez! Endless desbloqueado.");
    }
  }
  
  /**
   * Verifica si el modo Endless está desbloqueado
   */
  boolean isEndlessModeUnlocked() {
    return endlessModeUnlocked;
  }
  
  /**
   * Verifica si las waves han sido completadas
   */
  boolean areWavesCompleted() {
    return wavesCompleted;
  }
  
  /**
   * Fuerza el desbloqueo de Endless (para testing/debug)
   */
  void forceUnlockEndless() {
    endlessModeUnlocked = true;
    wavesCompleted = true;
    saveProgress();
    println("Endless mode desbloqueado forzadamente");
  }
  
  /**
   * Resetea todo el progreso (para testing)
   */
  void resetProgress() {
    endlessModeUnlocked = false;
    wavesCompleted = false;
    saveProgress();
    println("Progreso reseteado");
  }
  
  /**
   * Guarda el progreso en archivo
   */
  void saveProgress() {
    try {
      String[] lines = new String[2];
      lines[0] = "waves_completed=" + (wavesCompleted ? "1" : "0");
      lines[1] = "endless_unlocked=" + (endlessModeUnlocked ? "1" : "0");
      
      saveStrings("data/" + saveFileName, lines);
      println("💾 Progreso guardado");
      
    } catch (Exception e) {
      println("❌ Error guardando progreso: " + e.getMessage());
    }
  }
  
  /**
   * Carga el progreso desde archivo
   */
  void loadProgress() {
    try {
      String[] lines = loadStrings("data/" + saveFileName);
      
      if (lines != null && lines.length >= 2) {
        // Parsear waves completadas
        if (lines[0].startsWith("waves_completed=")) {
          String value = lines[0].substring("waves_completed=".length());
          wavesCompleted = value.equals("1");
        }
        
        // Parsear endless desbloqueado
        if (lines[1].startsWith("endless_unlocked=")) {
          String value = lines[1].substring("endless_unlocked=".length());
          endlessModeUnlocked = value.equals("1");
        }
        
        println("📖 Progreso cargado: Waves=" + wavesCompleted + ", Endless=" + endlessModeUnlocked);
        
      } else {
        // Primera vez jugando - crear archivo de progreso
        println("🆕 Primera vez jugando - creando progreso inicial");
        saveProgress();
      }
      
    } catch (Exception e) {
      println("📝 No hay progreso previo - empezando desde cero");
      // Valores por defecto ya establecidos
      saveProgress();
    }
  }
  
  /**
   * Obtiene información de estado para debug
   */
  String getProgressInfo() {
    return "Waves: " + (wavesCompleted ? "✅" : "❌") + 
           " | Endless: " + (endlessModeUnlocked ? "🔓" : "🔒");
  }
} 