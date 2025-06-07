/**
 * Jardín Koi  - ScreenManager
 * 
 * Gestor principal de estados y pantallas para los tres modos de juego:
 * - Waves: Juego de 5 rondas con oleadas programadas
 * - Endless: Supervivencia infinita con escalada de dificultad
 * - Zen: Simulación relajante original
 * 
 * RESPONSABILIDADES:
 * - Controlar transiciones entre estados del juego
 * - Manejar el sistema de pausa universal
 * - Coordinar todos los managers según el estado actual
 * - Gestionar eventos de entrada (mouse/teclado) por estado
 * - Preservar estado durante pausas
 * 
 * ARQUITECTURA:
 * - Estado centralizado con enum de estados
 * - Patrón State para manejar comportamiento por estado
 * - Sistema de pausa que preserva estado completo
 * 
 * CÓDIGO ORIGINAL: 100% (nueva implementación para el sistema de juego)
 */

// Estados del juego
enum GameState {
  MAIN_MENU,        // Pantalla de inicio con selección de modo
  INSTRUCTIONS,     // Pantalla de instrucciones  
  ZEN_MODE,         // Modo de simulación relajante (código original)
  WAVES_PREP,       // Preparación de ronda (solo Modo Waves)
  WAVES_ACTIVE,     // Gameplay activo Modo Waves
  ENDLESS_ACTIVE,   // Gameplay activo Modo Endless  
  UPGRADE_SCREEN,   // Pantalla de upgrades entre waves
  PAUSED,           // Pantalla de pausa (disponible desde cualquier modo activo)
  ROUND_COMPLETE,   // Evaluación y mejoras (solo Modo Waves)
  GAME_OVER,        // Pantalla de derrota (Waves & Endless)
  GAME_WON,         // Pantalla de victoria (solo Modo Waves)
  VICTORY           // Pantalla de felicitaciones por completar Wave 5
}

class ScreenManager {
  // Estado actual del juego
  GameState currentState;
  GameState previousState;  // Para regresar de pausa
  
  // Managers específicos por modo
  PondManager pondManager;         // Para Modo Zen (código original)
  WavesManager wavesManager;       // Para Modo Waves (sin botón de crear)
  GameManager gameManager;         // Para Modo Waves  
  EndlessManager endlessManager;   // Para Modo Endless
  ScoreManager scoreManager;       // Sistema de puntuación
  ProgressManager progressManager; // Sistema de progreso y desbloqueos
  
  // UI y pantallas
  MainMenu mainMenu;
  InstructionsScreen instructionsScreen;
  PauseScreen pauseScreen;
  GameOverScreen gameOverScreen;
  UpgradeScreen upgradeScreen;
  VictoryScreen victoryScreen;
  
  // Variables de control
  boolean isGameActive;
  PApplet app;  // Referencia a la aplicación principal
  
  /**
   * Constructor
   */
  ScreenManager(PApplet app) {
    this.app = app;
    this.currentState = GameState.MAIN_MENU;
    this.previousState = GameState.MAIN_MENU;
    this.isGameActive = false;
    
    // Inicializar componentes básicos
    initializeComponents();
  }
  
  /**
   * Inicializa todos los componentes del sistema
   */
  void initializeComponents() {
    // Managers del juego
    this.scoreManager = new ScoreManager();
    this.progressManager = new ProgressManager();
    this.pondManager = new PondManager(app);  // Para Modo Zen
    
    // UI y pantallas
    this.mainMenu = new MainMenu(this);
    this.instructionsScreen = new InstructionsScreen(this);
    this.pauseScreen = new PauseScreen(this);
    this.gameOverScreen = new GameOverScreen(this);
    this.upgradeScreen = new UpgradeScreen(this);
    this.victoryScreen = new VictoryScreen(this);
    
    println("🎮 ScreenManager inicializado con estado: " + currentState);
  }
  
  /**
   * Actualización principal - se llama desde draw()
   */
  void update() {
    switch(currentState) {
      case MAIN_MENU:
        updateMainMenu();
        break;
        
      case INSTRUCTIONS:
        updateInstructions();
        break;
        
      case ZEN_MODE:
        updateZenMode();
        break;
        
      case WAVES_PREP:
        updateWavesPrep();
        break;
        
      case WAVES_ACTIVE:
        updateWavesActive();
        break;
        
      case ENDLESS_ACTIVE:
        updateEndlessActive();
        break;
        
      case UPGRADE_SCREEN:
        updateUpgradeScreen();
        break;
        
      case PAUSED:
        updatePaused();
        break;
        
      case ROUND_COMPLETE:
        updateRoundComplete();
        break;
        
      case GAME_OVER:
        updateGameOver();
        break;
        
      case GAME_WON:
        updateGameWon();
        break;
        
      case VICTORY:
        updateVictory();
        break;
    }
  }
  
