/**
 * Jardín Koi  - MainMenu
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
  
  // Estado de desbloqueos
  boolean endlessUnlocked = false;
  
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
    float buttonWidth = 220; // Botones principales más anchos
    float buttonHeight = 55; // Ligeramente más altos
    float buttonSpacing = 85; // Más espacio entre botones principales
    float startY = height / 2 - 120; // Más arriba para mejor distribución
    
    // Crear botones principales con mejor espaciado
    wavesButton = new Button(
      centerX - buttonWidth/2, 
      startY, 
      buttonWidth, 
      buttonHeight, 
      "MODO WAVES"
    );
    
    endlessButton = new Button(
      centerX - buttonWidth/2, 
      startY + buttonSpacing, 
      buttonWidth, 
      buttonHeight, 
      "MODO ENDLESS"
    );
    
    zenButton = new Button(
      centerX - buttonWidth/2, 
      startY + buttonSpacing * 2, 
      buttonWidth, 
      buttonHeight, 
      "MODO ZEN"
    );
    
    // Botones secundarios con mejor posicionamiento
    float smallButtonWidth = 140;
    float smallButtonHeight = 38;
    float secondarySpacing = 20; // Espacio entre botones secundarios
    
    instructionsButton = new Button(
      centerX - smallButtonWidth - secondarySpacing/2, 
      startY + buttonSpacing * 3 + 40, // Más separación de los principales
      smallButtonWidth, 
      smallButtonHeight, 
      "Instrucciones"
    );
    
    quitButton = new Button(
      centerX + secondarySpacing/2, 
      startY + buttonSpacing * 3 + 40, 
      smallButtonWidth, 
      smallButtonHeight, 
      "Salir"
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
    // Actualizar estado de desbloqueos
    endlessUnlocked = screenManager.getProgressManager().isEndlessModeUnlocked();
    
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
    // Sombra del título para mayor impacto
    fill(0, 0, 0, 100);
    textAlign(CENTER);
    textSize(52);
    text("Jardín Koi ", width/2 + 3, 73);
    
    // Título principal con pulso
    fill(titleColor);
    textSize(52); // Ligeramente más grande
    
    float pulse = 1.0 + sin(titlePulse) * 0.08; // Pulso más sutil
    
    pushMatrix();
    translate(width/2, 70); // Posición ligeramente más alta
    scale(pulse);
    text("Jardín Koi ", 0, 0);
    popMatrix();
    
    // Línea decorativa
    stroke(titleColor);
    strokeWeight(2);
    float lineWidth = 200;
    line(width/2 - lineWidth/2, 90, width/2 + lineWidth/2, 90);
    
    // Subtítulo con mejor posicionamiento
    fill(subtitleColor);
    textSize(18); // Ligeramente más grande
    text("Elige Tu Aventura", width/2, 115);
  }
  
  /**
   * Renderiza las descripciones de cada modo
   */
  void renderModeDescriptions() {
    textAlign(CENTER);
    textSize(12); // Texto ligeramente más grande
    fill(200, 220, 240, 180); // Más opacidad para mejor legibilidad
    
    float descY = height/2 - 120 + 75; // Ajustado para la nueva posición de botones
    float spacing = 85; // Coincide con el espaciado de botones
    
    // Waves Mode
    text("5 oleadas • Supervivencia estratégica • Mejoras", width/2, descY);
    
    // Endless Mode  
    text("Supervivencia infinita • Poderes • Puntuación alta", width/2, descY + spacing);
    
    // Zen Mode
    text("Simulación pacífica • Creativo • Relajante", width/2, descY + spacing * 2);
  }
  
  /**
   * Renderiza todos los botones
   */
  void renderButtons() {
    renderButton(wavesButton);
    renderEndlessButton(); // Método especial para Endless
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
    
    // Sombra más pronunciada
    fill(0, 0, 0, 120);
    noStroke();
    rect(button.position.x + 4, button.position.y + 4, button.width, button.height, 10);
    
    // Botón principal con esquinas más redondeadas
    fill(currentColor);
    rect(button.position.x, button.position.y, button.width, button.height, 10);
    
    // Highlight superior para efecto 3D
    if (!button.isHovered) {
      fill(255, 255, 255, 40);
      rect(button.position.x + 2, button.position.y + 2, button.width - 4, button.height/4, 8);
    }
    
    // Borde con glow cuando hover
    if (button.isHovered) {
      stroke(255, 255, 255, 200);
      strokeWeight(3);
      noFill();
      rect(button.position.x - 1, button.position.y - 1, button.width + 2, button.height + 2, 11);
    }
    
    // Texto con mejor tipografía
    fill(button.textColor);
    textAlign(CENTER, CENTER);
    textSize(15); // Ligeramente más grande
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Renderiza el botón de Endless con estado de bloqueo
   */
  void renderEndlessButton() {
    Button button = endlessButton;
    
    if (endlessUnlocked) {
      // Renderizar como botón normal
      renderButton(button);
    } else {
      // Renderizar como botón bloqueado
      color lockedColor = color(60, 60, 60);
      color lockedHoverColor = color(80, 80, 80);
      
      // Sombra más pronunciada
      fill(0, 0, 0, 120);
      noStroke();
      rect(button.position.x + 4, button.position.y + 4, button.width, button.height, 10);
      
      // Botón bloqueado con esquinas más redondeadas
      fill(button.isHovered ? lockedHoverColor : lockedColor);
      rect(button.position.x, button.position.y, button.width, button.height, 10);
      
      // Patrón de bloqueo (líneas diagonales)
      stroke(40, 40, 40);
      strokeWeight(1);
      for (int i = 0; i < button.width + button.height; i += 8) {
        line(button.position.x + i, button.position.y, 
             button.position.x, button.position.y + i);
      }
      
      // Texto bloqueado
      fill(120, 120, 120);
      textAlign(CENTER, CENTER);
      textSize(15); // Consistente con otros botones
      text("MODO ENDLESS", 
           button.position.x + button.width/2, 
           button.position.y + button.height/2 - 8);
      
      // Texto de desbloqueo
      fill(150, 150, 150);
      textSize(11); // Ligeramente más grande
      text("Completa la Oleada 5 para desbloquear", 
           button.position.x + button.width/2, 
           button.position.y + button.height/2 + 8);
    }
  }
  
  /**
   * Renderiza el footer con información adicional
   */
  void renderFooter() {
    // Línea separadora
    stroke(subtitleColor);
    strokeWeight(1);
    float lineY = height - 60;
    line(width/4, lineY, 3*width/4, lineY);
    
    // Información del footer
    fill(subtitleColor);
    textAlign(CENTER);
    textSize(11); // Ligeramente más grande
    text("Presiona ESC para volver al menú • Pausa: ESPACIO o P", width/2, height - 40);
    text("Atajos: 1=Waves, 2=Endless, 3=Zen, I=Instrucciones, Q=Salir", width/2, height - 25);
    
    // Versión con mejor posicionamiento
    textAlign(RIGHT);
    textSize(10);
    fill(subtitleColor);
    text("v1.0", width - 15, height - 10);
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    // Teclas de acceso rápido
    if (key == '1') {
      screenManager.startWavesMode();
    } else if (key == '2') {
      if (endlessUnlocked) {
        screenManager.startEndlessMode();
      } else {
        println("Modo Endless bloqueado - completa la Oleada 5 primero!");
      }
    } else if (key == '3') {
      screenManager.startZenMode();
    } else if (key == 'i' || key == 'I') {
      screenManager.showInstructions();
    } else if (key == 'q' || key == 'Q') {
      screenManager.quitGame();
    } else if (key == 'u' || key == 'U') {
      // Debug: forzar unlock de Endless
      screenManager.getProgressManager().forceUnlockEndless();
      println("DEBUG: Modo Endless desbloqueado forzadamente!");
    } else if (key == 'r' || key == 'R') {
      // Debug: resetear progreso
      screenManager.getProgressManager().resetProgress();
      println("DEBUG: Progreso reseteado!");
    }
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (wavesButton.isClicked(mouseX, mouseY)) {
      println("Iniciando Modo Waves...");
      screenManager.startWavesMode();
      
    } else if (endlessButton.isClicked(mouseX, mouseY)) {
      if (endlessUnlocked) {
        println("Iniciando Modo Endless...");
        screenManager.startEndlessMode();
      } else {
        println("Modo Endless bloqueado - completa la Oleada 5 primero!");
      }
      
    } else if (zenButton.isClicked(mouseX, mouseY)) {
      println("Iniciando Modo Zen...");
      screenManager.startZenMode();
      
    } else if (instructionsButton.isClicked(mouseX, mouseY)) {
      println("Mostrando instrucciones...");
      screenManager.showInstructions();
      
    } else if (quitButton.isClicked(mouseX, mouseY)) {
      println("Saliendo del juego...");
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