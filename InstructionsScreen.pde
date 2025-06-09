/**
 * Jardín Koi  - InstructionsScreen
 * 
 * Pantalla de instrucciones que explica los controles y mecánicas del juego.
 * Proporciona información sobre los tres modos disponibles y controles universales.
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
  
  // Variables visuales
  color backgroundColor = color(20, 30, 40);
  color titleColor = color(100, 200, 255);
  color sectionColor = color(255, 215, 0);
  color textColor = color(255, 255, 255);
  color accentColor = color(100, 255, 100);
  
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
      width - buttonWidth - 30,
      height - 60,
      buttonWidth,
      buttonHeight,
      "VOLVER"
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
    background(backgroundColor);
    
    // Título principal
    renderTitle();
    
    // Contenido principal
    renderContent();
    
    // Renderizar botón de regreso
    renderButton(backButton);
  }
  
  /**
   * Renderiza el título
   */
  void renderTitle() {
    fill(titleColor);
    textAlign(CENTER);
    textSize(32);
    text("INSTRUCCIONES", width/2, 50);
    
    textSize(14);
    fill(textColor, 200);
    text("Guía completa para dominar el Jardín Koi", width/2, 75);
  }
  
  /**
   * Renderiza el contenido de las instrucciones
   */
  void renderContent() {
    float startY = 100;
    float lineHeight = 16;
    float sectionSpacing = 25;
    int line = 0;
    
    textAlign(LEFT);
    
    // MODOS DE JUEGO
    textSize(16);
    fill(sectionColor);
    text("MODOS DE JUEGO:", 40, startY + line * lineHeight);
    line += 2;
    
    textSize(12);
    fill(accentColor);
    text("• MODO WAVES:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Sobrevive 5 oleadas de enemigos con recursos limitados", 160, startY + line * lineHeight);
    line++;
    
    fill(accentColor);
    text("• MODO ENDLESS:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Supervivencia infinita con dificultad creciente", 160, startY + line * lineHeight);
    line++;
    
    fill(accentColor);
    text("• MODO ZEN:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Simulación pacífica para crear y personalizar koi", 160, startY + line * lineHeight);
    line += 2;
    
    // CONTROLES UNIVERSALES
    textSize(16);
    fill(sectionColor);
    text("⌨CONTROLES UNIVERSALES:", 40, startY + line * lineHeight);
    line += 2;
    
    textSize(12);
    fill(accentColor);
    text("• ESPACIO / P:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Pausar/Reanudar juego", 160, startY + line * lineHeight);
    line++;
    
    fill(accentColor);
    text("• ESC:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Volver al menú principal", 160, startY + line * lineHeight);
    line++;
    
    fill(accentColor);
    text("• M:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Silenciar/Activar música", 160, startY + line * lineHeight);
    line += 2;
    
    // CONTROLES DE GAMEPLAY
    textSize(16);
    fill(sectionColor);
    text("CONTROLES DE GAMEPLAY:", 40, startY + line * lineHeight);
    line += 2;
    
    textSize(12);
    fill(accentColor);
    text("• CLIC IZQUIERDO:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Alimentar koi (atrae a los peces)", 180, startY + line * lineHeight);
    line++;
    
    fill(accentColor);
    text("• CLIC DERECHO:", 60, startY + line * lineHeight);
    fill(textColor);
    text("Lanzar rocas (repele peces y daña enemigos)", 180, startY + line * lineHeight);
    line += 2;
    
    // MECÁNICAS BÁSICAS
    textSize(16);
    fill(sectionColor);
    text("MECÁNICAS BÁSICAS:", 40, startY + line * lineHeight);
    line += 2;
    
    textSize(12);
    fill(textColor);
    text("• Los koi crecen cada 10 comidas consumidas", 60, startY + line * lineHeight);
    line++;
    text("• Los enemigos reducen el nivel de los koi al atacar", 60, startY + line * lineHeight);
    line++;
    text("• Los recursos son limitados (comida y rocas)", 60, startY + line * lineHeight);
    line++;
    text("• Los power-ups aparecen periódicamente en burbujas", 60, startY + line * lineHeight);
    line += 2;
    
    // NIVELES DE KOI
    textSize(16);
    fill(sectionColor);
    text("NIVELES DE KOI:", 40, startY + line * lineHeight);
    line += 2;
    
    textSize(12);
    fill(textColor);
    text("XS (10px) → S (15px) → M (20px) → L (28px) → XL (35px)", 60, startY + line * lineHeight);
    line++;
    text("Los koi más grandes son más resistentes a los enemigos", 60, startY + line * lineHeight);
    line += 2;
    
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