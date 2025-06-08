// Importación de la librería Sound (ya instalada)
import processing.sound.*;

/**
 * Clase MusicManager
 * 
 * Gestiona la música de fondo del juego con diferentes pistas
 * según el modo de juego activo.
 * 
 * NOTA: Para habilitar música, instala la librería "Sound" desde:
 * Tools > Manage Tools > Libraries > Buscar "Sound" > Instalar
 * Luego descomenta la línea de import arriba.
 */
class MusicManager {
  SoundFile gameMusic;    // Música para Waves y Endless
  SoundFile zenMusic;     // Música para Zen  
  SoundFile currentMusic; // Música actualmente reproduciéndose
  
  String currentMode = "";
  boolean isMuted = false;
  float volume = 0.5; // Volumen por defecto (50%)
  
  /**
   * Constructor - Carga los archivos de música
   */
  MusicManager(PApplet parent) {
    try {
      // Cargar archivos de música desde la carpeta assets/
      gameMusic = new SoundFile(parent, "assets/KoiGarden_Game.mp3");
      zenMusic = new SoundFile(parent, "assets/KoiGarden_Zen.mp3");
      println("🎵 MusicManager: Archivos de música cargados exitosamente desde assets/");
      
    } catch (Exception e) {
      println("❌ Error cargando archivos de música: " + e.getMessage());
      println("💡 Verifica que los archivos estén en la carpeta assets/");
      gameMusic = null;
      zenMusic = null;
    }
  }
  
  /**
   * Cambia la música según el modo de juego
   */
  void setGameMode(String mode) {
    if (mode.equals(currentMode)) {
      return; // Ya está reproduciendo la música correcta
    }
    
    // Detener música actual si existe
    stopCurrentMusic();
    
    // Seleccionar nueva música según el modo
    SoundFile newMusic = null;
    switch (mode.toLowerCase()) {
      case "zen":
        newMusic = zenMusic;
        println("🧘 Cambiando a música Zen");
        break;
      case "waves":
      case "endless":
      case "menu":
      default:
        newMusic = gameMusic;
        println("🎮 Cambiando a música de juego");
        break;
    }
    
    // Reproducir nueva música si está disponible
    if (newMusic != null && !isMuted) {
      currentMusic = newMusic;
      currentMusic.amp(volume);
      currentMusic.loop();
      println("🎵 Reproduciendo música en bucle - Modo: " + mode);
    }
    
    currentMode = mode;
  }
  
  /**
   * Detiene la música actual
   */
  void stopCurrentMusic() {
    if (currentMusic != null) {
      if (currentMusic.isPlaying()) {
        currentMusic.stop();
      }
      println("⏹️ Música detenida");
    }
    currentMusic = null;
  }
  
  /**
   * Pausa la música actual
   */
  void pauseMusic() {
    if (currentMusic != null) {
      if (currentMusic.isPlaying()) {
        currentMusic.pause();
      }
      println("⏸️ Música pausada");
    }
  }
  
  /**
   * Reanuda la música pausada
   */
  void resumeMusic() {
    if (currentMusic != null && !isMuted) {
      if (!currentMusic.isPlaying()) {
        currentMusic.play();
      }
      println("▶️ Música reanudada");
    }
  }
  
  /**
   * Activa/desactiva el silencio
   */
  void toggleMute() {
    isMuted = !isMuted;
    
    if (isMuted) {
      stopCurrentMusic();
      println("🔇 Música silenciada");
    } else {
      // Reactivar música del modo actual
      setGameMode(currentMode);
      println("🔊 Música reactivada");
    }
  }
  
  /**
   * Establece el volumen (0.0 a 1.0)
   */
  void setVolume(float newVolume) {
    volume = constrain(newVolume, 0.0, 1.0);
    
    if (currentMusic != null) {
      if (currentMusic.isPlaying()) {
        currentMusic.amp(volume);
      }
    }
    
    println("🔊 Volumen ajustado a: " + (volume * 100) + "%");
  }
  
  /**
   * Aumenta el volumen
   */
  void volumeUp() {
    setVolume(volume + 0.1);
  }
  
  /**
   * Disminuye el volumen
   */
  void volumeDown() {
    setVolume(volume - 0.1);
  }
  
  /**
   * Obtiene el volumen actual
   */
  float getVolume() {
    return volume;
  }
  
  /**
   * Verifica si la música está silenciada
   */
  boolean isMuted() {
    return isMuted;
  }
  
  /**
   * Verifica si hay música reproduciéndose
   */
  boolean isPlaying() {
    if (currentMusic != null) {
      return currentMusic.isPlaying();
    }
    return false;
  }
  
  /**
   * Obtiene el modo de música actual
   */
  String getCurrentMode() {
    return currentMode;
  }
  
  /**
   * Limpia recursos al cerrar la aplicación
   */
  void dispose() {
    stopCurrentMusic();
    
    if (gameMusic != null) {
      gameMusic.stop();
    }
    if (zenMusic != null) {
      zenMusic.stop();
    }
    
    println("🎵 MusicManager: Recursos liberados");
  }
} 