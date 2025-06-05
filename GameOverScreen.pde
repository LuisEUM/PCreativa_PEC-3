/**
 * KOI SURVIVAL - GameOverScreen (Placeholder)
 * 
 * Pantalla de derrota para los modos Waves y Endless.
 * 
 * PLACEHOLDER: Esta es una implementación temporal para evitar errores de compilación.
 * Será expandida completamente en la Fase 6 del desarrollo.
 * 
 * FUNCIONALIDADES FUTURAS:
 * - Estadísticas finales de la partida
 * - Comparación con records personales
 * - Opciones de reinicio o menú principal
 * - Animaciones de derrota
 */

class GameOverScreen {
  ScreenManager screenManager;
  
  /**
   * Constructor placeholder
   */
  GameOverScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    println("💀 GameOverScreen creado (placeholder)");
  }
  
  /**
   * Renderizado placeholder
   */
  void render() {
    // Pantalla temporal de game over
    background(60, 20, 20);
    
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("💀 GAME OVER", width/2, height/2 - 40);
    
    textSize(16);
    text("Game Over screen coming in Phase 6!", width/2, height/2);
    
    textSize(12);
    text("Press ESC to return to menu", width/2, height/2 + 40);
  }
} 