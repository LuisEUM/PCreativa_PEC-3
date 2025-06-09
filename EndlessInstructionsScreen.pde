/**
 * EndlessInstructionsScreen
 * 
 * Pantalla de instrucciones específicas para el modo Endless
 * que se muestra antes de comenzar el juego.
 */
class EndlessInstructionsScreen {
  ScreenManager screenManager;
  Button playButton;
  Button backButton;
  
  /**
   * Constructor
   */
  EndlessInstructionsScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    setupButtons();
  }
  
  /**
   * Configura los botones
   */
  void setupButtons() {
    float buttonWidth = 120;
    float buttonHeight = 40;
    
    // Botón Play centrado en la parte inferior
    playButton = new Button(width - buttonWidth - 30, height - 60, buttonWidth, buttonHeight, "JUGAR");
    playButton.setColors(color(76, 175, 80), color(129, 199, 132), color(255));
    
    // Botón Back en la esquina inferior izquierda
    backButton = new Button(30, height - 60, 100, 35, "VOLVER");
    backButton.setColors(color(158, 158, 158), color(189, 189, 189), color(255));
  }
  
  /**
   * Actualiza la pantalla
   */
  void update() {
    playButton.update(mouseX, mouseY);
    backButton.update(mouseX, mouseY);
  }
  
  /**
   * Renderiza la pantalla
   */
  void render() {
    // Fondo
    background(10, 20, 35);
    
    // Título
    fill(255, 100, 255);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("MODO ENDLESS", width/2, 50);
    
    // Subtítulo
    fill(255);
    textSize(14);
    text("Supervivencia Infinita", width/2, 75);
    
    // Instrucciones principales
    textAlign(LEFT, TOP);
    textSize(12);
    float startY = 110;
    float lineHeight = 18;
    int line = 0;
    
    fill(255, 255, 0);
    text("OBJETIVO:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• Sobrevive el mayor tiempo posible", 70, startY + line++ * lineHeight);
    text("• Obtén la puntuación más alta", 70, startY + line++ * lineHeight);
    text("• Enfrenta oleadas infinitas de enemigos", 70, startY + line++ * lineHeight);
    line++;
    
    fill(255, 255, 0);
    text("CONTROLES:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• CLIC IZQUIERDO: Alimentar koi (consume comida)", 70, startY + line++ * lineHeight);
    text("• CLIC DERECHO: Lanzar rocas contra enemigos (consume rocas)", 70, startY + line++ * lineHeight);
    text("• ESPACIO: Pausar/Reanudar", 70, startY + line++ * lineHeight);
    line++;
    
    fill(255, 255, 0);
    text("MECÁNICAS DE RECURSOS:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• Recursos limitados: 50 comida y 50 rocas iniciales", 70, startY + line++ * lineHeight);
    text("• Los recursos NO se regeneran automáticamente", 70, startY + line++ * lineHeight);
    text("• Power-ups en burbujas aparecen cada 10 segundos", 70, startY + line++ * lineHeight);
    text("• Gestiona sabiamente tus recursos para sobrevivir", 70, startY + line++ * lineHeight);
    line++;
    
    fill(255, 255, 0);
    text("DIFICULTAD ESCALADA:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• La dificultad aumenta cada 30 segundos", 70, startY + line++ * lineHeight);
    text("• Más enemigos aparecen simultáneamente", 70, startY + line++ * lineHeight);
    text("• Tipos más peligrosos se desbloquean progresivamente", 70, startY + line++ * lineHeight);
    text("• El tiempo del día cambia cada 2 minutos", 70, startY + line++ * lineHeight);
    line++;
    

    // Renderizar botones
    playButton.render();
    backButton.render();
  }
  
  /**
   * Maneja clics del mouse
   */
  void handleClick(float mouseX, float mouseY) {
    if (playButton.isClicked(mouseX, mouseY)) {
      screenManager.startEndlessGame();
    } else if (backButton.isClicked(mouseX, mouseY)) {
      screenManager.returnToMenu();
    }
  }
} 