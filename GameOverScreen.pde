/**
 * Jardín Koi  - GameOverScreen (Placeholder)
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
  
  // Botones
  Button restartButton;
  Button mainMenuButton;
  Button quitButton;
  
  // Estado visual
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 5;
  
  // Colores y tipografía
  color backgroundColor = color(0, 0, 0, 200);
  color titleColor = color(255, 100, 100);
  color subtitleColor = color(200, 200, 200);
  color textColor = color(255, 255, 255);
  
  // Información del juego
  String gameMode = "";
  int finalScore = 0;
  String survivalTime = "00:00";
  int currentWave = 0;
  
  /**
   * Constructor placeholder
   */
  GameOverScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    println("💀 GameOverScreen creado (placeholder)");
    
    // Configurar botones
    setupButtons();
  }
  
  /**
   * Configura los botones de la pantalla
   */
  void setupButtons() {
    float buttonWidth = 150;
    float buttonHeight = 45;
    float buttonSpacing = 25;
    float startY = height/2 + 100;
    
    // Centrar botones horizontalmente
    float totalWidth = (buttonWidth * 3) + (buttonSpacing * 2);
    float startX = (width - totalWidth) / 2;
    
    restartButton = new Button(startX, startY, buttonWidth, buttonHeight, "REINICIAR");
    restartButton.setColors(color(76, 175, 80), color(129, 199, 132), color(255));
    
    mainMenuButton = new Button(startX + buttonWidth + buttonSpacing, startY, buttonWidth, buttonHeight, "MENU PRINCIPAL");
    mainMenuButton.setColors(color(33, 150, 243), color(100, 181, 246), color(255));
    
    quitButton = new Button(startX + (buttonWidth + buttonSpacing) * 2, startY, buttonWidth, buttonHeight, "SALIR DEL JUEGO");
    quitButton.setColors(color(244, 67, 54), color(239, 154, 154), color(255));
  }
  
  /**
   * Muestra la pantalla de Game Over
   */
  void show(String mode, int score, String time, int wave) {
    this.gameMode = mode;
    this.finalScore = score;
    this.survivalTime = time;
    this.currentWave = wave;
    this.isVisible = true;
    this.fadeAlpha = 0;
  }
  
  /**
   * Actualiza la pantalla
   */
  void update() {
    if (isVisible && fadeAlpha < 255) {
      fadeAlpha = min(255, fadeAlpha + fadeSpeed);
    }
    
    // Actualizar botones
    if (isFullyVisible()) {
      restartButton.update(mouseX, mouseY);
      mainMenuButton.update(mouseX, mouseY);
      quitButton.update(mouseX, mouseY);
    }
  }
  
  /**
   * Renderiza la pantalla
   */
  void render() {
    if (!isVisible) return;
    
    // Overlay semi-transparente
    fill(red(backgroundColor), green(backgroundColor), blue(backgroundColor), fadeAlpha * 0.8);
    noStroke();
    rect(0, 0, width, height);
    
    // Panel principal más grande y mejor centrado
    float panelWidth = 550;
    float panelHeight = 400;
    float panelX = (width - panelWidth) / 2;
    float panelY = (height - panelHeight) / 2 - 20;
    
    // Fondo del panel
    fill(40, 40, 40, fadeAlpha * 0.95);
    stroke(100, 100, 100, fadeAlpha);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 10);
    
    // Título principal con sombra
    fill(0, 0, 0, fadeAlpha * 0.6);
    textAlign(CENTER, CENTER);
    textSize(38);
    text("JUEGO TERMINADO", width/2 + 2, panelY + 62);
    
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    textSize(38);
    text("JUEGO TERMINADO", width/2, panelY + 60);
    
    // Subtítulo
    fill(red(subtitleColor), green(subtitleColor), blue(subtitleColor), fadeAlpha);
    textSize(16);
    text("Todos los Peces Koi Han Muerto", width/2, panelY + 110);
    
    // Información del juego
    renderGameStats(panelX, panelY, panelWidth);
    
    // Renderizar botones si está completamente visible
    if (isFullyVisible()) {
      renderGameOverButton(restartButton);
      renderGameOverButton(mainMenuButton);
      renderGameOverButton(quitButton);
    }
    
    // Instrucciones
    fill(red(subtitleColor), green(subtitleColor), blue(subtitleColor), fadeAlpha * 0.7);
    textAlign(CENTER);
    textSize(11);
    text("Presiona ESC para volver al menú • R=Reiniciar • M=Menú • Q=Salir", width/2, height - 30);
  }
  
  /**
   * Renderiza las estadísticas del juego
   */
  void renderGameStats(float panelX, float panelY, float panelWidth) {
    float statsY = panelY + 160;
    
    // Fondo semi-transparente para las estadísticas
    fill(0, 0, 0, fadeAlpha * 0.3);
    noStroke();
    rect(panelX + 50, statsY - 20, panelWidth - 100, 90, 8);
    
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
    textAlign(CENTER);
    textSize(16);
    
    // Modo de juego
    text("MODO: " + gameMode.toUpperCase(), width/2, statsY + 10);
    
    textSize(14);
    if (gameMode.equals("endless")) {
      // Estadísticas para modo Endless
      text("PUNTUACIÓN FINAL: " + finalScore, width/2, statsY + 35);
      text("TIEMPO DE SUPERVIVENCIA: " + survivalTime, width/2, statsY + 55);
    } else if (gameMode.equals("waves")) {
      // Estadísticas para modo Waves
      text("OLEADA ALCANZADA: " + currentWave, width/2, statsY + 35);
      text("TIEMPO DE SUPERVIVENCIA: " + survivalTime, width/2, statsY + 55);
    }
  }
  
  /**
   * Renderiza un botón con efectos de Game Over
   */
  void renderGameOverButton(Button button) {
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Sombra más prominente
    fill(0, 0, 0, fadeAlpha * 0.6);
    noStroke();
    rect(button.position.x + 4, button.position.y + 4, button.width, button.height, 10);
    
    // Botón principal con gradiente simulado
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.95);
    rect(button.position.x, button.position.y, button.width, button.height, 10);
    
    // Highlight superior para efecto 3D
    if (!button.isHovered) {
      fill(255, 255, 255, fadeAlpha * 0.2);
      rect(button.position.x + 2, button.position.y + 2, button.width - 4, button.height/3, 8);
    }
    
    // Borde con glow cuando hover
    if (button.isHovered) {
      stroke(255, 255, 255, fadeAlpha * 0.8);
      strokeWeight(3);
      noFill();
      rect(button.position.x - 1, button.position.y - 1, button.width + 2, button.height + 2, 11);
    }
    
    // Texto con sombra
    // Sombra del texto
    fill(0, 0, 0, fadeAlpha * 0.5);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(button.label, 
         button.position.x + button.width/2 + 1, 
         button.position.y + button.height/2 + 1);
    
    // Texto principal
    fill(red(button.textColor), green(button.textColor), blue(button.textColor), fadeAlpha);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (restartButton.isClicked(mouseX, mouseY)) {
      println("Reiniciando " + gameMode + "...");
      handleRestart();
      
    } else if (mainMenuButton.isClicked(mouseX, mouseY)) {
      println("Volviendo al menú principal...");
      screenManager.returnToMenu();
      hide();
      
    } else if (quitButton.isClicked(mouseX, mouseY)) {
      println("Saliendo del juego...");
      screenManager.quitGame();
    }
  }
  
  /**
   * Maneja el reinicio según el modo
   */
  void handleRestart() {
    hide();
    
    if (gameMode.equals("endless")) {
      screenManager.startEndlessMode();
    } else if (gameMode.equals("waves")) {
      screenManager.startWavesMode();
    }
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    if (key == 'r' || key == 'R') {
      handleRestart();
    } else if (key == 'm' || key == 'M') {
      screenManager.returnToMenu();
      hide();
    } else if (key == 'q' || key == 'Q') {
      screenManager.quitGame();
    }
  }
  
  /**
   * Verifica si la pantalla está completamente visible
   */
  boolean isFullyVisible() {
    return isVisible && fadeAlpha >= 250;
  }
  
  /**
   * Oculta la pantalla
   */
  void hide() {
    isVisible = false;
    fadeAlpha = 0;
  }
  
  /**
   * Verifica si la pantalla está visible
   */
  boolean isShowing() {
    return isVisible;
  }
} 