/**
 * Jardín Koi  - GameManager (Placeholder)
 * 
 * Gestor para el Modo Waves - 5 rondas con oleadas programadas.
 * 
 * PLACEHOLDER: Esta es una implementación temporal para evitar errores de compilación.
 * Será expandida completamente en la Fase 4 del desarrollo.
 * 
 * FUNCIONALIDADES FUTURAS:
 * - Gestión de 5 rondas de 2 minutos cada una
 * - Oleadas programadas de depredadores
 * - Sistema de mejoras entre rondas
 * - Recursos limitados (rocas y comida)
 * - Puntuación por supervivientes
 */

class GameManager {
  ScreenManager screenManager;
  boolean initialized;
  
  /**
   * Constructor placeholder
   */
  GameManager(ScreenManager screenManager) {
    this.screenManager = screenManager;
    this.initialized = false;
    println("🌊 GameManager creado (placeholder)");
  }
  
  /**
   * Actualización placeholder
   */
  void update() {
    if (!initialized) {
      // Mensaje temporal
      println("🌊 Modo Waves aún no implementado - Fase 4");
      initialized = true;
    }
  }
  
  /**
   * Renderizado placeholder
   */
  void render() {
    // Pantalla temporal para Modo Waves
    background(20, 40, 80);
    
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("🌊 WAVES MODE", width/2, height/2 - 40);
    
    textSize(16);
    text("Coming in Phase 4!", width/2, height/2);
    
    textSize(12);
    text("Press ESC to return to menu", width/2, height/2 + 40);
    text("Press SPACE to pause", width/2, height/2 + 60);
  }
  
  /**
   * Manejo de clics placeholder
   */
  void handleClick(float mouseX, float mouseY, int mouseButton) {
    // Placeholder - no implementado aún
  }
} 