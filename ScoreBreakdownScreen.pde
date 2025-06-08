class ScoreBreakdownScreen {
  ScoreManager scoreManager;
  ScreenManager screenManager;
  Button backButton;
  
  ScoreBreakdownScreen(ScoreManager scoreManager, ScreenManager screenManager) {
    this.scoreManager = scoreManager;
    this.screenManager = screenManager;
    this.backButton = new Button(width/2 - 100, height - 50, 200, 40, "Volver");
  }
  
  void update() {
    // Actualizar estado del botón
    backButton.update(mouseX, mouseY);
  }
  
  void render() {
    background(0, 0, 20); // Fondo azul muy oscuro
    
    // Título principal
    textAlign(CENTER);
    textSize(36);
    fill(255, 215, 0); // Dorado
    text("DESGLOSE DETALLADO", width/2, 60);
    
    // Subtítulo
    textSize(16);
    fill(200, 220, 240);
    text("Análisis completo de tu partida", width/2, 90);
    
    // Panel principal
    renderMainPanel();
    
    // Botón de volver
    backButton.render();
  }
  
  void renderMainPanel() {
    // Panel con márgenes mejorados
    float panelWidth = width - 100; // Márgenes de 50px a cada lado
    float panelHeight = 400;
    float panelX = 50;
    float panelY = 120;
    
    // Fondo del panel
    fill(20, 30, 50, 200);
    stroke(100, 150, 200, 100);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Dividir en dos columnas con márgenes internos
    float marginX = panelX + 30;
    float colWidth = (panelWidth - 90) / 2; // Ancho de columna considerando márgenes
    float leftCol = marginX;
    float rightCol = marginX + colWidth + 30; // 30px de separación entre columnas
    float startY = panelY + 30;
    
    // Columna izquierda: Peces Salvados
    renderKoiBreakdown(leftCol, startY);
    
    // Columna derecha: Enemigos Vencidos  
    renderEnemyBreakdown(rightCol, startY);
    
    // Estadísticas generales en la parte inferior
    renderGeneralStats(marginX, panelY + 330);
  }
  
  void renderKoiBreakdown(float x, float y) {
    // Título de sección
    textAlign(LEFT);
    textSize(20);
    fill(100, 255, 100); // Verde brillante
    text("PECES SALVADOS", x, y);
    
    // Obtener datos reales del gameplay
    String[] koiSizes = {"XS (10-14)", "S (15-19)", "M (20-27)", "L (28-34)", "XL (35+)"};
    int[] koiCounts = screenManager.dataManager.getKoiStatsBySize(screenManager.wavesManager);
    int[] koiPoints = {50, 100, 200, 400, 800}; // Puntos por tamaño
    
    textSize(14);
    fill(255);
    
    float lineY = y + 30;
    for (int i = 0; i < koiSizes.length; i++) {
      fill(180, 255, 180); // Verde claro
      text(koiSizes[i] + ":", x + 10, lineY);
      fill(255);
      text(koiCounts[i] + " peces", x + 120, lineY);
      fill(255, 255, 100); // Amarillo para puntos
      text("(" + (koiCounts[i] * koiPoints[i]) + " pts)", x + 200, lineY);
      lineY += 25;
    }
    
    // Total de peces
    lineY += 10;
    fill(100, 255, 100);
    textSize(16);
    int totalKoi = 0;
    int totalKoiPoints = 0;
    for (int i = 0; i < koiCounts.length; i++) {
      totalKoi += koiCounts[i];
      totalKoiPoints += koiCounts[i] * koiPoints[i];
    }
    text("TOTAL: " + totalKoi + " peces (" + totalKoiPoints + " pts)", x + 10, lineY);
  }
  
  void renderEnemyBreakdown(float x, float y) {
    // Título de sección
    textAlign(LEFT);
    textSize(20);
    fill(255, 100, 100); // Rojo brillante
    text("ENEMIGOS VENCIDOS", x, y);
    
    // Obtener datos reales del gameplay
    String[] enemyTypes = {"Bagres", "Carpas", "Lucios", "Tiburones"};
    int[] enemyCounts = screenManager.dataManager.getEnemyStatsByType(screenManager.wavesManager);
    int[] enemyPoints = {100, 200, 500, 1000}; // Puntos por tipo
    
    textSize(14);
    fill(255);
    
    float lineY = y + 30;
    for (int i = 0; i < enemyTypes.length; i++) {
      fill(255, 180, 180); // Rojo claro
      text(enemyTypes[i] + ":", x + 10, lineY);
      fill(255);
      text(enemyCounts[i] + " derrotados", x + 120, lineY);
      fill(255, 255, 100); // Amarillo para puntos
      text("(" + (enemyCounts[i] * enemyPoints[i]) + " pts)", x + 220, lineY);
      lineY += 25;
    }
    
    // Total de enemigos
    lineY += 10;
    fill(255, 100, 100);
    textSize(16);
    int totalEnemies = 0;
    int totalEnemyPoints = 0;
    for (int i = 0; i < enemyCounts.length; i++) {
      totalEnemies += enemyCounts[i];
      totalEnemyPoints += enemyCounts[i] * enemyPoints[i];
    }
    text("TOTAL: " + totalEnemies + " derrotados (" + totalEnemyPoints + " pts)", x + 10, lineY);
  }
  
  void renderGeneralStats(float x, float y) {
    // Línea separadora
    stroke(100, 150, 200);
    strokeWeight(1);
    line(x, y - 10, x + 600, y - 10);
    
    // Estadísticas generales
    textAlign(LEFT);
    textSize(18);
    fill(255, 215, 0); // Dorado
    text("RESUMEN GENERAL", x, y + 15);
    
    textSize(14);
    fill(255);
    text("Tiempo de Supervivencia: 12:34", x + 20, y + 45);
    text("Puntuacion Total: 15,750 puntos", x + 20, y + 65);
    text("Eficiencia: 87% (Excelente)", x + 320, y + 45);
    text("Rango Alcanzado: Guardian Koi", x + 320, y + 65);
  }
  
  void handleClick(float mouseX, float mouseY) {
    if (backButton.isClicked(mouseX, mouseY)) {
      // Volver a la pantalla de victoria
      screenManager.showVictoryScreen();
    }
  }
} 