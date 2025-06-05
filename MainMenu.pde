/**
 * KOI SURVIVAL - MainMenu
 * 
 * Pantalla principal de selección de modo de juego.
 * Presenta tres opciones principales: Waves, Endless y Zen.
 * 
 * CARACTERÍSTICAS:
 * - Diseño limpio y atractivo
 * - Botones interactivos para cada modo
 * - Información visual sobre cada modo
 * - Transiciones suaves a otros estados
 * 
 * MODOS DISPONIBLES:
 * - Waves Mode: 5 rondas con oleadas programadas
 * - Endless Mode: Supervivencia infinita  
 * - Zen Mode: Simulación relajante original
 * 
 * CÓDIGO ORIGINAL: 100% (nueva implementación para el sistema de menú)
 */

class MainMenu {
  ScreenManager screenManager;
  
  // Botones del menú
  Button wavesButton;
  Button endlessButton;
  Button zenButton;
  Button instructionsButton;
  Button quitButton;
  
  // Variables visuales
  color backgroundColor;
  color titleColor;
  color subtitleColor;
  PFont titleFont;
  PFont buttonFont;
  
  // Animaciones
  float titlePulse;
  float particleTime;
  
  /**
   * Constructor
   */
  MainMenu(ScreenManager screenManager) {
    this.screenManager = screenManager;
    initializeUI();
    setupColors();
  }
  
  /**
   * Inicializa la interfaz de usuario
   */
  void initializeUI() {
    float centerX = width / 2;
    float buttonWidth = 200;
    float buttonHeight = 50;
    float buttonSpacing = 70;
    float startY = height / 2 - 80;
    
    // Crear botones principales
    wavesButton = new Button(
      centerX - buttonWidth/2, 
      startY, 
      buttonWidth, 
      buttonHeight, 
      "🌊 WAVES MODE"
    );
    
    endlessButton = new Button(
      centerX - buttonWidth/2, 
      startY + buttonSpacing, 
      buttonWidth, 
      buttonHeight, 
      "♾️ ENDLESS MODE"
    );
    
    zenButton = new Button(
      centerX - buttonWidth/2, 
      startY + buttonSpacing * 2, 
      buttonWidth, 
      buttonHeight, 
      "🧘 ZEN MODE"
    );
    
    // Botones secundarios (más pequeños)
    float smallButtonWidth = 150;
    float smallButtonHeight = 35;
    
    instructionsButton = new Button(
      centerX - smallButtonWidth - 10, 
      startY + buttonSpacing * 3 + 20, 
      smallButtonWidth, 
      smallButtonHeight, 
      "📋 Instructions"
    );
    
    quitButton = new Button(
      centerX + 10, 
      startY + buttonSpacing * 3 + 20, 
      smallButtonWidth, 
      smallButtonHeight, 
      "🚪 Quit"
    );
    
    // Personalizar colores de botones
    setupButtonColors();
  }
  
  /**
   * Configura los colores del tema
   */
  void setupColors() {
    backgroundColor = color(20, 40, 60);     // Azul oscuro del estanque
    titleColor = color(100, 200, 255);      // Azul claro del agua
    subtitleColor = color(200, 220, 240);   // Blanco azulado
  }
  
  /**
   * Configura los colores específicos de cada botón
   */
  void setupButtonColors() {
    // Waves Mode - Azul intenso
    wavesButton.buttonColor = color(30, 100, 180);
    wavesButton.hoverColor = color(40, 120, 200);
    
    // Endless Mode - Púrpura oscuro
    endlessButton.buttonColor = color(100, 50, 150);
    endlessButton.hoverColor = color(120, 70, 170);
    
    // Zen Mode - Verde tranquilo
    zenButton.buttonColor = color(60, 150, 100);
    zenButton.hoverColor = color(80, 170, 120);
    
    // Botones secundarios - Gris
    instructionsButton.buttonColor = color(80, 80, 100);
    instructionsButton.hoverColor = color(100, 100, 120);
    
    quitButton.buttonColor = color(150, 60, 60);
    quitButton.hoverColor = color(170, 80, 80);
  }
  
  /**
   * Actualización del menú
   */
  void update() {
    // Actualizar animaciones
    titlePulse += 0.02;
    particleTime += 0.01;
    
    // Actualizar botones
    wavesButton.update(mouseX, mouseY);
    endlessButton.update(mouseX, mouseY);
    zenButton.update(mouseX, mouseY);
    instructionsButton.update(mouseX, mouseY);
    quitButton.update(mouseX, mouseY);
  }
  
  /**
   * Renderizado del menú
   */
  void render() {
    // Fondo degradado
    renderBackground();
    
    // Partículas de agua flotantes
    renderWaterParticles();
    
    // Título principal
    renderTitle();
    
    // Descripción de modos
    renderModeDescriptions();
    
    // Botones
    renderButtons();
    
    // Footer con información
    renderFooter();
  }
  
