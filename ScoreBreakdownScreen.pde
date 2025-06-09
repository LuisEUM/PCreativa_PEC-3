/**
 * Jardín Koi - ScoreBreakdownScreen
 * 
 * Pantalla de desglose detallado de la partida con tabs
 * para separar peces salvados y enemigos vencidos.
 */
class ScoreBreakdownScreen {
  ScreenManager screenManager;
  
  // Botones
  Button backButton;
  Button koiTabButton;
  Button enemyTabButton;
  
  // Estado
  String currentTab = "koi"; // "koi" o "enemy"
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 8;
  
  // Datos de la partida actual
  String gameMode = "waves"; // "waves" o "endless"
  int totalScore = 0;
  String survivalTime = "";
  int currentWave = 0;
  
  // Colores
  color backgroundColor = color(0, 0, 20);
  color panelColor = color(30, 50, 80);
  color titleColor = color(255, 215, 0); // Dorado
  color textColor = color(255, 255, 255);
  color tabActiveColor = color(255, 215, 0);
  color tabInactiveColor = color(100, 120, 150);
  color koiColor = color(100, 255, 100); // Verde
  color enemyColor = color(255, 100, 100); // Rojo
  
  /**
   * Constructor
   */
  ScoreBreakdownScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    setupButtons();
  }
  
  /**
   * Configura los botones
   */
  void setupButtons() {
    // Botón de volver
    backButton = new Button(width/2 - 100, height - 70, 200, 40, "Volver");
    backButton.setColors(color(80, 80, 100), color(100, 100, 120), color(255));
    
    // Tabs para cambiar entre desglose de koi y enemigos
    float tabWidth = 150;
    float tabHeight = 45;
    float tabY = 120;
    float centerX = width / 2;
    
    koiTabButton = new Button(centerX - tabWidth - 10, tabY, tabWidth, tabHeight, "PECES SALVADOS");
    enemyTabButton = new Button(centerX + 10, tabY, tabWidth, tabHeight, "ENEMIGOS VENCIDOS");
    
    updateTabColors();
  }
  
  /**
   * Actualiza los colores de las tabs según el tab activo
   */
  void updateTabColors() {
    if (currentTab.equals("koi")) {
      koiTabButton.setColors(tabActiveColor, color(255, 235, 50), color(0));
      enemyTabButton.setColors(tabInactiveColor, color(120, 140, 170), color(255));
    } else {
      koiTabButton.setColors(tabInactiveColor, color(120, 140, 170), color(255));
      enemyTabButton.setColors(tabActiveColor, color(255, 235, 50), color(0));
    }
  }
  
  /**
   * Muestra la pantalla con datos del juego actual
   */
  void show() {
    isVisible = true;
    fadeAlpha = 0;
    loadGameData();
  }
  
  /**
   * Carga los datos del juego actual
   */
  void loadGameData() {
    // Determinar si es waves o endless y cargar datos apropiados
    if (screenManager.wavesManager != null) {
      gameMode = "waves";
      currentWave = screenManager.wavesManager.uiManager.currentWave;
      // Calcular tiempo total del juego
      survivalTime = calculateWavesSurvivalTime();
    } else if (screenManager.endlessManager != null) {
      gameMode = "endless";
      survivalTime = calculateEndlessSurvivalTime();
    }
  }
  
  /**
   * Calcula el tiempo de supervivencia para Waves
   */
  String calculateWavesSurvivalTime() {
    if (screenManager.wavesManager == null) return "00:00";
    
    // Tiempo completo = (waves completadas - 1) * 2 minutos + tiempo actual
    int completedWaves = max(0, currentWave - 1);
    int completedTime = completedWaves * 120; // 2 minutos por wave
    
    // Tiempo actual en la wave
    float currentWaveTime = (millis() - screenManager.wavesManager.uiManager.waveStartTime) / 1000.0f;
    int currentTime = (int)min(120, currentWaveTime); // Máximo 2 minutos
    
    int totalSeconds = completedTime + currentTime;
    int minutes = totalSeconds / 60;
    int seconds = totalSeconds % 60;
    
    return nf(minutes, 2) + ":" + nf(seconds, 2);
  }
  
  /**
   * Calcula el tiempo de supervivencia para Endless
   */
  String calculateEndlessSurvivalTime() {
    if (screenManager.endlessManager == null) return "00:00";
    
    float timeInSeconds = (millis() - screenManager.endlessManager.uiManager.startTime) / 1000.0f;
    int minutes = (int)(timeInSeconds / 60);
    int seconds = (int)(timeInSeconds % 60);
    
    return nf(minutes, 2) + ":" + nf(seconds, 2);
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
      koiTabButton.update(mouseX, mouseY);
      enemyTabButton.update(mouseX, mouseY);
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
    
    // Panel principal con desglose
    renderBreakdownPanel();
    
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
    textSize(36);
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    text("DESGLOSE DETALLADO", width/2, 60);
    
    textSize(16);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    text("Análisis completo de tu partida", width/2, 90);
  }
  
  /**
   * Renderiza las tabs
   */
  void renderTabs() {
    if (isFullyVisible()) {
      renderTabButton(koiTabButton);
      renderTabButton(enemyTabButton);
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
    textSize(14);
    text(button.label, 
         button.position.x + button.width/2, 
         button.position.y + button.height/2);
  }
  
  /**
   * Renderiza el panel de desglose
   */
  void renderBreakdownPanel() {
    // Panel principal
    float panelWidth = 600;
    float panelHeight = 450;
    float panelX = (width - panelWidth) / 2;
    float panelY = 180;
    
    // Fondo del panel
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.9);
    stroke(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.5);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Contenido según el tab activo
    if (currentTab.equals("koi")) {
      renderKoiBreakdown(panelX, panelY);
    } else {
      renderEnemyBreakdown(panelX, panelY);
    }
    
  }
  
  /**
   * Renderiza el desglose de peces salvados
   */
  void renderKoiBreakdown(float x, float y) {
    // Título de sección
    textAlign(CENTER);
    textSize(24);
    fill(red(koiColor), green(koiColor), blue(koiColor), fadeAlpha);
    text("PECES SALVADOS", x + 300, y + 40);
    
    // Obtener datos reales del gameplay
    int[] koiCounts = getRealKoiStatsBySize();
    String[] koiSizes = {"XS (10-14)", "S (15-19)", "M (20-27)", "L (28-34)", "XL (35+)"};
    int[] koiPoints = {150, 500, 800, 1500, 3000}; // Puntos por tamaño
    
    textAlign(LEFT);
    textSize(16);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
    
    float startY = y + 80;
    float lineHeight = 35;
    
    for (int i = 0; i < koiSizes.length; i++) {
      float lineY = startY + (i * lineHeight);
      
      // Tamaño
      fill(red(koiColor), green(koiColor), blue(koiColor), fadeAlpha * 0.8);
      text(koiSizes[i] + ":", x + 50, lineY);
      
      // Cantidad
      fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
      text(koiCounts[i] + " peces", x + 200, lineY);
      
      // Puntos
      fill(255, 255, 100, fadeAlpha); // Amarillo para puntos
      text("(" + (koiCounts[i] * koiPoints[i]) + " pts)", x + 350, lineY);
    }
    
    // Total de peces
    float totalY = startY + (koiSizes.length * lineHeight) + 20;
    fill(red(koiColor), green(koiColor), blue(koiColor), fadeAlpha);
    textSize(18);
    int totalKoi = 0;
    int totalKoiPoints = 0;
    for (int i = 0; i < koiCounts.length; i++) {
      totalKoi += koiCounts[i];
      totalKoiPoints += koiCounts[i] * koiPoints[i];
    }
    text("TOTAL: " + totalKoi + " peces (" + totalKoiPoints + " pts)", x + 50, totalY);
  }
  
  /**
   * Renderiza el desglose de enemigos vencidos
   */
  void renderEnemyBreakdown(float x, float y) {
    // Título de sección
    textAlign(CENTER);
    textSize(24);
    fill(red(enemyColor), green(enemyColor), blue(enemyColor), fadeAlpha);
    text("ENEMIGOS VENCIDOS", x + 300, y + 40);
    
    // Obtener datos reales del gameplay
    int[] enemyCounts = getRealEnemyStatsByType();
    String[] enemyTypes = {"Bagres:", "Carpas:", "Lucios:", "Tiburones:"};
    int[] enemyPoints = {1500, 1600, 2000, 1000}; // Puntos por tipo
    
    textAlign(LEFT);
    textSize(16);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
    
    float startY = y + 80;
    float lineHeight = 35;
    
    for (int i = 0; i < enemyTypes.length; i++) {
      float lineY = startY + (i * lineHeight);
      
      // Tipo
      fill(red(enemyColor), green(enemyColor), blue(enemyColor), fadeAlpha * 0.8);
      text(enemyTypes[i], x + 50, lineY);
      
      // Cantidad
      fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
      text(enemyCounts[i] + " derrotados", x + 200, lineY);
      
      // Puntos
      fill(255, 255, 100, fadeAlpha); // Amarillo para puntos
      text("(" + (enemyCounts[i] * enemyPoints[i]) + " pts)", x + 350, lineY);
    }
    
    // Total de enemigos
    float totalY = startY + (enemyTypes.length * lineHeight) + 20;
    fill(red(enemyColor), green(enemyColor), blue(enemyColor), fadeAlpha);
    textSize(18);
    int totalEnemies = 0;
    int totalEnemyPoints = 0;
    for (int i = 0; i < enemyCounts.length; i++) {
      totalEnemies += enemyCounts[i];
      totalEnemyPoints += enemyCounts[i] * enemyPoints[i];
    }
    text("TOTAL: " + totalEnemies + " derrotados (" + totalEnemyPoints + " pts)", x + 50, totalY);
  }
  
  
  
  /**
   * Obtiene estadísticas reales de koi por tamaño
   */
  int[] getRealKoiStatsBySize() {
    int[] counts = new int[5]; // XS, S, M, L, XL
    
    if (gameMode.equals("waves") && screenManager.wavesManager != null) {
      ArrayList<Koi> kois = screenManager.wavesManager.koiManager.getKois();
      for (Koi koi : kois) {
        float length = koi.getCurrentAnimatedLength();
        if (length <= 14) counts[0]++; // XS
        else if (length <= 19) counts[1]++; // S
        else if (length <= 27) counts[2]++; // M
        else if (length <= 34) counts[3]++; // L
        else counts[4]++; // XL
      }
    } else if (gameMode.equals("endless") && screenManager.endlessManager != null) {
      ArrayList<Koi> kois = screenManager.endlessManager.koiManager.getKois();
      for (Koi koi : kois) {
        float length = koi.getCurrentAnimatedLength();
        if (length <= 14) counts[0]++; // XS
        else if (length <= 19) counts[1]++; // S
        else if (length <= 27) counts[2]++; // M
        else if (length <= 34) counts[3]++; // L
        else counts[4]++; // XL
      }
    }
    
    return counts;
  }
  
  /**
   * Obtiene estadísticas reales de enemigos por tipo
   */
  int[] getRealEnemyStatsByType() {
    int[] counts = new int[4]; // Bagres, Carpas, Lucios, Tiburones
    
    // Obtener datos del ScoreManager si está disponible
    ScoreManager scoreManager = screenManager.getScoreManager();
    if (scoreManager != null) {
      counts[0] = scoreManager.smallEnemiesDefeated; // Bagres
      counts[1] = scoreManager.mediumEnemiesDefeated; // Carpas  
      counts[2] = scoreManager.largeEnemiesDefeated; // Lucios
      counts[3] = scoreManager.sharkEnemiesDefeated; // Tiburones
    } else {
      // Datos por defecto si no hay ScoreManager
      counts = new int[]{15, 8, 4, 1};
    }
    
    return counts;
  }
  
  /**
   * Obtiene la puntuación total actual
   */
  int getTotalScore() {
    ScoreManager scoreManager = screenManager.getScoreManager();
    if (scoreManager != null) {
      return scoreManager.getCurrentScore();
    }
    return 15750; // Valor por defecto
  }
  
  /**
   * Obtiene la calificación de eficiencia
   */
  String getEfficiencyRating() {
    int score = getTotalScore();
    if (score > 15000) return "87% (Excelente)";
    if (score > 10000) return "75% (Muy Bueno)";
    if (score > 5000) return "60% (Bueno)";
    return "45% (Regular)";
  }
  
  /**
   * Obtiene el rango alcanzado
   */
  String getRankAchieved() {
    int score = getTotalScore();
    if (score > 25000) return "Maestro Koi";
    if (score > 15000) return "Guardian Koi";
    if (score > 10000) return "Protector Koi";
    return "Novato Koi";
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (backButton.isClicked(mouseX, mouseY)) {
      hide();
      screenManager.showVictoryScreen();
      
    } else if (koiTabButton.isClicked(mouseX, mouseY)) {
      currentTab = "koi";
      updateTabColors();
      
    } else if (enemyTabButton.isClicked(mouseX, mouseY)) {
      currentTab = "enemy";
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