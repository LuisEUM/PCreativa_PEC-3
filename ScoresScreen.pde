/**
 * Jardín Koi - ScoresScreen
 * 
 * Pantalla de puntuaciones que muestra el top 10 de scores
 * para los modos Waves y Endless.
 */
class ScoresScreen {
  ScreenManager screenManager;
  ScoreManager scoreManager;
  
  // Botones
  Button backButton;
  Button wavesTabButton;
  Button endlessTabButton;
  
  // Estado
  String currentTab = "waves"; // "waves" o "endless"
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 8;
  
  // Colores
  color backgroundColor = color(10, 20, 40);
  color panelColor = color(30, 50, 80);
  color titleColor = color(255, 215, 0); // Dorado
  color textColor = color(255, 255, 255);
  color tabActiveColor = color(255, 215, 0);
  color tabInactiveColor = color(100, 120, 150);
  
  /**
   * Constructor
   */
  ScoresScreen(ScreenManager screenManager, ScoreManager scoreManager) {
    this.screenManager = screenManager;
    this.scoreManager = scoreManager;
    setupButtons();
  }
  
  /**
   * Configura los botones
   */
  void setupButtons() {
    // Botón de volver
    backButton = new Button(50, height - 70, 120, 40, "VOLVER");
    backButton.setColors(color(80, 80, 100), color(100, 100, 120), color(255));
    
    // Tabs para cambiar entre modos
    float tabWidth = 150;
    float tabHeight = 45;
    float tabY = 120;
    float centerX = width / 2;
    
    wavesTabButton = new Button(centerX - tabWidth - 10, tabY, tabWidth, tabHeight, "WAVES");
    endlessTabButton = new Button(centerX + 10, tabY, tabWidth, tabHeight, "ENDLESS");
    
    updateTabColors();
  }
  
  /**
   * Actualiza los colores de las tabs según el tab activo
   */
  void updateTabColors() {
    if (currentTab.equals("waves")) {
      wavesTabButton.setColors(tabActiveColor, color(255, 235, 50), color(0));
      endlessTabButton.setColors(tabInactiveColor, color(120, 140, 170), color(255));
    } else {
      wavesTabButton.setColors(tabInactiveColor, color(120, 140, 170), color(255));
      endlessTabButton.setColors(tabActiveColor, color(255, 235, 50), color(0));
    }
  }
  
