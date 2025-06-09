/**
 * Jardín Koi - Videojuego de Supervivencia y Simulación
 *
 * Jardín Koi es un videojuego que fusiona la simulación relajante de un estanque de peces koi con mecánicas de supervivencia y gestión de recursos. El jugador debe proteger y alimentar a sus peces koi mientras enfrenta oleadas de depredadores y administra recursos limitados. El juego ofrece tres modos principales:
 *
 * MODOS DE JUEGO:
 * - Modo Waves: Supervivencia por rondas con dificultad progresiva, recursos limitados y mejoras entre oleadas.
 * - Modo Endless: Supervivencia infinita con escalada de dificultad, aparición continua de enemigos y power-ups periódicos.
 * - Modo Zen: Simulación libre y pacífica, centrada en la personalización y observación de los koi sin amenazas.
 *
 * MECÁNICAS PRINCIPALES:
 * - Crecimiento y personalización de peces koi.
 * - Sistema de enemigos con diferentes comportamientos (patrullaje, persecución y ataque).
 * - Gestión de recursos: comida y rocas, obtenidos y consumidos estratégicamente.
 * - Power-ups que otorgan ventajas temporales o recursos adicionales.
 * - Sistema de puntuación y estadísticas persistentes.
 *
 * ARQUITECTURA DEL SISTEMA:
 * - ScreenManager: Orquestador central que gestiona los estados del juego (menú, juego, pausa, etc.) y las transiciones entre pantallas. Actúa como el controlador principal de la aplicación.
 * - WavesManager / EndlessManager: Contienen la lógica específica para los modos de juego de supervivencia. Gestionan las oleadas, la dificultad, la aparición de enemigos, las condiciones de victoria/derrota y los recursos del jugador.
 * - PondManager: Motor de simulación base para el Modo Zen, que gestiona el comportamiento de los koi, las plantas y el entorno del estanque de forma no combativa. Es la base sobre la que operan los otros modos de juego.
 * - KoiManager / EnemyManager: Gestionan el ciclo de vida, comportamiento (IA) e interacciones de las entidades amigables (koi) y hostiles (enemigos).
 * - DataManager / ScoreManager / ProgressManager: Trío de gestores para la persistencia de datos. DataManager guarda y carga el perfil y progreso. ScoreManager rastrea la puntuación en tiempo real. ProgressManager maneja los desbloqueos (como el Modo Endless).
 * - UIManagers (UIManager, WavesUIManager, EndlessUIManager): Responsables de la interfaz de usuario específica de cada modo, incluyendo HUDs, contadores y alertas visuales.
 * - Gestores de Recursos (FoodManager, RockManager, PowerUpManager): Administran la creación, uso y comportamiento de los consumibles y power-ups.
 * - Gestores de Entorno (PlantManager, RippleManager, PetalManager): Se encargan de los elementos visuales y ambientales que dan vida al estanque, como plantas, ondulaciones en el agua y pétalos.
 * - MusicManager: Controla la banda sonora del juego, gestionando las transiciones de música entre el menú, los diferentes modos de juego y los estados de pausa.
 *
 * CONTROLES UNIVERSALES:
 * - Espacio/P: Pausar o reanudar la partida.
 * - ESC: Volver al menú principal o salir de pausa.
 * - M: Silenciar o activar la música.
 * - Clic izquierdo: Alimentar koi (consume comida).
 * - Clic derecho: Lanzar rocas (consume rocas, repele o elimina enemigos).
 *
 * CRÉDITOS:
 * - Programación y arte: Luis EUM y colaboradores.
 * - Música: Assets de música generados por Suno (https://suno.com), utilizados bajo licencia correspondiente.
 *
 * Para más detalles, consultar el README incluido en el repositorio.
 */

// GESTORES PRINCIPALES DEL SISTEMA
ScreenManager screenManager;
MusicManager musicManager;

/**
 * Función de configuración - Inicialización del sistema completo
 * 
 * Configuro el lienzo e inicializo el ScreenManager que coordinará
 * todos los modos de juego y estados de la aplicación.
 */
void setup() {
  // Configuración básica del lienzo
  size(600, 600);
  smooth();
  colorMode(RGB, 255, 255, 255);
  
  // Inicializar gestor de música
  musicManager = new MusicManager(this);
  
  // Inicializar el gestor principal del sistema
  screenManager = new ScreenManager(this);
  
  // Conectar MusicManager con ScreenManager
  screenManager.setMusicManager(musicManager);
  
  // Comenzar con música de menú
  musicManager.setGameMode("menu");
  
  println("🎮 Jardín Koi  inicializado");
  println("🎵 Sistema de música activado con archivos de assets/");
  println("📱 Estados disponibles: MAIN_MENU, ZEN_MODE, WAVES, ENDLESS, PAUSED");
  println("⌨️ Controles: SPACE/P = Pausa, ESC = Menú, Mouse = Interacción, M = Mute");
}

/**
 * Función de dibujo principal - Loop de renderizado
 * 
 * Delego toda la lógica de actualización y renderizado al ScreenManager,
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
  println("👋 Cerrando Jardín Koi ...");
  
  // Permitir que ScreenManager haga limpieza si es necesario
  if (screenManager != null) {
    // Futuro: guardar records, configuraciones, etc.
    println("💾 Guardando datos del juego...");
  }
  
  // Limpiar recursos de música
  if (musicManager != null) {
    musicManager.dispose();
  }
  
  super.exit();
}
