/**
 * Jardín Koi  - VictoryScreen (Placeholder)
 * 
 * Pantalla de victoria para el Modo Waves (completar las 5 rondas).
 * 
 * PLACEHOLDER: Esta es una implementación temporal para evitar errores de compilación.
 * Será expandida completamente en la Fase 6 del desarrollo.
 * 
 * FUNCIONALIDADES FUTURAS:
 * - Celebración de victoria con animaciones
 * - Estadísticas finales detalladas
 * - Comparación con records anteriores
 * - Opciones de reinicio o menú principal
 */

class VictoryScreen {
  ScreenManager screenManager;
  
  // Botones
  Button playEndlessButton;
  Button mainMenuButton;
  Button playAgainButton;
  
  // Estado visual
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 8;
  
  // Animaciones
  float celebrationTime = 0;
  float starTime = 0;
  
  // Colores
  color backgroundColor = color(0, 0, 0, 180);
  color panelColor = color(30, 50, 90);
  color titleColor = color(255, 215, 0); // Dorado
  color textColor = color(255, 255, 255);
  color unlockColor = color(100, 255, 100); // Verde brillante
  
  /**
   * Constructor placeholder
   */
  VictoryScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    setupButtons();
    println("🏆 VictoryScreen creado (placeholder)");
  }
  
  /**
   * Configura los botones de la pantalla
   */
  void setupButtons() {
    float buttonWidth = 160;
    float buttonHeight = 45;
    float buttonSpacing = 40; // Más espacio entre botones
    float startY = height/2 + 80; // Más arriba, alejado del borde
    
    // Centrar botones horizontalmente con margen adicional
    float totalWidth = (buttonWidth * 3) + (buttonSpacing * 2);
    float startX = (width - totalWidth) / 2;
    
    // Nuevo botón para probar Endless Mode (destacado)
    playEndlessButton = new Button(startX, startY, buttonWidth, buttonHeight, "PROBAR ENDLESS");
    playEndlessButton.setColors(color(255, 152, 0), color(255, 183, 77), color(255));
    
    // Jugar Waves de nuevo
    playAgainButton = new Button(startX + buttonWidth + buttonSpacing, startY, buttonWidth, buttonHeight, "JUGAR DE NUEVO");
    playAgainButton.setColors(color(33, 150, 243), color(100, 181, 246), color(255));
    
    // Menú principal
    mainMenuButton = new Button(startX + (buttonWidth + buttonSpacing) * 2, startY, buttonWidth, buttonHeight, "MENU PRINCIPAL");
    mainMenuButton.setColors(color(96, 125, 139), color(144, 164, 174), color(255));
  }
  
  /**
   * Muestra la pantalla de victoria
   */
  void show() {
    this.isVisible = true;
    this.fadeAlpha = 0;
    this.celebrationTime = 0;
    this.starTime = 0;
    
    println("¡Waves completado! Modo Endless desbloqueado!");
  }
  
  /**
   * Actualiza la pantalla
   */
  void update() {
    if (isVisible && fadeAlpha < 255) {
      fadeAlpha = min(255, fadeAlpha + fadeSpeed);
    }
    
    // Actualizar animaciones
    celebrationTime += 0.02;
    starTime += 0.05;
    
    // Actualizar botones solo cuando esté completamente visible
    if (isFullyVisible()) {
      playEndlessButton.update(mouseX, mouseY);
      playAgainButton.update(mouseX, mouseY);
      mainMenuButton.update(mouseX, mouseY);
    }
  }
  
  /**
   * Renderiza la pantalla
   */
  void render() {
    if (!isVisible) return;
    
    // Overlay de fondo
    fill(red(backgroundColor), green(backgroundColor), blue(backgroundColor), fadeAlpha * 0.8);
    noStroke();
    rect(0, 0, width, height);
    
    // Panel principal
    float panelWidth = 700;
    float panelHeight = 500;
    float panelX = (width - panelWidth) / 2;
    float panelY = (height - panelHeight) / 2 - 20;
    
    // Fondo del panel con gradient efecto
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.95);
    stroke(255, 215, 0, fadeAlpha * 0.8);
    strokeWeight(3);
    rect(panelX, panelY, panelWidth, panelHeight, 20);
    
    // Estrellas de celebración
    renderCelebrationStars(panelX, panelY, panelWidth, panelHeight);
    
    // Título principal
    renderTitle(panelY);
    
    // Mensaje de desbloqueo
    renderUnlockMessage(panelY);
    
    // Estadísticas
    renderStats(panelY);
    
    // Renderizar botones si está completamente visible
    if (isFullyVisible()) {
      renderVictoryButtons();
    }
    
    // Instrucciones
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.7);
    textAlign(CENTER);
    textSize(12);
    text("¡Felicitaciones! Has desbloqueado un nuevo modo de juego!", width/2, height - 50);
  }
  
  /**
   * Renderiza estrellas de celebración
   */
  void renderCelebrationStars(float panelX, float panelY, float panelWidth, float panelHeight) {
    fill(255, 215, 0, fadeAlpha * 0.8);
    noStroke();
    
    for (int i = 0; i < 15; i++) {
      float starX = panelX + (panelWidth * 0.1) + (i * panelWidth * 0.8 / 14);
      float starY = panelY + 20 + sin(starTime + i * 0.5) * 10;
      float starSize = 4 + sin(starTime * 2 + i) * 2;
      
      // Estrella simple
      pushMatrix();
      translate(starX, starY);
      rotate(starTime + i);
      
      for (int j = 0; j < 5; j++) {
        float angle = j * TWO_PI / 5 - PI/2;
        float x = cos(angle) * starSize;
        float y = sin(angle) * starSize;
        ellipse(x, y, 2, 2);
      }
      popMatrix();
    }
  }
  
  /**
   * Renderiza el título de victoria
   */
  void renderTitle(float panelY) {
    // Sombra del título
    fill(0, 0, 0, fadeAlpha * 0.6);
    textAlign(CENTER);
    textSize(42);
    text("VICTORIA", width/2 + 3, panelY + 63);
    
    // Título principal con efecto de pulso
    float pulse = 1.0 + sin(celebrationTime * 3) * 0.1;
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    textSize(42 * pulse);
    text("VICTORIA", width/2, panelY + 60);
    
    // Subtítulo
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.9);
    textSize(18);
    text("¡Las 5 Oleadas Completadas!", width/2, panelY + 100);
  }
  
  /**
   * Renderiza el mensaje de desbloqueo
   */
  void renderUnlockMessage(float panelY) {
    // Fondo del mensaje de unlock
    fill(red(unlockColor), green(unlockColor), blue(unlockColor), fadeAlpha * 0.2);
    noStroke();
    rect(width/2 - 200, panelY + 130, 400, 80, 10);
    
    // Texto de desbloqueo
    fill(red(unlockColor), green(unlockColor), blue(unlockColor), fadeAlpha);
    textAlign(CENTER);
    textSize(20);
    text("MODO ENDLESS DESBLOQUEADO", width/2, panelY + 160);
    
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    textSize(14);
    text("¡Enfrenta oleadas infinitas de dificultad creciente!", width/2, panelY + 185);
  }
  
  /**
   * Renderiza las estadísticas de la partida
   */
  void renderStats(float panelY) {
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.7);
    textAlign(CENTER);
    textSize(14);
    
    text("Oleadas Supervividas: 5/5", width/2, panelY + 240);
    text("Peces Salvados: Muchos", width/2, panelY + 260);
    text("Tiempo Total: Viaje Épico", width/2, panelY + 280);
  }
  
  /**
   * Renderiza los botones de la pantalla
   */
  void renderVictoryButtons() {
    renderVictoryButton(playEndlessButton, true); // Destacado
    renderVictoryButton(playAgainButton, false);
    renderVictoryButton(mainMenuButton, false);
  }
  
  /**
   * Renderiza un botón individual con efectos especiales
   */
  void renderVictoryButton(Button button, boolean highlighted) {
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Efecto especial para el botón destacado
    if (highlighted) {
      // Glow effect
      fill(255, 152, 0, fadeAlpha * 0.3 * (1 + sin(celebrationTime * 4) * 0.5));
      noStroke();
      rect(button.position.x - 5, button.position.y - 5, button.width + 10, button.height + 10, 15);
    }
    
    // Sombra del botón
    fill(0, 0, 0, fadeAlpha * 0.6);
    noStroke();
    rect(button.position.x + 3, button.position.y + 3, button.width, button.height, 12);
    
    // Botón principal
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.95);
    rect(button.position.x, button.position.y, button.width, button.height, 12);
    
    // Highlight superior para efecto 3D
    if (!button.isHovered) {
      fill(255, 255, 255, fadeAlpha * 0.3);
      rect(button.position.x + 2, button.position.y + 2, button.width - 4, button.height/3, 10);
    }
    
    // Borde especial para el botón destacado
    if (highlighted) {
      stroke(255, 215, 0, fadeAlpha * (0.8 + sin(celebrationTime * 6) * 0.3));
      strokeWeight(2);
      noFill();
      rect(button.position.x - 1, button.position.y - 1, button.width + 2, button.height + 2, 13);
    }
    
    // Texto del botón
    fill(red(button.textColor), green(button.textColor), blue(button.textColor), fadeAlpha);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (playEndlessButton.isClicked(mouseX, mouseY)) {
      println("Iniciando Modo Endless desbloqueado...");
      hide();
      screenManager.startEndlessMode();
      
    } else if (playAgainButton.isClicked(mouseX, mouseY)) {
      println("Jugando Waves de nuevo...");
      hide();
      screenManager.startWavesMode();
      
    } else if (mainMenuButton.isClicked(mouseX, mouseY)) {
      println("Volviendo al menú principal...");
      hide();
      screenManager.returnToMenu();
    }
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    if (!isFullyVisible()) return;
    
    if (key == '1') {
      hide();
      screenManager.startEndlessMode();
    } else if (key == '2') {
      hide();
      screenManager.startWavesMode();
    } else if (key == '3') {
      hide();
      screenManager.returnToMenu();
    }
  }
  
  /**
   * Verifica si está completamente visible
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