/**
 * Jardín Koi  - InstructionsScreen
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
  Button backButton;
  
  /**
   * Constructor
   */
  InstructionsScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    initializeUI();
    println("📋 InstructionsScreen creado");
  }
  
  /**
   * Inicializa la interfaz de usuario
   */
  void initializeUI() {
    float buttonWidth = 150;
    float buttonHeight = 40;
    
    backButton = new Button(
      width/2 - buttonWidth/2,
      height - 80,
      buttonWidth,
      buttonHeight,
      "🔙 Back to Menu"
    );
    
    // Personalizar colores del botón
    backButton.buttonColor = color(80, 80, 100);
    backButton.hoverColor = color(100, 100, 120);
    backButton.textColor = color(255);
  }
  
  /**
   * Actualiza la pantalla de instrucciones
   */
  void update() {
    backButton.update(mouseX, mouseY);
  }
  
  /**
   * Renderiza la pantalla de instrucciones
   */
  void render() {
    background(30, 30, 40);
    
    // Título
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("📋 INSTRUCTIONS", width/2, 80);
    
    // Contenido temporal
    textSize(16);
    text("Instructions screen coming in Phase 5!", width/2, height/2);
    
    // Renderizar botón de regreso
    renderButton(backButton);
  }
  
  /**
   * Renderiza un botón
   */
  void renderButton(Button button) {
    // Color del botón
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Sombra
    fill(0, 0, 0, 100);
    noStroke();
    rect(button.position.x + 3, button.position.y + 3, button.width, button.height, 8);
    
    // Botón principal
    fill(currentColor);
    rect(button.position.x, button.position.y, button.width, button.height, 8);
    
    // Borde
    if (button.isHovered) {
      stroke(255, 255, 255, 150);
      strokeWeight(2);
      noFill();
      rect(button.position.x, button.position.y, button.width, button.height, 8);
    }
    
    // Texto
    fill(button.textColor);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Maneja los clics del ratón
   */
  void handleClick(float mouseX, float mouseY) {
    if (backButton.isClicked(mouseX, mouseY)) {
      println("🔙 Volviendo al menú principal...");
      screenManager.returnToMenu();
    }
  }
} 