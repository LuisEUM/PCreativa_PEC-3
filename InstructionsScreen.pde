/**
 * KOI SURVIVAL - InstructionsScreen (Placeholder)
 * 
 * Pantalla de instrucciones que explica los controles y mecánicas del juego.
 * 
 * PLACEHOLDER: Esta es una implementación temporal para evitar errores de compilación.
 * Será expandida completamente en la Fase 5 del desarrollo.
 * 
 * FUNCIONALIDADES FUTURAS:
 * - Explicación detallada de cada modo de juego
 * - Tabla de controles por modo
 * - Información sobre mecánicas de supervivencia
 * - Navegación con botones
 */

class InstructionsScreen {
  ScreenManager screenManager;
  
  /**
   * Constructor placeholder
   */
  InstructionsScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    println("📋 InstructionsScreen creado (placeholder)");
  }
  
  /**
   * Renderizado placeholder
   */
  void render() {
    // Pantalla temporal de instrucciones
    background(30, 30, 40);
    
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("📋 INSTRUCTIONS", width/2, 80);
    
    textSize(16);
    text("Instructions screen coming in Phase 5!", width/2, height/2);
    
    textSize(12);
    text("Press ESC to return to menu", width/2, height - 40);
  }
} 