  /**
   * Renderizado principal - se llama desde draw()
   */
  void render() {
    switch(currentState) {
      case MAIN_MENU:
        renderMainMenu();
        break;
        
      case INSTRUCTIONS:
        renderInstructions();
        break;
        
      case ZEN_MODE:
        renderZenMode();
        break;
        
      case WAVES_PREP:
        renderWavesPrep();
        break;
        
      case WAVES_ACTIVE:
        renderWavesActive();
        break;
        
      case ENDLESS_ACTIVE:
        renderEndlessActive();
        break;
        
      case UPGRADE_SCREEN:
        renderUpgradeScreen();
        break;
        
      case PAUSED:
        renderPaused();
        break;
        
      case ROUND_COMPLETE:
        renderRoundComplete();
        break;
        
      case GAME_OVER:
        renderGameOver();
        break;
        
      case GAME_WON:
        renderGameWon();
        break;
        
      case VICTORY:
        renderVictory();
        break;
    }
  }
  
  // ===============================================
  // MÉTODOS DE ACTUALIZACIÓN POR ESTADO
  // ===============================================
  
  void updateMainMenu() {
    if (mainMenu != null) {
      mainMenu.update();
    }
  }
  
  void updateInstructions() {
    // Actualizar la pantalla de instrucciones
    if (instructionsScreen != null) {
      instructionsScreen.update();
    }
  }
  
  void updateZenMode() {
    if (pondManager != null) {
      pondManager.update();
    }
  }
  
  void updateWavesPrep() {
    // Preparación de ronda - lógica futura
  }
  
  void updateWavesActive() {
    if (wavesManager != null) {
      wavesManager.update();
      
      // Verificar si todos los kois han muerto
      if (wavesManager.koiManager.getKoiCount() == 0) {
        // Calcular tiempo total del juego (todas las waves completadas + tiempo actual)
        float totalGameTime = ((wavesManager.uiManager.currentWave - 1) * 120.0f) + 
                             ((millis() - wavesManager.uiManager.waveStartTime) / 1000.0f);
        showGameOver("waves", 0, getFormattedTimeFloat(totalGameTime), wavesManager.uiManager.currentWave);
      }
      
      // Verificar si se completó Wave 5 (la última)
      if (wavesManager.uiManager.currentWave == 5 && wavesManager.uiManager.waveComplete && !upgradeScreen.isShowing()) {
        // ¡Wave 5 completada! Mostrar pantalla de victoria
        progressManager.completeWaves();
        showVictoryScreen();
        return;
      }
      
      // Verificar si la wave se completó y necesita upgrade
      if (wavesManager.uiManager.waveComplete && wavesManager.uiManager.currentWave <= 5 && !upgradeScreen.isShowing()) {
        showUpgradeScreen(wavesManager.uiManager.currentWave);
      }
    }
  }
  
  void updateEndlessActive() {
    if (endlessManager != null) {
      endlessManager.update();
      
      // Verificar si todos los kois han muerto
      if (endlessManager.koiManager.getKoiCount() == 0) {
        showGameOver("endless", endlessManager.uiManager.score, getFormattedTime(endlessManager.uiManager.startTime), 0);
      }
    }
  }
  
  void updateUpgradeScreen() {
    if (upgradeScreen != null) {
      upgradeScreen.update();
      
      // Si la upgrade screen se oculta, volver al juego
      if (!upgradeScreen.isShowing()) {
        changeState(GameState.WAVES_ACTIVE);
      }
    }
  }
  
  void updatePaused() {
    // Durante pausa, no actualizamos nada del juego
    if (pauseScreen != null) {
      pauseScreen.update();
    }
  }
  
  void updateRoundComplete() {
    // Pantalla de mejoras - lógica futura
  }
  
  void updateGameOver() {
    if (gameOverScreen != null) {
      gameOverScreen.update();
    }
  }
  
  void updateGameWon() {
    // Victoria - estático
  }
  
