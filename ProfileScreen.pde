/**
 * Jardín Koi - ProfileScreen
 * 
 * Pantalla de perfil de usuario que he implementado para permitir:
 * - Cambiar el nombre del jugador
 * - Ajustar el volumen de la música
 * - Ver estadísticas básicas del jugador
 */
class ProfileScreen {
  ScreenManager screenManager;
  
  // Botones
  Button backButton;
  Button saveButton;
  Button volumeDownButton;
  Button volumeUpButton;
  
  // Estado
  boolean isVisible = false;
  float fadeAlpha = 0;
  int fadeSpeed = 8;
  
  // Configuración del usuario
  String playerName = ""; // Se cargará desde DataManager
  String tempPlayerName = ""; // Nombre temporal mientras edita
  boolean editingName = false;
  int volume = 70; // Se cargará desde DataManager
  
  // Colores
  color backgroundColor = color(15, 25, 45);
  color panelColor = color(35, 55, 85);
  color titleColor = color(100, 149, 237); // Azul
  color textColor = color(255, 255, 255);
  color accentColor = color(100, 255, 100); // Verde
  
  /**
   * Constructor
   */
  ProfileScreen(ScreenManager screenManager) {
    this.screenManager = screenManager;
    setupButtons();
    
    // Cargar configuración inicial del DataManager
    loadInitialConfig();
  }
  
  /**
   * Carga la configuración inicial desde DataManager
   */
  void loadInitialConfig() {
    if (screenManager.dataManager != null) {
      UserConfig config = screenManager.dataManager.getUserConfig();
      playerName = config.playerName;
      volume = config.volume;
      tempPlayerName = playerName;
      println("🔧 Configuración inicial cargada: " + playerName + ", volumen: " + volume + "%");
    }
  }
  
  /**
   * Configura los botones
   */
  void setupButtons() {
    // Botón de volver
    backButton = new Button(50, height - 70, 120, 40, "VOLVER");
    backButton.setColors(color(80, 80, 100), color(100, 100, 120), color(255));
    
    // Botón de guardar
    saveButton = new Button(width - 170, height - 70, 120, 40, "GUARDAR");
    saveButton.setColors(color(60, 150, 100), color(80, 170, 120), color(255));
    
    // Los botones de volumen se configuran dinámicamente en setupVolumeButtons()
  }
  
  /**
   * Configura los botones de volumen basados en el layout actual
   */
  void setupVolumeButtons() {
    // Calcular posición basada en el panel y el área de volumen
    float panelX = 50;
    float panelY = 130;
    float marginX = panelX + 30;
    float volumeY = panelY + 220 + 25; // Posición del área de volumen + offset de la barra
    
    // Botones de volumen posicionados correctamente
    volumeDownButton = new Button(marginX, volumeY + 10, 40, 40, "-");
    volumeDownButton.setColors(color(150, 80, 80), color(170, 100, 100), color(255));
    
    volumeUpButton = new Button(marginX + 260, volumeY + 10, 40, 40, "+");
    volumeUpButton.setColors(color(80, 150, 80), color(100, 170, 100), color(255));
  }
  
  /**
   * Muestra la pantalla
   */
  void show() {
    isVisible = true;
    fadeAlpha = 0;
    
    // Cargar datos del usuario desde DataManager
    UserConfig config = screenManager.dataManager.getUserConfig();
    playerName = config.playerName;
    volume = config.volume;
    
    tempPlayerName = playerName; // Resetear nombre temporal
    editingName = false;
    
    // Configurar botones de volumen después de mostrar
    setupVolumeButtons();
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
      saveButton.update(mouseX, mouseY);
      if (volumeDownButton != null) volumeDownButton.update(mouseX, mouseY);
      if (volumeUpButton != null) volumeUpButton.update(mouseX, mouseY);
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
    
    // Panel principal
    renderProfilePanel();
    
    // Botones
    if (isFullyVisible()) {
      backButton.render();
      saveButton.render();
      if (volumeDownButton != null) volumeDownButton.render();
      if (volumeUpButton != null) volumeUpButton.render();
    }
  }
  
  /**
   * Renderiza el título
   */
  void renderTitle() {
    textAlign(CENTER);
    textSize(42);
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    text("PERFIL DE USUARIO", width/2, 70);
    
    textSize(16);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    text("Personaliza tu experiencia de juego", width/2, 95);
  }
  
