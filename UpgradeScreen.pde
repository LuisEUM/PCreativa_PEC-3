/**
 * UpgradeScreen
 * 
 * Pantalla de mejoras que aparece entre waves en el modo Waves.
 * Permite al jugador elegir entre 3 upgrades antes de continuar a la siguiente wave.
 */
class UpgradeScreen {
  ScreenManager screenManager;
  WavesUIManager wavesUI;
  
  // Botones de upgrade
  Button foodUpgradeButton;
  Button rockUpgradeButton;
  Button koiUpgradeButton;
  
  // Estado visual
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 8;
  
  // Información de la wave
  int completedWave = 0;
  int nextWave = 0;
  
  // Colores con mejor contraste y legibilidad
  color backgroundColor = color(25, 25, 40, 190); // Fondo más neutro
  color panelColor = color(40, 45, 60); // Panel con mejor contraste
  color titleColor = color(255, 215, 0); // Dorado brillante para títulos
  color textColor = color(255, 255, 255); // Blanco puro para mejor legibilidad
  color upgradeColor = color(100, 255, 100); // Verde brillante para destacar
  color accentColor = color(255, 255, 255); // Blanco para acentos
  
  // Variables para hover
  int hoveredUpgrade = 0; // 0: ninguno, 1: comida, 2: rocas, 3: peces
  