  void updateVictory() {
    if (victoryScreen != null) {
      victoryScreen.update();
    }
  }
  
  // ===============================================
  // MÉTODOS DE RENDERIZADO POR ESTADO
  // ===============================================
  
  void renderMainMenu() {
    if (mainMenu != null) {
      mainMenu.render();
    }
  }
  
  void renderInstructions() {
    if (instructionsScreen != null) {
      instructionsScreen.render();
    }
  }
  
  void renderZenMode() {
    if (pondManager != null) {
      pondManager.render();
    }
  }
  
  void renderWavesPrep() {
    // Renderizado de preparación - futuro
  }
  
  void renderWavesActive() {
    if (wavesManager != null) {
      wavesManager.render();
    }
  }
  
  void renderEndlessActive() {
    if (endlessManager != null) {
      endlessManager.render();
    }
  }
  
  void renderUpgradeScreen() {
    // Renderizar el juego de fondo (congelado)
    if (wavesManager != null) {
      wavesManager.render();
    }
    
    // Renderizar la pantalla de upgrade encima
    if (upgradeScreen != null) {
      upgradeScreen.render();
    }
  }
  
  void renderPaused() {
    // Primero renderizamos el estado previo (congelado)
    renderPreviousState();
    
    // Luego renderizamos la pantalla de pausa encima
    if (pauseScreen != null) {
      pauseScreen.render();
    }
  }
  
  void renderRoundComplete() {
    // Renderizado de mejoras - futuro
  }
  
  void renderGameOver() {
    if (gameOverScreen != null) {
      gameOverScreen.render();
    }
  }
  
  void renderGameWon() {
    if (victoryScreen != null) {
      victoryScreen.render();
    }
  }
  
  void renderVictory() {
    if (victoryScreen != null) {
      victoryScreen.render();
    }
  }
  
  /**
   * Renderiza el estado previo (para mostrar durante pausa)
   */
  void renderPreviousState() {
    switch(previousState) {
      case ZEN_MODE:
        if (pondManager != null) pondManager.render();
        break;
      case WAVES_ACTIVE:
        if (wavesManager != null) wavesManager.render();
        break;
      case ENDLESS_ACTIVE:
        if (endlessManager != null) endlessManager.render();
        break;
    }
  }
  
  // ===============================================
  // GESTIÓN DE ESTADOS Y TRANSICIONES
  // ===============================================
  
  /**
   * Cambia a un nuevo estado
   */
  void changeState(GameState newState) {
    println("🔄 Cambiando estado: " + currentState + " → " + newState);
    
    // Limpieza del estado anterior
    exitCurrentState();
    
    // Guardar estado previo (para pausa)
    if (newState != GameState.PAUSED) {
      this.previousState = this.currentState;
    }
    
    // Cambiar al nuevo estado
    this.currentState = newState;
    
    // Inicialización del nuevo estado
    enterNewState();
  }
  
  /**
   * Limpieza al salir del estado actual
   */
  void exitCurrentState() {
    switch(currentState) {
      case ZEN_MODE:
        // Zen mode no necesita limpieza especial
        break;
      case WAVES_ACTIVE:
        // Pausar timers si es necesario
        break;
      case ENDLESS_ACTIVE:
        // Pausar timers si es necesario
        break;
    }
  }
  
  /**
   * Inicialización al entrar al nuevo estado
   */
  void enterNewState() {
    switch(currentState) {
      case MAIN_MENU:
        isGameActive = false;
        break;
        
      case ZEN_MODE:
        isGameActive = true;
        initializeZenMode();
        break;
        
      case WAVES_ACTIVE:
        isGameActive = true;
        initializeWavesMode();
        break;
        
      case ENDLESS_ACTIVE:
        isGameActive = true;
        initializeEndlessMode();
        break;
        
      case PAUSED:
        // Pausa preserva el estado, no cambiamos isGameActive
        break;
        
      case GAME_OVER:
      case GAME_WON:
        isGameActive = false;
        break;
    }
  }
  
  /**
   * Inicializa el Modo Zen (código original)
   */
  void initializeZenMode() {
    if (pondManager == null) {
      pondManager = new PondManager(app);
    }
    // El pondManager ya tiene la lógica original completa
  }
  