  /**
   * Renderiza el panel principal
   */
  void renderProfilePanel() {
    // Panel principal con márgenes mejorados
    float panelWidth = width - 100; // Márgenes de 50px a cada lado
    float panelHeight = 350;
    float panelX = 50;
    float panelY = 130;
    
    // Fondo del panel
    fill(red(panelColor), green(panelColor), blue(panelColor), fadeAlpha * 0.9);
    stroke(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.5);
    strokeWeight(2);
    rect(panelX, panelY, panelWidth, panelHeight, 15);
    
    // Usar márgenes internos de 30px
    float marginX = panelX + 30;
    
    // Avatar del usuario
    renderUserAvatar(marginX, panelY + 40);
    
    // Información del usuario
    renderUserInfo(marginX + 120, panelY + 40);
    
    // Configuración de nombre
    renderNameSettings(marginX, panelY + 150);
    
    // Configuración de volumen
    renderVolumeSettings(marginX, panelY + 220);
    
    // Estadísticas básicas
    renderBasicStats(marginX, panelY + 330);
  }
  
  /**
   * Renderiza el avatar del usuario
   */
  void renderUserAvatar(float x, float y) {
    // Círculo de fondo
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha * 0.3);
    noStroke();
    ellipse(x + 40, y + 40, 80, 80);
    
    // Avatar vectorial
    pushMatrix();
    translate(x + 40, y + 40);
    
    float scale = 1.5;
    
    // Cabeza
    fill(255, 220, 177, fadeAlpha); // Color piel
    noStroke();
    ellipse(0, -8 * scale, 30 * scale, 30 * scale);
    
    // Cuerpo
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    arc(0, 15 * scale, 40 * scale, 30 * scale, PI, TWO_PI);
    
    // Ojos
    fill(50, 50, 50, fadeAlpha);
    ellipse(-6 * scale, -12 * scale, 3 * scale, 3 * scale);
    ellipse(6 * scale, -12 * scale, 3 * scale, 3 * scale);
    
    // Sonrisa
    noFill();
    stroke(50, 50, 50, fadeAlpha);
    strokeWeight(2 * scale);
    arc(0, -6 * scale, 12 * scale, 8 * scale, 0, PI);
    
