/**
 * KOI SURVIVAL - PauseScreen
 * 
 * Pantalla de pausa universal que se superpone al juego activo.
 * Funciona para todos los modos: Waves, Endless y Zen.
 * 
 * CARACTERÍSTICAS:
 * - Fondo semi-transparente que preserva visibilidad del juego
 * - Menú central con opciones principales
 * - Estadísticas del juego actual
 * - Múltiples formas de reanudar
 * - Preservación completa del estado del juego
 * 
 * OPCIONES DISPONIBLES:
 * - Reanudar: Continuar el juego
 * - Reiniciar: Comenzar desde el inicio
 * - Menú Principal: Volver al menú de selección
 * - Salir: Cerrar la aplicación
 * 
 * CÓDIGO ORIGINAL: 100% (nueva implementación para el sistema de pausa)
 */

class PauseScreen {
  ScreenManager screenManager;
  
  // Botones del menú de pausa
  Button resumeButton;
  Button restartButton;
  Button mainMenuButton;
  Button quitButton;
  
  // Variables visuales
  color overlayColor;
  color panelColor;
  color textColor;
  color titleColor;
  
  // Animaciones
  float fadeAlpha;
  float pulseTime;
  boolean isVisible;
  
  /**
   * Constructor
   */
  PauseScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    initializeUI();
    setupColors();
    this.isVisible = false;
    this.fadeAlpha = 0;
    this.pulseTime = 0;
  }
  
  /**
   * Inicializa la interfaz de usuario
   */
  void initializeUI() {
    float centerX = width / 2;
    float centerY = height / 2;
    float buttonWidth = 180;
    float buttonHeight = 45;
    float buttonSpacing = 55;
    
    // Crear botones del menú de pausa
    resumeButton = new Button(
      centerX - buttonWidth/2, 
      centerY - buttonSpacing * 1.5, 
      buttonWidth, 
      buttonHeight, 
      "▶️ Resume"
    );
    
    restartButton = new Button(
      centerX - buttonWidth/2, 
      centerY - buttonSpacing/2, 
      buttonWidth, 
      buttonHeight, 
      "🔄 Restart"
    );
    
    mainMenuButton = new Button(
      centerX - buttonWidth/2, 
      centerY + buttonSpacing/2, 
      buttonWidth, 
      buttonHeight, 
      "🏠 Main Menu"
    );
    
    quitButton = new Button(
      centerX - buttonWidth/2, 
      centerY + buttonSpacing * 1.5, 
      buttonWidth, 
      buttonHeight, 
      "🚪 Quit Game"
    );
    
    // Personalizar colores de botones
    setupButtonColors();
  }
  
  /**
   * Configura los colores del tema de pausa
   */
  void setupColors() {
    overlayColor = color(0, 0, 0, 120);        // Negro semi-transparente
    panelColor = color(40, 60, 80, 220);       // Azul oscuro del panel
    textColor = color(255, 255, 255);          // Blanco para texto
    titleColor = color(255, 200, 100);         // Amarillo dorado para título
  }
  
  /**
   * Configura los colores de los botones de pausa
   */
  void setupButtonColors() {
    // Resume - Verde
    resumeButton.buttonColor = color(60, 150, 80);
    resumeButton.hoverColor = color(80, 170, 100);
    
    // Restart - Azul
    restartButton.buttonColor = color(80, 120, 180);
    restartButton.hoverColor = color(100, 140, 200);
    
    // Main Menu - Gris
    mainMenuButton.buttonColor = color(100, 100, 120);
    mainMenuButton.hoverColor = color(120, 120, 140);
    
    // Quit - Rojo
    quitButton.buttonColor = color(180, 80, 80);
    quitButton.hoverColor = color(200, 100, 100);
  }
  
  /**
   * Actualización de la pantalla de pausa
   */
  void update() {
    if (screenManager.isPaused()) {
      isVisible = true;
      fadeAlpha = min(255, fadeAlpha + 10); // Fade in
    } else {
      fadeAlpha = max(0, fadeAlpha - 15);   // Fade out
      if (fadeAlpha <= 0) {
        isVisible = false;
      }
    }
    
    // Actualizar animaciones
    pulseTime += 0.03;
    
    // Actualizar botones solo si está visible
    if (isVisible) {
      resumeButton.update(mouseX, mouseY);
      restartButton.update(mouseX, mouseY);
      mainMenuButton.update(mouseX, mouseY);
      quitButton.update(mouseX, mouseY);
    }
  }
  
  /**
   * Renderizado de la pantalla de pausa
   */
  void render() {
    if (!isVisible && fadeAlpha <= 0) return;
    
    // Overlay semi-transparente
    renderOverlay();
    
    // Panel principal
    renderMainPanel();
    
    // Título
    renderTitle();
    
    // Estadísticas del juego actual
    renderGameStats();
    
    // Botones
    renderButtons();
    
    // Instrucciones
    renderInstructions();
  }
  
  /**
   * Renderiza el overlay de fondo
   */
  void renderOverlay() {
    fill(red(overlayColor), green(overlayColor), blue(overlayColor), fadeAlpha * 0.6);
    noStroke();
    rect(0, 0, width, height);
  }
  
  /**
   * Renderiza el panel principal de pausa
   */
  void renderMainPanel() {
    float panelWidth = 300;
    float panelHeight = 350;
    float panelX = width/2 - panelWidth/2;
    float panelY = height/2 - panelHeight/2;
    
    // Sombra del panel
    fill(0, 0, 0, fadeAlpha * 0.3);
    noStroke();
    rect(panelX + 5, panelY + 5, panelWidth, panelHeight, 15);
    
    // Panel principal
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.9);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Borde del panel
    stroke(255, 255, 255, fadeAlpha * 0.3);
    strokeWeight(2);
    noFill();
    rect(panelX, panelY, panelWidth, panelHeight, 15);
  }
  
  /**
   * Renderiza el título de pausa
   */
  void renderTitle() {
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    textAlign(CENTER);
    textSize(32);
    
    // Efecto de pulso
    float pulse = 1.0 + sin(pulseTime) * 0.1;
    
    pushMatrix();
    translate(width/2, height/2 - 120);
    scale(pulse);
    text("⏸️ PAUSED", 0, 0);
    popMatrix();
  }
  
  /**
   * Renderiza las estadísticas del juego actual
   */
  void renderGameStats() {
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    textAlign(CENTER);
    textSize(12);
    
    String currentMode = getCurrentModeString();
    text("Mode: " + currentMode, width/2, height/2 - 85);
    
    // Estadísticas específicas según el modo
    String stats = getGameStats();
    if (!stats.equals("")) {
      text(stats, width/2, height/2 - 70);
    }
  }
  
  /**
   * Obtiene el modo actual como string
   */
  String getCurrentModeString() {
    GameState previousState = screenManager.previousState;
    switch(previousState) {
      case ZEN_MODE: return "🧘 Zen Mode";
      case WAVES_ACTIVE: return "🌊 Waves Mode";
      case ENDLESS_ACTIVE: return "♾️ Endless Mode";
      default: return "Unknown";
    }
  }
  
  /**
   * Obtiene las estadísticas del juego actual
   */
  String getGameStats() {
    GameState previousState = screenManager.previousState;
    
    switch(previousState) {
      case ZEN_MODE:
        // Modo Zen - estadísticas básicas
        if (screenManager.pondManager != null) {
          int koiCount = screenManager.pondManager.koiManager.getKoiCount();
          return "Koi in pond: " + koiCount;
        }
        break;
        
      case WAVES_ACTIVE:
        // Modo Waves - estadísticas futuras
        return "Round: ? • Score: ? • Koi: ?";
        
      case ENDLESS_ACTIVE:
        // Modo Endless - estadísticas futuras
        return "Time: ?:?? • Score: ? • Koi: ?";
    }
    
    return "";
  }
  
  /**
   * Renderiza todos los botones
   */
  void renderButtons() {
    if (fadeAlpha > 100) { // Solo renderizar cuando está suficientemente visible
      renderPauseButton(resumeButton);
      renderPauseButton(restartButton);
      renderPauseButton(mainMenuButton);
      renderPauseButton(quitButton);
    }
  }
  
  /**
   * Renderiza un botón individual de pausa
   */
  void renderPauseButton(Button button) {
    // Color del botón con alpha
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Sombra
    fill(0, 0, 0, fadeAlpha * 0.4);
    noStroke();
    rect(button.position.x + 2, button.position.y + 2, button.width, button.height, 8);
    
    // Botón principal
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.9);
    rect(button.position.x, button.position.y, button.width, button.height, 8);
    
    // Borde
    if (button.isHovered) {
      stroke(255, 255, 255, fadeAlpha * 0.6);
      strokeWeight(2);
      noFill();
      rect(button.position.x, button.position.y, button.width, button.height, 8);
    }
    
    // Texto
    fill(red(button.textColor), green(button.textColor), blue(button.textColor), fadeAlpha);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Renderiza las instrucciones de la pausa
   */
  void renderInstructions() {
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.6);
    textAlign(CENTER);
    textSize(10);
    text("Press SPACE, P, or ESC to resume", width/2, height/2 + 140);
  }
  
  /**
   * Maneja eventos de teclado en pausa
   */
  void handleKey(char key, int keyCode) {
    if (key == 'r' || key == 'R') {
      // Restart rápido
      handleRestart();
    } else if (key == 'm' || key == 'M') {
      // Main menu rápido
      screenManager.returnToMenu();
    } else if (key == 'q' || key == 'Q') {
      // Quit rápido
      screenManager.quitGame();
    }
    // Nota: SPACE, P y ESC se manejan en ScreenManager
  }
  
  /**
   * Maneja eventos de clic en pausa
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isVisible) return;
    
    if (resumeButton.isClicked(mouseX, mouseY)) {
      println("▶️ Reanudando juego...");
      screenManager.resumeGame();
      
    } else if (restartButton.isClicked(mouseX, mouseY)) {
      println("🔄 Reiniciando...");
      handleRestart();
      
    } else if (mainMenuButton.isClicked(mouseX, mouseY)) {
      println("🏠 Volviendo al menú principal...");
      screenManager.returnToMenu();
      
    } else if (quitButton.isClicked(mouseX, mouseY)) {
      println("🚪 Saliendo del juego...");
      screenManager.quitGame();
    }
  }
  
  /**
   * Maneja el reinicio según el modo actual
   */
  void handleRestart() {
    GameState previousState = screenManager.previousState;
    
    switch(previousState) {
      case ZEN_MODE:
        screenManager.startZenMode();
        break;
      case WAVES_ACTIVE:
        screenManager.startWavesMode();
        break;
      case ENDLESS_ACTIVE:
        screenManager.startEndlessMode();
        break;
      default:
        screenManager.returnToMenu();
        break;
    }
  }
  
  /**
   * Verifica si la pantalla está completamente visible
   */
  boolean isFullyVisible() {
    return isVisible && fadeAlpha >= 250;
  }
  
  /**
   * Fuerza mostrar la pantalla de pausa
   */
  void show() {
    isVisible = true;
    fadeAlpha = 255;
  }
  
  /**
   * Fuerza ocultar la pantalla de pausa
   */
  void hide() {
    isVisible = false;
    fadeAlpha = 0;
  }
} 