  /**
   * Inicializa el Modo Waves
   */
  void initializeWavesMode() {
    // Solo crear un nuevo WavesManager si no existe (para restart limpio)
    // Si ya existe, mantener el progreso actual
    if (wavesManager == null) {
      wavesManager = new WavesManager(app);
      println("🌊 Inicializando Modo Waves (nuevo manager)...");
    } else {
      println("🔄 Reanudando Modo Waves (manteniendo progreso)...");
    }
  }
  
  /**
   * Inicializa el Modo Endless
   */
  void initializeEndlessMode() {
    // Solo crear un nuevo EndlessManager si no existe (para restart limpio)
    // Si ya existe, mantener el progreso actual
    if (endlessManager == null) {
      endlessManager = new EndlessManager(app);
      println("♾️ Inicializando Modo Endless (nuevo manager)...");
    } else {
      println("🔄 Reanudando Modo Endless (manteniendo progreso)...");
    }
  }
  
  // ===============================================
  // SISTEMA DE PAUSA
  // ===============================================
  
  /**
   * Alterna entre pausa y reanudación
   */
  void togglePause() {
    if (currentState == GameState.PAUSED) {
      resumeGame();
    } else if (canBePaused()) {
      pauseGame();
    }
  }
  
  /**
   * Pausa el juego
   */
  void pauseGame() {
    if (canBePaused()) {
      println("⏸️ Pausando juego desde estado: " + currentState);
      changeState(GameState.PAUSED);
    }
  }
  
  /**
   * Reanuda el juego
   */
  void resumeGame() {
    if (currentState == GameState.PAUSED) {
      println("▶️ Reanudando juego a estado: " + previousState);
      changeState(previousState);
    }
  }
  
  /**
   * Verifica si el estado actual puede ser pausado
   */
  boolean canBePaused() {
    return currentState == GameState.ZEN_MODE || 
           currentState == GameState.WAVES_ACTIVE || 
           currentState == GameState.ENDLESS_ACTIVE;
  }
  
  // ===============================================
  // EVENTOS DE ENTRADA
  // ===============================================
  
  /**
   * Maneja eventos de teclado
   */
  void handleKeyPressed(char key, int keyCode) {
    // Teclas universales
    if (key == ' ' || key == 'p' || key == 'P' || keyCode == 19) { // 19 = PAUSE key
      togglePause();
      return;
    }
    
    if (keyCode == 27) { // ESC
      handleEscapeKey();
      return;
    }
    
    // Teclas específicas por estado
    switch(currentState) {
      case MAIN_MENU:
        if (mainMenu != null) mainMenu.handleKey(key, keyCode);
        break;
        
      case PAUSED:
        if (pauseScreen != null) pauseScreen.handleKey(key, keyCode);
        break;
        
      case ZEN_MODE:
        // Modo Zen maneja sus propias teclas a través de pondManager
        break;
        
      case UPGRADE_SCREEN:
        if (upgradeScreen != null) upgradeScreen.handleKey(key, keyCode);
        break;
        
      case GAME_OVER:
        if (gameOverScreen != null) gameOverScreen.handleKey(key, keyCode);
        break;
        
      case VICTORY:
        if (victoryScreen != null) victoryScreen.handleKey(key, keyCode);
        break;
    }
  }
  
  /**
   * Maneja la tecla ESC
   */
  void handleEscapeKey() {
    switch(currentState) {
      case ZEN_MODE:
      case WAVES_ACTIVE:
      case ENDLESS_ACTIVE:
        changeState(GameState.MAIN_MENU);
        break;
        
      case PAUSED:
        resumeGame();
        break;
        
      case INSTRUCTIONS:
      case UPGRADE_SCREEN:
      case GAME_OVER:
      case GAME_WON:
      case VICTORY:
        changeState(GameState.MAIN_MENU);
        break;
    }
  }
  
