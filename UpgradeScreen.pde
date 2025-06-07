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
  
  // Colores
  color backgroundColor = color(0, 0, 0, 180);
  color panelColor = color(40, 40, 60);
  color titleColor = color(255, 215, 0); // Dorado
  color textColor = color(255, 255, 255);
  color upgradeColor = color(100, 255, 100); // Verde
  
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
    float buttonWidth = 180;
    float buttonHeight = 100;
    float buttonSpacing = 30;
    float startY = height/2 + 40;
    
    // Centrar botones horizontalmente
    float totalWidth = (buttonWidth * 3) + (buttonSpacing * 2);
    float startX = (width - totalWidth) / 2;
    
    foodUpgradeButton = new Button(startX, startY, buttonWidth, buttonHeight, "");
    foodUpgradeButton.setColors(color(76, 175, 80), color(129, 199, 132), color(255));
    
    rockUpgradeButton = new Button(startX + buttonWidth + buttonSpacing, startY, buttonWidth, buttonHeight, "");
    rockUpgradeButton.setColors(color(96, 125, 139), color(144, 164, 174), color(255));
    
    koiUpgradeButton = new Button(startX + (buttonWidth + buttonSpacing) * 2, startY, buttonWidth, buttonHeight, "");
    koiUpgradeButton.setColors(color(255, 152, 0), color(255, 183, 77), color(255));
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
    
    // Actualizar botones solo cuando esté completamente visible
    if (isFullyVisible()) {
      foodUpgradeButton.update(mouseX, mouseY);
      rockUpgradeButton.update(mouseX, mouseY);
      koiUpgradeButton.update(mouseX, mouseY);
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
    
    // Panel principal más grande
    float panelWidth = 750;
    float panelHeight = 450;
    float panelX = (width - panelWidth) / 2;
    float panelY = (height - panelHeight) / 2 - 10;
    
    // Fondo del panel
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.95);
    stroke(150, 150, 150, fadeAlpha);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Título
    renderTitle(panelY);
    
    // Información de waves
    renderWaveInfo(panelY);
    
    // Renderizar botones de upgrade si está completamente visible
    if (isFullyVisible()) {
      renderUpgradeButtons();
    }
    
    // Instrucciones
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    textAlign(CENTER);
    textSize(13);
    text("Choose one upgrade to continue to the next wave • Keys: 1, 2, 3", width/2, height - 40);
  }
  
  /**
   * Renderiza el título de la pantalla
   */
  void renderTitle(float panelY) {
    // Sombra del título
    fill(0, 0, 0, fadeAlpha * 0.6);
    textAlign(CENTER);
    textSize(32);
    text("WAVE " + completedWave + " COMPLETE!", width/2 + 2, panelY + 52);
    
    // Título principal
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    textSize(32);
    text("WAVE " + completedWave + " COMPLETE!", width/2, panelY + 50);
    
    // Subtítulo
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.9);
    textSize(18);
    text("Choose Your Upgrade", width/2, panelY + 85);
  }
  
  /**
   * Renderiza información de las waves
   */
  void renderWaveInfo(float panelY) {
    fill(red(upgradeColor), green(upgradeColor), blue(upgradeColor), fadeAlpha);
    textAlign(CENTER);
    textSize(14);
    
    String nextWaveText = "Next: Wave " + nextWave;
    if (nextWave <= 5) {
      String[] waveNames = {"", "DAY", "SUNSET", "NIGHT", "DAWN", "DAY"};
      nextWaveText += " - " + waveNames[nextWave];
    }
    
    text(nextWaveText, width/2, panelY + 110);
  }
  
  /**
   * Renderiza los botones de upgrade
   */
  void renderUpgradeButtons() {
    // Botón de comida
    renderUpgradeButton(foodUpgradeButton, "🍞", "FOOD UPGRADE", "+20 Max Food", "Current: " + wavesUI.maxFood);
    
    // Botón de rocas
    renderUpgradeButton(rockUpgradeButton, "🪨", "ROCK UPGRADE", "+20 Max Rocks", "Current: " + wavesUI.maxRocks);
    
    // Botón de koi - ahora agrega peces en lugar de aumentar máximo
    int currentFish = wavesUI.koiManager.getKoiCount();
    renderUpgradeButton(koiUpgradeButton, "🐟", "ADD FISH", "+20 New Koi Fish", "Current: " + currentFish);
  }
  
  /**
   * Renderiza un botón de upgrade individual
   */
  void renderUpgradeButton(Button button, String emoji, String title, String upgrade, String current) {
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Sombra más pronunciada
    fill(0, 0, 0, fadeAlpha * 0.6);
    noStroke();
    rect(button.position.x + 5, button.position.y + 5, button.width, button.height, 12);
    
    // Botón principal
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.95);
    rect(button.position.x, button.position.y, button.width, button.height, 12);
    
    // Highlight superior para efecto 3D
    if (!button.isHovered) {
      fill(255, 255, 255, fadeAlpha * 0.25);
      rect(button.position.x + 3, button.position.y + 3, button.width - 6, button.height/4, 10);
    }
    
    // Borde con glow cuando hover
    if (button.isHovered) {
      stroke(255, 255, 255, fadeAlpha * 0.9);
      strokeWeight(4);
      noFill();
      rect(button.position.x - 2, button.position.y - 2, button.width + 4, button.height + 4, 14);
    }
    
    // Contenido del botón
    float centerX = button.position.x + button.width/2;
    float centerY = button.position.y + button.height/2;
    
    // Emoji más grande
    fill(255, 255, 255, fadeAlpha);
    textAlign(CENTER);
    textSize(32);
    text(emoji, centerX, centerY - 25);
    
    // Título
    textSize(13);
    fill(255, 255, 255, fadeAlpha);
    text(title, centerX, centerY + 5);
    
    // Descripción del upgrade
    fill(255, 255, 150, fadeAlpha);
    textSize(11);
    text(upgrade, centerX, centerY + 22);
    
    // Estado actual
    fill(220, 220, 220, fadeAlpha * 0.9);
    textSize(10);
    text(current, centerX, centerY + 37);
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (foodUpgradeButton.isClicked(mouseX, mouseY)) {
      println("🍞 Upgrade de comida seleccionado");
      applyUpgrade("food");
      
    } else if (rockUpgradeButton.isClicked(mouseX, mouseY)) {
      println("🪨 Upgrade de rocas seleccionado");
      applyUpgrade("rock");
      
    } else if (koiUpgradeButton.isClicked(mouseX, mouseY)) {
      println("🐟 Upgrade de koi seleccionado");
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
        println("📈 Max Food aumentado a: " + wavesUI.maxFood);
        break;
        
      case "rock":
        wavesUI.maxRocks += 20;
        // Reponer las rocas al nuevo máximo
        wavesUI.rockCount = wavesUI.maxRocks;
        println("📈 Max Rocks aumentado a: " + wavesUI.maxRocks);
        break;
        
      case "koi":
        // Agregar 20 peces nuevos aleatorios
        addRandomKoiFish(20);
        println("🐟 Agregados 20 peces nuevos. Total: " + wavesUI.koiManager.getKoiCount());
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
    
    println("🌊 Continuando a Wave " + nextWave);
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