  /**
   * Constructor
   */
  UpgradeScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    setupButtons();
  }
  
  /**
   * Configura los botones de upgrade
   */
  void setupButtons() {
    float buttonWidth = 280; // Más ancho aprovechando el espacio
    float buttonHeight = 50; // Altura óptima
    float buttonSpacing = 25; // Espaciado adecuado
    float startY = height/2 - 80; // Mucho más arriba para aprovechar espacio
    
    // Centrar botones horizontalmente (columna única)
    float startX = (width - buttonWidth) / 2;
    
    // Botones en columna vertical con mejor contraste
    foodUpgradeButton = new Button(startX, startY, buttonWidth, buttonHeight, "");
    foodUpgradeButton.setColors(color(34, 139, 34), color(50, 205, 50), color(255)); // Verde con mejor contraste
    
    rockUpgradeButton = new Button(startX, startY + (buttonHeight + buttonSpacing), buttonWidth, buttonHeight, "");
    rockUpgradeButton.setColors(color(70, 130, 180), color(100, 149, 237), color(255)); // Azul con mejor contraste
    
    koiUpgradeButton = new Button(startX, startY + (buttonHeight + buttonSpacing) * 2, buttonWidth, buttonHeight, "");
    koiUpgradeButton.setColors(color(255, 140, 0), color(255, 165, 0), color(0)); // Naranja con texto negro para contraste
  }
  
  /**
   * Muestra la pantalla de upgrade
   */
  void show(int completedWave, WavesUIManager wavesUI) {
    this.completedWave = completedWave;
    this.nextWave = completedWave + 1;
    this.wavesUI = wavesUI;
    this.isVisible = true;
    this.fadeAlpha = 0;
    
    println("🎖️ Mostrando upgrades después de Wave " + completedWave);
  }
  
  /**
   * Actualiza la pantalla
   */
  void update() {
    if (isVisible && fadeAlpha < 255) {
      fadeAlpha = min(255, fadeAlpha + fadeSpeed);
    }
    if (isFullyVisible()) {
      foodUpgradeButton.update(mouseX, mouseY);
      rockUpgradeButton.update(mouseX, mouseY);
      koiUpgradeButton.update(mouseX, mouseY);
      // Detectar hover
      if (foodUpgradeButton.isHovered) hoveredUpgrade = 1;
      else if (rockUpgradeButton.isHovered) hoveredUpgrade = 2;
      else if (koiUpgradeButton.isHovered) hoveredUpgrade = 3;
      else hoveredUpgrade = 0;
    }
  }
  
  /**
   * Renderiza la pantalla
   */
  void render() {
    if (!isVisible) return;
    renderBackgroundOverlay();
    // Panel principal sin sombra superior/inferior
    float panelWidth = 600;
    float panelHeight = 600;
    float panelX = (width - panelWidth) / 2;
    float panelY = (height - panelHeight) / 2;
    renderMainPanel(panelX, panelY, panelWidth, panelHeight);
    renderTitle(panelY);
    renderWaveInfo(panelY);
    renderSeparatorLine(panelY + 155);
    if (isFullyVisible()) {
      renderUpgradeButtons(panelY + 180); // Subo los botones
      renderUpgradeHoverInfo(panelY + 155); // Info hover justo encima de la línea
    }
    renderInstructions();
  }
  
  /**
   * Renderiza el overlay de fondo con gradiente
   */
  void renderBackgroundOverlay() {
    // Gradiente de fondo
    for (int y = 0; y < height; y++) {
      float alpha = map(y, 0, height, fadeAlpha * 0.6, fadeAlpha * 0.9);
      color c = lerpColor(color(0, 0, 0, alpha), backgroundColor, 0.3);
      stroke(c);
      line(0, y, width, y);
    }
  }
  
  /**
   * Renderiza el panel principal con efectos mejorados
   */
  void renderMainPanel(float panelX, float panelY, float panelWidth, float panelHeight) {
    // Sombra múltiple para profundidad
    fill(0, 0, 0, fadeAlpha * 0.2);
    noStroke();
    rect(panelX + 12, panelY + 12, panelWidth, panelHeight, 20);
    fill(0, 0, 0, fadeAlpha * 0.3);
    rect(panelX + 6, panelY + 6, panelWidth, panelHeight, 20);
    
    // Panel principal con mejor contraste
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.98);
    stroke(200, 200, 200, fadeAlpha * 0.8);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 18);
    
    // Highlight superior para efecto 3D más sutil
    fill(255, 255, 255, fadeAlpha * 0.1);
    noStroke();
    rect(panelX + 4, panelY + 4, panelWidth - 8, 30, 15);
    
    // Borde interno sutil
    stroke(255, 255, 255, fadeAlpha * 0.3);
    strokeWeight(1);
    noFill();
    rect(panelX + 2, panelY + 2, panelWidth - 4, panelHeight - 4, 16);
  }
  
  /**
   * Renderiza línea separadora decorativa
   */
  void renderSeparatorLine(float y) {
    stroke(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.8);
    strokeWeight(2);
    float lineWidth = 350;
    line(width/2 - lineWidth/2, y, width/2 + lineWidth/2, y);
    
    // Puntos decorativos
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.8);
    noStroke();
    ellipse(width/2 - lineWidth/2 - 8, y, 5, 5);
    ellipse(width/2 + lineWidth/2 + 8, y, 5, 5);
  }
  
  /**
   * Renderiza las instrucciones con mejor estilo
   */
  void renderInstructions() {
    // Área de instrucciones más compacta
    float instructionHeight = 70;
    float instructionY = height - instructionHeight;
    
    // Fondo semi-transparente para las instrucciones
    fill(0, 0, 0, fadeAlpha * 0.5);
    noStroke();
    rect(0, instructionY, width, instructionHeight);
    
    // Línea separadora superior
    stroke(accentColor);
    strokeWeight(1);
    line(width/5, instructionY, 4*width/5, instructionY);
    
    // Texto de instrucciones centrado y legible
    fill(textColor);
    textAlign(CENTER);
    textSize(14);
    text("Elige una mejora para continuar", width/2, instructionY + 25);
    
    // Teclas de acceso rápido
    fill(titleColor);
    textSize(11);
    text("Teclas: 1, 2, 3", width/2, instructionY + 45);
  }
  
  /**
   * Renderiza el título de la pantalla
   */
  void renderTitle(float panelY) {
    // Sombra del título múltiple para profundidad
    fill(0, 0, 0, fadeAlpha * 0.8);
    textAlign(CENTER);
    textSize(32);
    text("OLEADA " + completedWave + " COMPLETADA!", width/2 + 4, panelY + 48);
    
    // Título principal con mejor contraste
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    textSize(32);
    text("OLEADA " + completedWave + " COMPLETADA!", width/2, panelY + 45);
    
    // Línea decorativa debajo del título
    stroke(titleColor);
    strokeWeight(2);
    float lineWidth = 250;
    line(width/2 - lineWidth/2, panelY + 60, width/2 + lineWidth/2, panelY + 60);
    
    // Subtítulo con mejor espaciado y contraste
    fill(textColor);
    textSize(18);
    text("Elige Tu Mejora", width/2, panelY + 85);
  }
  
  /**
   * Renderiza información de las waves
   */
  void renderWaveInfo(float panelY) {
    // Información de la siguiente wave con mejor diseño
    fill(red(upgradeColor), green(upgradeColor), blue(upgradeColor), fadeAlpha);
    textAlign(CENTER);
    textSize(15); // Tamaño ajustado
    
    String nextWaveText = "Siguiente: Oleada " + nextWave;
    if (nextWave <= 5) {
      String[] waveNames = {"", "DÍA", "ATARDECER", "NOCHE", "AMANECER", "DÍA"};
      nextWaveText += " - " + waveNames[nextWave];
    }
    
    text(nextWaveText, width/2, panelY + 105); // Posición ajustada
    
    // Progreso visual de waves
    renderWaveProgress(panelY + 130); // Posición ajustada
  }
  
  /**
   * Renderiza el progreso visual de las waves (más grande y visible)
   */
  void renderWaveProgress(float y) {
    float circleSize = 20; // Más grande
    float spacing = 40; // Más espaciado
    float startX = width/2 - (5 * spacing) / 2;
    
    for (int i = 1; i <= 5; i++) {
      float x = startX + (i - 1) * spacing;
      
      // Sombra del círculo
      fill(0, 0, 0, fadeAlpha * 0.3);
      noStroke();
      ellipse(x + 2, y + 2, circleSize, circleSize);
      
      // Círculo de fondo con mejor contraste
      if (i <= completedWave) {
        fill(red(upgradeColor), green(upgradeColor), blue(upgradeColor), fadeAlpha);
        stroke(255, 255, 255, fadeAlpha * 0.8);
      } else if (i == nextWave) {
        fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
        stroke(255, 255, 255, fadeAlpha * 0.8);
      } else {
        fill(80, 80, 80, fadeAlpha * 0.7);
        stroke(150, 150, 150, fadeAlpha * 0.5);
      }
      
      strokeWeight(2);
      ellipse(x, y, circleSize, circleSize);
      
      // Número de wave más legible
      fill(0, 0, 0, fadeAlpha); // Texto negro para mejor contraste
      textAlign(CENTER);
      textSize(12); // Más grande
      text(str(i), x, y + 4);
      
      // Línea conectora más visible
      if (i < 5) {
        stroke(accentColor);
        strokeWeight(3);
        line(x + circleSize/2, y, x + spacing - circleSize/2, y);
      }
    }
  }
  
  /**
   * Renderiza los botones de upgrade
   */
  void renderUpgradeButtons(float baseY) {
    float buttonWidth = 280;
    float buttonHeight = 50;
    float buttonSpacing = 30;
    float startX = (width - buttonWidth) / 2;
    float y1 = baseY + 20;
    float y2 = y1 + buttonHeight + buttonSpacing;
    float y3 = y2 + buttonHeight + buttonSpacing;
    foodUpgradeButton.position.x = startX;
    foodUpgradeButton.position.y = y1;
    foodUpgradeButton.width = buttonWidth;
    foodUpgradeButton.height = buttonHeight;
    rockUpgradeButton.position.x = startX;
    rockUpgradeButton.position.y = y2;
    rockUpgradeButton.width = buttonWidth;
    rockUpgradeButton.height = buttonHeight;
    koiUpgradeButton.position.x = startX;
    koiUpgradeButton.position.y = y3;
    koiUpgradeButton.width = buttonWidth;
    koiUpgradeButton.height = buttonHeight;
    renderUpgradeButton(foodUpgradeButton, "MEJORA COMIDA");
    renderUpgradeButton(rockUpgradeButton, "MEJORA ROCAS");
    renderUpgradeButton(koiUpgradeButton, "AGREGAR PECES");
  }
  
  /**
   * Renderiza un botón de upgrade individual (solo título)
   */
  void renderUpgradeButton(Button button, String title) {
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Sombra más profunda
    fill(0, 0, 0, fadeAlpha * 0.4);
    noStroke();
    rect(button.position.x + 4, button.position.y + 4, button.width, button.height, 12);
    
    // Botón principal
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.95);
    rect(button.position.x, button.position.y, button.width, button.height, 12);
    
    // Highlight superior para efecto 3D
    if (!button.isHovered) {
      fill(255, 255, 255, fadeAlpha * 0.2);
      rect(button.position.x + 3, button.position.y + 3, button.width - 6, button.height/4, 10);
    }
    
    // Borde con glow cuando hover
    if (button.isHovered) {
      stroke(255, 255, 255, fadeAlpha * 0.9);
      strokeWeight(3);
      noFill();
      rect(button.position.x - 1, button.position.y - 1, button.width + 2, button.height + 2, 13);
    }
    
    // Título centrado
    float centerX = button.position.x + button.width/2;
    float centerY = button.position.y + button.height/2;
    
    fill(button.textColor);
    textAlign(CENTER);
    textSize(16); // Más grande para mejor legibilidad
    text(title, centerX, centerY + 5);
  }
  
  void renderUpgradeHoverInfo(float y) {
    if (hoveredUpgrade == 0) return;
    String title = "";
    String bonus = "";
    String current = "";
    color bg = color(30, 30, 30, 230);
    color fg = color(255);
    if (hoveredUpgrade == 1) {
      title = "MEJORA COMIDA";
      bonus = "+20 Comida Máxima";
      current = "Actual: " + wavesUI.maxFood;
      bg = color(34, 139, 34, 230);
    } else if (hoveredUpgrade == 2) {
      title = "MEJORA ROCAS";
      bonus = "+20 Rocas Máximas";
      current = "Actual: " + wavesUI.maxRocks;
      bg = color(70, 130, 180, 230);
    } else if (hoveredUpgrade == 3) {
      title = "AGREGAR PECES";
      bonus = "+20 Nuevos Koi";
      current = "Actual: " + wavesUI.koiManager.getKoiCount();
      bg = color(255, 140, 0, 230);
      fg = color(30);
    }
    float boxW = 380;
    float boxH = 70;
    float boxX = width/2 - boxW/2;
    float boxY = height - 95 - boxH ;
    fill(bg);
    noStroke();
    rect(boxX, boxY, boxW, boxH, 14);
    fill(fg);
    textAlign(CENTER);
    textSize(18);
    text(title, width/2, boxY + 28);
    textSize(14);
    text(bonus, width/2, boxY + 48);
    textSize(12);
    text(current, width/2, boxY + 63);
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (foodUpgradeButton.isClicked(mouseX, mouseY)) {
      println("Mejora de comida seleccionada");
      applyUpgrade("food");
      
    } else if (rockUpgradeButton.isClicked(mouseX, mouseY)) {
      println("Mejora de rocas seleccionada");
      applyUpgrade("rock");
      
    } else if (koiUpgradeButton.isClicked(mouseX, mouseY)) {
      println("Mejora de koi seleccionada");
      applyUpgrade("koi");
    }
  }
  
  /**
   * Aplica el upgrade seleccionado
   */
  void applyUpgrade(String upgradeType) {
    switch(upgradeType) {
      case "food":
        wavesUI.maxFood += 20;
        // Reponer la comida al nuevo máximo
        wavesUI.foodCount = wavesUI.maxFood;
        println("Comida máxima aumentada a: " + wavesUI.maxFood);
        break;
        
      case "rock":
        wavesUI.maxRocks += 20;
        // Reponer las rocas al nuevo máximo
        wavesUI.rockCount = wavesUI.maxRocks;
        println("Rocas máximas aumentadas a: " + wavesUI.maxRocks);
        break;
        
      case "koi":
        // Agregar 20 peces nuevos aleatorios
        addRandomKoiFish(20);
        println("Agregados 20 peces nuevos. Total: " + wavesUI.koiManager.getKoiCount());
        break;
    }
    
    // Continuar a la siguiente wave
    continueToNextWave();
  }
  
  /**
   * Agrega peces koi aleatorios al estanque
   */
  void addRandomKoiFish(int count) {
    for (int i = 0; i < count; i++) {
      // Posición aleatoria
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      
      // Propiedades aleatorias
      float length = random(12, 25);
      
      // Color aleatorio
      String[] colors = {"#ff3333", "#ffffff", "#333333", "#ffd700", "#ff5500"};
      String koiColor = colors[(int)random(colors.length)];
      
      // Crear el pez sin restricciones de máximo usando el método especial
      wavesUI.koiManager.addKoiForced(x, y, length, koiColor);
    }
  }
  
  /**
   * Continúa a la siguiente wave
   */
  void continueToNextWave() {
    // Avanzar a la siguiente wave en WavesUIManager
    if (wavesUI != null) {
      wavesUI.advanceToNextWave();
    }
    
    hide();
    
    println("Continuando a la Oleada " + nextWave);
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    if (!isFullyVisible()) return;
    
    if (key == '1') {
      applyUpgrade("food");
    } else if (key == '2') {
      applyUpgrade("rock");
    } else if (key == '3') {
      applyUpgrade("koi");
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