  /**
   * Maneja eventos de mouse
   */
  void handleMousePressed(float mouseX, float mouseY, int mouseButton) {
    switch(currentState) {
      case MAIN_MENU:
        if (mainMenu != null) mainMenu.handleClick(mouseX, mouseY);
        break;
        
      case INSTRUCTIONS:
        if (instructionsScreen != null) instructionsScreen.handleClick(mouseX, mouseY);
        break;
        
      case PAUSED:
        if (pauseScreen != null) pauseScreen.handleClick(mouseX, mouseY);
        break;
        
      case ZEN_MODE:
        if (pondManager != null) pondManager.handleClick(mouseX, mouseY);
        break;
        
      case WAVES_ACTIVE:
        if (wavesManager != null) wavesManager.handleClick(mouseX, mouseY);
        break;
        
      case ENDLESS_ACTIVE:
        if (endlessManager != null) endlessManager.handleClick(mouseX, mouseY);
        break;
        
      case UPGRADE_SCREEN:
        if (upgradeScreen != null) upgradeScreen.handleClick(mouseX, mouseY);
        break;
        
      case GAME_OVER:
        if (gameOverScreen != null) gameOverScreen.handleClick(mouseX, mouseY);
        break;
        
      case VICTORY:
        if (victoryScreen != null) victoryScreen.handleClick(mouseX, mouseY);
        break;
    }
  }
  
  // ===============================================
  // MÉTODOS PÚBLICOS PARA TRANSICIONES
  // ===============================================
  
  /**
   * Inicia el Modo Zen
   */
  void startZenMode() {
    // Resetear el manager para empezar un juego completamente nuevo
    pondManager = null;
    changeState(GameState.ZEN_MODE);
  }
  
  /**
   * Inicia el Modo Waves
   */
  void startWavesMode() {
    // Resetear el manager para empezar un juego completamente nuevo
    wavesManager = null;
    changeState(GameState.WAVES_ACTIVE);
  }
  
  /**
   * Inicia el Modo Endless
   */
  void startEndlessMode() {
    // Resetear el manager para empezar un juego completamente nuevo
    endlessManager = null;
    changeState(GameState.ENDLESS_ACTIVE);
  }
  
  /**
   * Muestra las instrucciones
   */
  void showInstructions() {
    changeState(GameState.INSTRUCTIONS);
  }
  
  /**
   * Vuelve al menú principal
   */
  void returnToMenu() {
    changeState(GameState.MAIN_MENU);
  }
  
  /**
   * Sale de la aplicación
   */
  void quitGame() {
    println("👋 Cerrando Jardín Koi ...");
    app.exit();
  }
  
  // ===============================================
  // GETTERS Y UTILIDADES
  // ===============================================
  
  /**
   * Obtiene el estado actual
   */
  GameState getCurrentState() {
    return currentState;
  }
  
  /**
   * Verifica si hay un juego activo
   */
  boolean isGameActive() {
    return isGameActive;
  }
  
  /**
   * Verifica si el juego está pausado
   */
  boolean isPaused() {
    return currentState == GameState.PAUSED;
  }
  
  /**
   * Obtiene el ScoreManager
   */
  ScoreManager getScoreManager() {
    return scoreManager;
  }
  
  /**
   * Obtiene el ProgressManager
   */
  ProgressManager getProgressManager() {
    return progressManager;
  }
  
  // ===============================================
  // MÉTODOS AUXILIARES PARA GAME OVER Y UPGRADES
  // ===============================================
  
  /**
   * Muestra la pantalla de Game Over
   */
  void showGameOver(String mode, int score, String time, int wave) {
    if (gameOverScreen != null) {
      gameOverScreen.show(mode, score, time, wave);
      changeState(GameState.GAME_OVER);
    }
  }
  
  /**
   * Muestra la pantalla de Upgrade
   */
  void showUpgradeScreen(int completedWave) {
    if (upgradeScreen != null && wavesManager != null) {
      upgradeScreen.show(completedWave, wavesManager.uiManager);
      changeState(GameState.UPGRADE_SCREEN);
    }
  }
  
  /**
   * Muestra la pantalla de Victoria (Wave 5 completada)
   */
  void showVictoryScreen() {
    if (victoryScreen != null) {
      victoryScreen.show();
      changeState(GameState.VICTORY);
    }
  }
  
  /**
   * Formatea el tiempo de supervivencia desde un timestamp
   */
  String getFormattedTime(float startTime) {
    float timeAlive = (millis() - startTime) / 1000.0;
    int minutes = (int)(timeAlive / 60);
    int seconds = (int)(timeAlive % 60);
    return nf(minutes, 2) + ":" + nf(seconds, 2);
  }
  
  /**
   * Formatea el tiempo de supervivencia desde un float
   */
  String getFormattedTimeFloat(float timeInSeconds) {
    int minutes = (int)(timeInSeconds / 60);
    int seconds = (int)(timeInSeconds % 60);
    return nf(minutes, 2) + ":" + nf(seconds, 2);
  }
} 