    popMatrix();
  }
  
  /**
   * Renderiza la información básica del usuario
   */
  void renderUserInfo(float x, float y) {
    textAlign(LEFT);
    textSize(24);
    fill(red(titleColor), green(titleColor), blue(titleColor), fadeAlpha);
    text("¡Hola, " + playerName + "!", x, y + 25);
    
    textSize(14);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.8);
    text("Guardián del Estanque Koi", x, y + 50);
    text("Miembro desde: junio 2025", x, y + 70);
  }
  
  /**
   * Renderiza la configuración del nombre
   */
  void renderNameSettings(float x, float y) {
    textAlign(LEFT);
    textSize(18);
    fill(red(accentColor), green(accentColor), blue(accentColor), fadeAlpha);
    text("NOMBRE DE JUGADOR", x, y + 10);
    
    // Campo de texto para el nombre
    float fieldWidth = 200;
    float fieldHeight = 35;
    float fieldY = y + 20;
    
    // Fondo del campo
    if (editingName) {
      fill(255, 255, 255, fadeAlpha * 0.9);
      stroke(red(accentColor), green(accentColor), blue(accentColor), fadeAlpha);
    } else {
      fill(60, 60, 80, fadeAlpha * 0.7);
      stroke(120, 120, 140, fadeAlpha * 0.5);
    }
    strokeWeight(2);
    rect(x, fieldY, fieldWidth, fieldHeight, 5);
    
    // Texto del nombre
    textAlign(LEFT);
    textSize(16);
    if (editingName) {
      fill(0, 0, 0, fadeAlpha);
      text(tempPlayerName + (millis() % 1000 < 500 ? "|" : ""), x + 10, fieldY + 23);
    } else {
      fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
      text(playerName, x + 10, fieldY + 23);
    }
    
    // Instrucciones
    textSize(12);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.6);
    if (editingName) {
      text("Escribe tu nombre y presiona ENTER", x + 220, fieldY + 15);
      text("ESC para cancelar", x + 220, fieldY + 30);
    } else {
      text("Clic para editar", x + 220, fieldY + 23);
    }
  }
  
  /**
   * Renderiza la configuración del volumen
   */
  void renderVolumeSettings(float x, float y) {
    textAlign(LEFT);
    textSize(18);
    fill(red(accentColor), green(accentColor), blue(accentColor), fadeAlpha);
    text("VOLUMEN DE MUSICA", x, y + 25);
    
    // Barra de volumen
    float barWidth = 200;
    float barHeight = 20;
    float barY = y + 55;
    
    // Fondo de la barra
    fill(60, 60, 80, fadeAlpha * 0.7);
    stroke(120, 120, 140, fadeAlpha * 0.5);
    strokeWeight(1);
    rect(x + 50, barY - 10, barWidth, barHeight, 10);
    
    // Barra de progreso
    float progressWidth = map(volume, 0, 100, 0, barWidth);
    fill(red(accentColor), green(accentColor), blue(accentColor), fadeAlpha * 0.8);
    noStroke();
    rect(x + 50, barY -10, progressWidth, barHeight, 10);
    
    // Texto del volumen centrado en la barra
    textAlign(CENTER);
    textSize(14);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha);
    text(volume + "%", x + 150, barY + 5);
    
    // Los botones se renderizan automáticamente en render()
  }
  
  /**
   * Renderiza estadísticas básicas
   */
  void renderBasicStats(float x, float y) {
    textAlign(LEFT);
    textSize(14);
    fill(red(textColor), green(textColor), blue(textColor), fadeAlpha * 0.7);
    
    // Obtener estadísticas reales del DataManager
    UserConfig config = screenManager.dataManager.getUserConfig();
    String statsText = "Partidas jugadas: " + config.gamesPlayed + 
                      "  |  Mejor puntuacion: " + nfc(config.bestScore) + 
                      "  |  Tiempo total: " + screenManager.dataManager.formatTotalPlayTime();
    text(statsText, x, y);
  }
  
  /**
   * Maneja eventos de clic
   */
  void handleClick(float mouseX, float mouseY) {
    if (!isFullyVisible()) return;
    
    if (backButton.isClicked(mouseX, mouseY)) {
      hide();
      screenManager.returnToMenu();
      
    } else if (saveButton.isClicked(mouseX, mouseY)) {
      saveSettings();
      
    } else if (volumeDownButton != null && volumeDownButton.isClicked(mouseX, mouseY)) {
      volume = max(0, volume - 10);
      applyVolumeChange();
      println("Volumen bajado a: " + volume + "%");
      
    } else if (volumeUpButton != null && volumeUpButton.isClicked(mouseX, mouseY)) {
      volume = min(100, volume + 10);
      applyVolumeChange();
      println("Volumen subido a: " + volume + "%");
      
    } else {
      // Verificar clic en el campo de nombre
      float panelX = 50;
      float marginX = panelX + 30;
      float nameFieldX = marginX;
      float nameFieldY = 130 + 150 + 20;
      float nameFieldWidth = 200;
      float nameFieldHeight = 35;
      
      if (mouseX >= nameFieldX && mouseX <= nameFieldX + nameFieldWidth &&
          mouseY >= nameFieldY && mouseY <= nameFieldY + nameFieldHeight) {
        editingName = true;
        tempPlayerName = playerName;
      } else if (editingName) {
        // Clic fuera del campo, cancelar edición
        editingName = false;
        tempPlayerName = playerName;
      }
    }
  }
  
  /**
   * Maneja eventos de teclado
   */
  void handleKey(char key, int keyCode) {
    if (!isFullyVisible()) return;
    
    if (editingName) {
      if (keyCode == 10 || keyCode == 13) { // ENTER
        if (tempPlayerName.length() > 0) {
          playerName = tempPlayerName;
          editingName = false;
        }
      } else if (keyCode == 27) { // ESC
        editingName = false;
        tempPlayerName = playerName;
      } else if (keyCode == 8) { // BACKSPACE
        if (tempPlayerName.length() > 0) {
          tempPlayerName = tempPlayerName.substring(0, tempPlayerName.length() - 1);
        }
      } else if (key >= 32 && key <= 126 && tempPlayerName.length() < 15) { // Caracteres imprimibles
        tempPlayerName += key;
      }
    }
  }
  
  /**
   * Aplica inmediatamente el cambio de volumen al MusicManager
   */
  void applyVolumeChange() {
    if (screenManager.musicManager != null) {
      float volumeFloat = volume / 100.0; // Convertir de 0-100 a 0.0-1.0
      screenManager.musicManager.setVolume(volumeFloat);
    }
  }
  
  /**
   * Guarda la configuración
   */
  void saveSettings() {
    println("💾 ProfileScreen: Iniciando guardado de configuración...");
    println("📝 Datos a guardar - Nombre: '" + playerName + "', Volumen: " + volume + "%");
    
    // Guardar en DataManager
    screenManager.dataManager.updatePlayerName(playerName);
    screenManager.dataManager.updateVolume(volume);
    
    // Aplicar volumen a la música
    applyVolumeChange();
    
    println("✅ ProfileScreen: Configuración guardada exitosamente!");
    
    // Mostrar confirmación visual
    // TODO: Añadir notificación de guardado exitoso
  }
  
  /**
   * Obtiene el nombre del jugador actual
   */
  String getPlayerName() {
    return playerName;
  }
  
  /**
   * Obtiene el volumen actual
   */
  int getVolume() {
    return volume;
  }
  
  /**
   * Establece el nombre del jugador
   */
  void setPlayerName(String name) {
    if (name != null && name.length() > 0) {
      this.playerName = name;
      this.tempPlayerName = name;
    }
  }
  
  /**
   * Establece el volumen
   */
  void setVolume(int vol) {
    this.volume = constrain(vol, 0, 100);
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
    editingName = false;
  }
} 