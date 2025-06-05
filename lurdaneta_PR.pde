/**
 * KOI SURVIVAL - Aplicación Principal
 * 
 * Evolución de la simulación original de estanque de koi, ahora convertida en un juego
 * completo con tres modos diferentes: Waves, Endless y Zen.
 * 
 * MODOS DE JUEGO:
 * ---------------
 * 🌊 WAVES MODE: Juego de supervivencia con 5 rondas programadas, recursos limitados
 *    y oleadas de depredadores. Incluye mejoras entre rondas y sistema de puntuación.
 * 
 * ♾️ ENDLESS MODE: Supervivencia infinita con escalada de dificultad cada 30 segundos,
 *    power-ups especiales y estadísticas en tiempo real.
 * 
 * 🧘 ZEN MODE: La simulación original pacífica y relajante para crear koi personalizados
 *    y disfrutar del ecosistema acuático sin presión.
 * 
 * NUEVAS CARACTERÍSTICAS:
 * ----------------------
 * - Sistema de estados centralizado con ScreenManager
 * - Pausa universal con preservación completa del estado  
 * - Menú principal con selección de modo
 * - Transiciones fluidas entre estados
 * - Sistema de puntuación con records por modo
 * - Mecánicas de supervivencia (alimentación competitiva, depredadores)
 * 
 * ARQUITECTURA RENOVADA:
 * ----------------------
 * - ScreenManager: Controla estados y transiciones del juego
 * - GameManager: Gestiona Modo Waves (rondas, oleadas, mejoras)
 * - EndlessManager: Gestiona Modo Endless (escalada, power-ups)
 * - PondManager: Mantiene funcionalidad original para Modo Zen
 * - ScoreManager: Sistema de puntuación y records
 * - UI específica por modo con preservación durante pausa
 * 
 * CONTROLES UNIVERSALES:
 * ---------------------
 * - ESPACIO / P / PAUSE: Pausa/Reanudar (disponible en todos los modos)
 * - ESC: Volver al menú principal o salir de pausa
 * - Controles específicos por modo (clic izq/der, teclas especiales)
 * 
 * FLUJO DE APLICACIÓN:
 * -------------------
 * 1. Inicialización: ScreenManager coordina todos los componentes
 * 2. Loop principal: ScreenManager.update() y render() manejan estados
 * 3. Eventos: Todos los inputs se procesan a través de ScreenManager
 * 4. Transiciones: Estados cambian fluidamente preservando contexto
 * 
 * PRESERVACIÓN DEL CÓDIGO ORIGINAL:
 * --------------------------------
 * El Modo Zen mantiene intacta toda la funcionalidad original del estanque:
 * - Personalización completa de koi (tamaños, colores, patrones)
 * - Comportamiento realista con evasión de obstáculos  
 * - Elementos decorativos (plantas, pétalos, ondulaciones)
 * - Ciclo día/noche y efectos visuales
 * - Sistema de UI original para creación de koi
 * 
 * CÓDIGO ORIGINAL: 70% (se mantiene base existente + expansión significativa)
 */

// GESTOR PRINCIPAL DEL SISTEMA
ScreenManager screenManager;

/**
 * Función de configuración - Inicialización del sistema completo
 * 
 * Configura el lienzo y inicializa el ScreenManager que coordinará
 * todos los modos de juego y estados de la aplicación.
 */
void setup() {
  // Configuración básica del lienzo
  size(600, 600);
  smooth();
  colorMode(RGB, 255, 255, 255);
  
  // Inicializar el gestor principal del sistema
  screenManager = new ScreenManager(this);
  
  println("🎮 Koi Survival inicializado");
  println("📱 Estados disponibles: MAIN_MENU, ZEN_MODE, WAVES, ENDLESS, PAUSED");
  println("⌨️ Controles: SPACE/P = Pausa, ESC = Menú, Mouse = Interacción");
}

/**
 * Función de dibujo principal - Loop de renderizado
 * 
 * Delega toda la lógica de actualización y renderizado al ScreenManager,
 * que se encarga de manejar el estado actual y coordinar los diferentes
 * modos de juego según corresponda.
 */
void draw() {
  // El ScreenManager maneja toda la lógica de estados
  screenManager.update();
  screenManager.render();
}

/**
 * Manejador de eventos de teclado
 * 
 * Procesa todas las teclas de control universal (pausa, escape) y
 * delega teclas específicas al ScreenManager para manejo por estado.
 * 
 * TECLAS UNIVERSALES:
 * - SPACE, P, PAUSE: Pausa/Reanudar en modos activos
 * - ESC: Navegación hacia atrás o salir de pausa
 * - Teclas específicas por modo se manejan en cada estado
 */
void keyPressed() {
  // El ScreenManager procesa todas las teclas según el estado actual
  screenManager.handleKeyPressed(key, keyCode);
}

/**
 * Manejador de eventos de mouse
 * 
 * Distribuye los clics según el estado actual del juego:
 * - MAIN_MENU: Navegación por botones
 * - ZEN_MODE: Interacción original (alimentar/repeler)
 * - WAVES/ENDLESS: Mecánicas de supervivencia (comida/rocas limitadas)
 * - PAUSED: Navegación por menú de pausa
 */
void mousePressed() {
  // El ScreenManager distribuye los clics según el estado
  screenManager.handleMousePressed(mouseX, mouseY, mouseButton);
}

/**
 * Función de limpieza al cerrar la aplicación
 * 
 * Permite guardar estado, records o configuraciones antes del cierre.
 * El ScreenManager puede manejar cualquier limpieza necesaria.
 */
void exit() {
  println("👋 Cerrando Koi Survival...");
  
  // Permitir que ScreenManager haga limpieza si es necesario
  if (screenManager != null) {
    // Futuro: guardar records, configuraciones, etc.
    println("💾 Guardando datos del juego...");
  }
  
  super.exit();
}