  /**
   * Renderiza el fondo con efecto de agua
   */
  void renderBackground() {
    // Degradado de fondo
    for (int y = 0; y < height; y++) {
      float alpha = map(y, 0, height, 0.2, 1.0);
      color c = lerpColor(color(10, 30, 50), backgroundColor, alpha);
      stroke(c);
      line(0, y, width, y);
    }
  }
  
  /**
   * Renderiza partículas flotantes que simulan burbujas de agua
   */
  void renderWaterParticles() {
    noStroke();
    fill(100, 200, 255, 60);
    
    for (int i = 0; i < 15; i++) {
      float x = (particleTime * 50 + i * 40) % (width + 20) - 10;
      float y = 100 + sin(particleTime + i) * 30 + i * 30;
      float size = 4 + sin(particleTime * 2 + i) * 2;
      
      ellipse(x, y, size, size);
    }
  }
  
  /**
   * Renderiza el título principal
   */
  void renderTitle() {
    // Título principal
    fill(titleColor);
    textAlign(CENTER);
    textSize(48);
    
    float pulse = 1.0 + sin(titlePulse) * 0.1;
    
    pushMatrix();
    translate(width/2, 80);
    scale(pulse);
    text("KOI SURVIVAL", 0, 0);
    popMatrix();
    
    // Subtítulo
    fill(subtitleColor);
    textSize(16);
    text("Choose Your Adventure", width/2, 110);
  }
  
  /**
   * Renderiza las descripciones de cada modo
   */
  void renderModeDescriptions() {
    textAlign(CENTER);
    textSize(11);
    fill(200, 220, 240, 150);
    
    float descY = height/2 - 80 + 58; // Justo debajo de los botones
    float spacing = 70;
    
    // Waves Mode
    text("5 rounds • Strategic survival • Upgrades", width/2, descY);
    
    // Endless Mode  
    text("Infinite survival • Power-ups • High scores", width/2, descY + spacing);
    
    // Zen Mode
    text("Peaceful simulation • Creative • Relaxing", width/2, descY + spacing * 2);
  }
  
  /**
   * Renderiza todos los botones
   */
  void renderButtons() {
    renderButton(wavesButton);
    renderButton(endlessButton);
    renderButton(zenButton);
    renderButton(instructionsButton);
    renderButton(quitButton);
  }
  
  /**
   * Renderiza un botón individual
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
   * Renderiza el footer con información adicional
   */
  void renderFooter() {
    fill(subtitleColor);
    textAlign(CENTER);
    textSize(10);
    text("Press ESC anytime to return to menu • Pause: SPACE or P", width/2, height - 35);
    text("Shortcuts: 1=Waves, 2=Endless, 3=Zen, I=Instructions, Q=Quit", width/2, height - 20);
    
    // Versión
    textAlign(RIGHT);
    text("v1.0", width - 10, height - 10);
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    // Teclas de acceso rápido
    if (key == '1') {
      screenManager.startWavesMode();
    } else if (key == '2') {
      screenManager.startEndlessMode();
    } else if (key == '3') {
      screenManager.startZenMode();
    } else if (key == 'i' || key == 'I') {
      screenManager.showInstructions();
    } else if (key == 'q' || key == 'Q') {
      screenManager.quitGame();
    }
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (wavesButton.isClicked(mouseX, mouseY)) {
      println("🌊 Iniciando Modo Waves...");
      screenManager.startWavesMode();
      
    } else if (endlessButton.isClicked(mouseX, mouseY)) {
      println("♾️ Iniciando Modo Endless...");
      screenManager.startEndlessMode();
      
    } else if (zenButton.isClicked(mouseX, mouseY)) {
      println("🧘 Iniciando Modo Zen...");
      screenManager.startZenMode();
      
    } else if (instructionsButton.isClicked(mouseX, mouseY)) {
      println("📋 Mostrando instrucciones...");
      screenManager.showInstructions();
      
    } else if (quitButton.isClicked(mouseX, mouseY)) {
      println("🚪 Saliendo del juego...");
      screenManager.quitGame();
    }
  }
  
  /**
   * Obtiene información de un modo para mostrar tooltip
   */
  String getModeInfo(String mode) {
    switch(mode) {
      case "waves":
        return "Survive 5 rounds of increasing difficulty.\nStrategic resource management.\nUpgrade between rounds.";
        
      case "endless":
        return "Infinite survival challenge.\nDifficulty scales every 30 seconds.\nPower-ups and high scores.";
        
      case "zen":
        return "Peaceful koi pond simulation.\nCreate custom koi designs.\nRelax and enjoy.";
        
      default:
        return "";
    }
  }
} 