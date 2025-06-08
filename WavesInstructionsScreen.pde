/**
 * WavesInstructionsScreen
 * 
 * Pantalla de instrucciones específicas para el modo Waves
 * que se muestra antes de comenzar el juego.
 */
class WavesInstructionsScreen {
  ScreenManager screenManager;
  Button playButton;
  Button backButton;
  
  /**
   * Constructor
   */
  WavesInstructionsScreen(ScreenManager screenManager) {
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
    playButton = new Button(width/2 - buttonWidth/2, height - 160, buttonWidth, buttonHeight, "JUGAR");
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
    background(20, 30, 40);
    
    // Título
    fill(255, 215, 0);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("MODO WAVES", width/2, 50);
    
    // Subtítulo
    fill(255);
    textSize(14);
    text("5 Oleadas de Supervivencia", width/2, 75);
    
    // Instrucciones principales
    textAlign(LEFT, TOP);
    textSize(12);
    float startY = 110;
    float lineHeight = 18;
    int line = 0;
    
    fill(255, 255, 0);
    text("OBJETIVO:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• Sobrevive las 5 oleadas de 2 minutos cada una", 70, startY + line++ * lineHeight);
    text("• Mantén vivos a tus koi y hazlos crecer", 70, startY + line++ * lineHeight);
    line++;
    
    fill(255, 255, 0);
    text("CONTROLES:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• CLIC IZQUIERDO: Alimentar koi (recursos limitados)", 70, startY + line++ * lineHeight);
    text("• CLIC DERECHO: Lanzar rocas contra enemigos", 70, startY + line++ * lineHeight);
    text("• ESPACIO: Pausar/Reanudar", 70, startY + line++ * lineHeight);
    line++;
    
    fill(255, 255, 0);
    text("MECÁNICAS:", 50, startY + line++ * lineHeight);
    fill(255);
    text("• Los koi crecen cada 10 comidas consumidas", 70, startY + line++ * lineHeight);
    text("• Los enemigos reducen el nivel de los koi al atacar", 70, startY + line++ * lineHeight);
    text("• Power-ups aparecen cada 20 segundos", 70, startY + line++ * lineHeight);
    text("• Recursos se regeneran solo con power-ups", 70, startY + line++ * lineHeight);
    
    // Renderizar botones
    playButton.render();
    backButton.render();
  }
  
  /**
   * Maneja clics del mouse
   */
  void handleClick(float mouseX, float mouseY) {
    if (playButton.isClicked(mouseX, mouseY)) {
      screenManager.startWavesGame();
    } else if (backButton.isClicked(mouseX, mouseY)) {
      screenManager.returnToMenu();
    }
  }
} 