  /**
   * Muestra la pantalla
   */
  void show() {
    isVisible = true;
    fadeAlpha = 0;
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
      backButton.update(mouseX, mouseY);
      wavesTabButton.update(mouseX, mouseY);
      endlessTabButton.update(mouseX, mouseY);
    }
  }
  
  /**
   * Renderiza la pantalla
   */
  void render() {
    if (!isVisible) return;
    
    // Fondo
    background(red(backgroundColor), green(backgroundColor), blue(backgroundColor));
    
    // Título principal
    renderTitle();
    
    // Tabs
    renderTabs();
    
    // Panel principal con scores
    renderScoresPanel();
    
    // Botón de volver
    if (isFullyVisible()) {
      backButton.render();
    }
  }
  
  /**
   * Renderiza el título
   */
  void renderTitle() {
    textAlign(CENTER);
    textSize(42);
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    text("HALL DE LA FAMA", width/2, 70);
    
    textSize(16);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    text("Los mejores guardianes del estanque", width/2, 95);
  }
  
  /**
   * Renderiza las tabs
   */
  void renderTabs() {
    if (isFullyVisible()) {
      // Renderizar tabs con transparencia
      renderTabButton(wavesTabButton);
      renderTabButton(endlessTabButton);
    }
  }
  
  /**
   * Renderiza un botón de tab
   */
  void renderTabButton(Button button) {
    color currentColor = button.isHovered ? button.hoverColor : button.buttonColor;
    
    // Fondo del tab
    fill(red(currentColor), green(currentColor), blue(currentColor), fadeAlpha * 0.9);
    stroke(255, 255, 255, fadeAlpha * 0.3);
    strokeWeight(2);
    rect(button.position.x, button.position.y, button.width, button.height, 8, 8, 0, 0);
    
    // Texto del tab
    fill(red(button.textColor), green(button.textColor), blue(button.textColor), fadeAlpha);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Renderiza el panel de scores
   */
  void renderScoresPanel() {
    // Panel principal
    float panelWidth = 600;
    float panelHeight = 400;
    float panelX = (width - panelWidth) / 2;
    float panelY = 180;
    
    // Fondo del panel
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.9);
    stroke(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.5);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Encabezados
    renderScoreHeaders(panelX, panelY + 30);
    
    // Lista de scores
    if (currentTab.equals("waves")) {
      renderWavesScores(panelX, panelY + 70);
    } else {
      renderEndlessScores(panelX, panelY + 70);
    }
  }
  
  /**
   * Renderiza los encabezados de la tabla
   */
  void renderScoreHeaders(float x, float y) {
    textAlign(LEFT);
    textSize(16);
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    
    text("POS", x + 30, y);
    text("JUGADOR", x + 80, y);
    text("PUNTUACIÓN", x + 250, y);
    
    if (currentTab.equals("waves")) {
      text("OLEADAS", x + 380, y);
      text("FECHA", x + 480, y);
    } else {
      text("TIEMPO", x + 380, y);
      text("FECHA", x + 480, y);
    }
    
    // Línea separadora
    stroke(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.5);
    strokeWeight(1);
    line(x + 20, y + 15, x + 580, y + 15);
  }
  
  /**
   * Renderiza los scores del modo Waves
   */
  void renderWavesScores(float x, float y) {
    // Obtener datos reales del DataManager
    ArrayList<ScoreEntry> scores = screenManager.dataManager.getWavesScores();
    
    textAlign(LEFT);
    textSize(14);
    
    for (int i = 0; i < min(10, scores.size()); i++) {
      ScoreEntry entry = scores.get(i);
      float lineY = y + (i * 30);
      
      // Color según posición
      if (i == 0) {
        fill(255, 215, 0, fadeAlpha); // Oro
      } else if (i == 1) {
        fill(192, 192, 192, fadeAlpha); // Plata
      } else if (i == 2) {
        fill(205, 127, 50, fadeAlpha); // Bronce
      } else {
        fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
      }
      
      // Posición
      String position = (i + 1) + ".";
      
      text(position, x + 30, lineY);
      text(entry.playerName, x + 80, lineY);
      text(nfc(entry.score), x + 250, lineY);
      text(entry.getFormattedTime(), x + 380, lineY);
      text(entry.date, x + 480, lineY);
    }
  }
  
  /**
   * Renderiza los scores del modo Endless
   */
  void renderEndlessScores(float x, float y) {
    // Obtener datos reales del DataManager
    ArrayList<ScoreEntry> scores = screenManager.dataManager.getEndlessScores();
    
    textAlign(LEFT);
    textSize(14);
    
    for (int i = 0; i < min(10, scores.size()); i++) {
      ScoreEntry entry = scores.get(i);
      float lineY = y + (i * 30);
      
      // Color según posición
      if (i == 0) {
        fill(255, 215, 0, fadeAlpha); // Oro
      } else if (i == 1) {
        fill(192, 192, 192, fadeAlpha); // Plata
      } else if (i == 2) {
        fill(205, 127, 50, fadeAlpha); // Bronce
      } else {
        fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
      }
      
      // Posición
      String position = (i + 1) + ".";
      
      text(position, x + 30, lineY);
      text(entry.playerName, x + 80, lineY);
      text(nfc(entry.score), x + 250, lineY);
      text(entry.getFormattedTime(), x + 380, lineY);
      text(entry.date, x + 480, lineY);
    }
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (backButton.isClicked(mouseX, mouseY)) {
      hide();
      screenManager.returnToMenu();
      
    } else if (wavesTabButton.isClicked(mouseX, mouseY)) {
      currentTab = "waves";
      updateTabColors();
      
    } else if (endlessTabButton.isClicked(mouseX, mouseY)) {
      currentTab = "endless";
      updateTabColors();
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
} 