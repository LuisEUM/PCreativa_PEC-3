# 🎮 Jardín Koi

**Un juego de supervivencia basado en la simulación de estanque de peces koi donde debes proteger y hacer crecer tu colección de koi mientras enfrentas oleadas de depredadores a lo largo de 5 rondas intensas.**

## 🎯 CONCEPTO DEL JUEGO

Jardín Koi es una evolución de la simulación de estanque original que ofrece **tres experiencias de juego distintas**:

### 🌊 **MODO WAVES** (Principal)

Juego de estrategia y supervivencia en tiempo real con 5 rondas programadas. Los jugadores deben gestionar recursos limitados (rocas y comida) para mantener vivos a sus peces koi mientras enfrentan oleadas programadas de depredadores cada vez más peligrosos.

### 🧘 **MODO ZEN** (Relajación)

La simulación original de estanque de peces koi. Experiencia tranquila y contemplativa donde puedes crear koi personalizados, alimentarlos y disfrutar del ecosistema acuático sin presión de tiempo ni enemigos. Perfecto para relajarse y experimentar con el diseño de koi.

### ♾️ **MODO ENDLESS** (Supervivencia infinita)

Modo de supervivencia sin límite de tiempo donde los depredadores aparecen constantemente. La dificultad aumenta cada 30 segundos incrementando la cantidad de enemigos que aparecen simultáneamente. ¿Cuánto tiempo puedes sobrevivir?

### 🏆 OBJETIVOS POR MODO

- **Waves:** Sobrevivir las 5 rondas consecutivas de 2 minutos cada una
- **Zen:** Crear y disfrutar tu colección de koi ideal
- **Endless:** Sobrevivir el mayor tiempo posible y obtener la puntuación más alta

---

## 🕹️ MECÁNICAS PRINCIPALES

### 🐟 **SISTEMA DE ALIMENTACIÓN**

- **Detección automática:** Todos los koi detectan y buscan comida automáticamente
- **Competencia limitada:** Todos los koi pueden competir por cada partícula de comida
- **Crecimiento:** Solo los tres primeros kois en llegar comen y crecen un nivel de tamaño
- **Pérdida de nivel:** Los koi bajan un nivel si no comen por 20 segundos o son mordidos por un enemigo

### ⚔️ **SISTEMA DE COMBATE**

- **Rocas limitadas:** Cantidad máxima de rocas disponibles por ronda
- **Daño por impacto:** Los depredadores reciben daño al ser golpeados por rocas
- **Vidas múltiples:** Depredadores requieren múltiples golpes según su tamaño
- **Targeting inteligente:** Los depredadores persiguen automáticamente al koi más vulnerable

### 📈 **SISTEMA DE CRECIMIENTO KOI**

| Nivel | Tamaño | Velocidad | Resistencia                  |
| ----- | ------ | --------- | ---------------------------- |
| XS    | 10     | 1.4x      | Vulnerable a todos           |
| S     | 15     | 1.2x      | Vulnerable a todos           |
| M     | 20     | 1.0x      | Resistente a Bagres pequeños |
| L     | 28     | 0.8x      | Resistente a Bagres y Carpas |
| XL    | 35     | 0.6x      | Solo vulnerable a Tiburones  |

### ⏰ **SISTEMA DE RECURSOS**

- **Regeneración temporal:** Rocas y comida se regeneran cada 5 segundos
- **Gestión estratégica:** El jugador debe decidir cuándo y cómo usar cada recurso
- **Mejoras entre rondas:** Elegir entre +10 rocas máximas, +10 comidas máximas O +5 koi refuerzo

---

## 🌊 ESTRUCTURA DE RONDAS

### 🥇 **RONDA 1: "Primeros Depredadores"**

- **Duración:** 2 minutos
- **Koi inicial:** 8 koi pequeños (S y M)
- **Recursos iniciales:** 5 rocas máx, 8 comidas máx
- **Oleadas de enemigos:**
  - 0:30 → 1 Bagre pequeño (2 vidas)
  - 1:00 → 1 Bagre pequeño
  - 1:30 → 2 Bagres pequeños
- **Puntos base:** 100 pts por koi superviviente

### 🥈 **RONDA 2: "Amenaza Creciente"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 2 koi nuevos (M)
- **Oleadas de enemigos:**
  - 0:20 → 1 Bagre pequeño
  - 0:50 → 1 Carpa mediana (3 vidas)
  - 1:20 → 1 Bagre + 1 Carpa
  - 1:50 → 2 Carpas medianas
- **Puntos base:** 150 pts por koi superviviente

### 🥉 **RONDA 3: "Depredadores Grandes"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 1 koi grande (L)
- **Oleadas de enemigos:**
  - 0:15 → 1 Carpa mediana
  - 0:45 → 1 Lucio grande (4 vidas)
  - 1:05 → 2 Carpas + 1 Bagre
  - 1:35 → 1 Lucio + 1 Carpa
- **Puntos base:** 200 pts por koi superviviente

### 🏆 **RONDA 4: "Invasión Masiva"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 1 koi XL
- **Oleadas de enemigos:**
  - 0:10 → 2 Bagres
  - 0:30 → 1 Lucio grande
  - 0:50 → 3 Carpas medianas
  - 1:10 → 2 Lucios grandes
  - 1:40 → 1 Tiburón gigante (5 vidas)
- **Puntos base:** 300 pts por koi superviviente

### 👑 **RONDA 5: "Supervivencia Final"**

- **Duración:** 2 minutos
- **Koi:** Solo supervivientes
- **Oleadas de enemigos:**
  - Cada 20 segundos → Wave aleatoria de 2-4 depredadores
  - 1:30 → **JEFE:** Tiburón Rey (8 vidas, tamaño gigante)
- **Puntos base:** 500 pts por koi superviviente

---

## ♾️ MODO ENDLESS

### 🕰️ **MECÁNICAS DE SUPERVIVENCIA INFINITA**

- **Sin límite de tiempo:** El juego continúa hasta que todos los koi mueran
- **Spawning constante:** Los depredadores aparecen continuamente
- **Escalada de dificultad:** Cada 30 segundos aumenta la dificultad
- **Recursos:** Mismas mecánicas que Modo Waves (regeneración cada 5s)
- **Sin mejoras:** No hay pausas ni upgrades entre oleadas

### 📈 **ESCALADA DE DIFICULTAD (Cada 30 segundos)**

| Tiempo    | Depredadores Simultáneos | Tipos de Enemigos          |
| --------- | ------------------------ | -------------------------- |
| 0:00-0:30 | 1                        | Solo Bagres pequeños       |
| 0:30-1:00 | 2                        | Bagres pequeños            |
| 1:00-1:30 | 2-3                      | Bagres + Carpas            |
| 1:30-2:00 | 3-4                      | Bagres + Carpas            |
| 2:00-2:30 | 4-5                      | Bagres + Carpas + Lucios   |
| 2:30-3:00 | 5-6                      | Todos los tipos            |
| 3:00+     | 6-8                      | Todos + Tiburones gigantes |

### 🏆 **PUNTUACIÓN ENDLESS**

- **Supervivencia por segundo:** +1 punto por segundo
- **Depredadores eliminados:** +50 puntos por depredador
- **Koi que crecieron:** +25 puntos por crecimiento
- **Multiplicador temporal:** x1.1 cada 30 segundos (máximo x5.0) - Afecta TODOS los puntos
- **Bonus de hitos:** +1000 pts por cada minuto sobrevivido

### 🎁 **POWER-UPS ESPECIALES (Solo Modo Endless)**

Los power-ups caen del cielo aleatoriamente cada 45-90 segundos:

| Power-up            | Efecto                                   | Duración    | Color             |
| ------------------- | ---------------------------------------- | ----------- | ----------------- |
| 🟡 Comida Dorada    | Hace crecer 2 niveles al koi que la come | Instantáneo | Dorado brillante  |
| 🔵 Escudo Temporal  | Todos los koi son inmunes a depredadores | 10 segundos | Azul brillante    |
| 🟣 Multiplicador x2 | Duplica TODOS los puntos ganados         | 15 segundos | Púrpura brillante |

**Mecánicas de Power-ups:**

- **Duración en pantalla:** 5 segundos antes de desaparecer
- **Alerta visual:** Titila/parpadea los últimos 3 segundos
- **Competencia:** Solo 1 koi puede tomar cada power-up
- **Spawn:** Posición aleatoria en el estanque

### 📊 **ESTADÍSTICAS EN TIEMPO REAL (Modo Endless)**

Mostradas en la esquina inferior izquierda:

- **Tiempo transcurrido:** MM:SS
- **Depredadores eliminados:** Contador total
- **Koi perdidos:** Contador de bajas
- **Power-ups obtenidos:** Contador por tipo
- **Multiplicador actual:** x1.0 - x5.0
- **Próxima escalada:** Countdown para siguiente aumento de dificultad

### 📊 **MECÁNICAS DE PAUSA**

#### **🌊 MODO WAVES:**

- **Preservación completa:** Timer de ronda, oleadas programadas, recursos se congelan
- **Power-ups:** No aplica (solo en Endless)
- **Depredadores:** Se congelan en su posición y estado actual
- **Koi:** Mantienen posición, dirección y estado de hambre
- **Puntuación:** Se pausa el cálculo de bonus de tiempo

#### **♾️ MODO ENDLESS:**

- **Preservación completa:** Timer de supervivencia, escalada de dificultad se congela
- **Power-ups activos:** Los timers de efectos se pausan (escudo, multiplicador)
- **Power-ups en pantalla:** Los que están cayendo se congelan en el aire
- **Depredadores:** Se congelan completamente
- **Estadísticas:** Todos los contadores se pausan

#### **🧘 MODO ZEN:**

- **Simulación opcional:** La pausa congela el movimiento pero no es crítica
- **Ciclo día/noche:** Se pausa en el momento actual
- **Pétalos y efectos:** Se congelan en su estado actual
- **Funcionalidad reducida:** Menos crítico que en modos de acción

---

## 🧘 MODO ZEN

### 🌸 **EXPERIENCIA RELAJANTE**

- **Sin depredadores:** Ecosistema pacífico sin amenazas
- **Creación libre:** Sistema completo de personalización de koi
- **Sin límites:** Crea tantos koi como quieras (hasta 100)
- **Ciclos naturales:** Día/noche, pétalos flotantes, ondas naturales
- **Sin puntuación:** Enfoque en la contemplación y creatividad

### 🎨 **CARACTERÍSTICAS EXCLUSIVAS DEL MODO ZEN**

- **Personalización avanzada:** Todos los colores, patrones y tamaños disponibles
- **Plantas decorativas:** Flores de loto y hojas flotantes
- **Efectos ambientales:** Pétalos que caen, ondulaciones naturales
- **Sin presión de tiempo:** Disfruta a tu propio ritmo
- **Guardado de diseños:** Guarda tus koi favoritos para futuros usos

---

## 🦈 TIPOS DE DEPREDADORES

| Tipo               | Tamaño | Vidas | Velocidad | Puede Comer |
| ------------------ | ------ | ----- | --------- | ----------- |
| Bagre Pequeño      | 25     | 2     | 0.5x      | XS, S       |
| Carpa Mediana      | 35     | 3     | 0.6x      | XS, S, M    |
| Lucio Grande       | 45     | 4     | 0.7x      | XS, S, M, L |
| Tiburón Gigante    | 55     | 5     | 0.8x      | Todos       |
| Tiburón Rey (Jefe) | 70     | 8     | 0.9x      | Todos       |

---

## 🎮 CONTROLES

### 🌊 **MODO WAVES & ENDLESS**

- **Clic Izquierdo:** Lanzar comida (limitada, regenera cada 5s)
- **Clic Derecho:** Lanzar roca para atacar depredadores (limitada, regenera cada 5s)
- **Espacio:** Pausa/Reanudar juego
- **Pause/P:** Pausa/Reanudar juego (alternativa)
- **ESC:** Volver al menú principal

### 🧘 **MODO ZEN**

- **Clic Izquierdo:** Alimentar a los peces (los atrae)
- **Clic Derecho:** Tirar rocas (los repele/elimina con golpe directo)
- **Botón "+":** Crear nuevos koi personalizados
- **Botón Sol/Luna:** Cambiar ciclo día/noche
- **Botón Papelera:** Eliminar todos los peces
- **Pause/P:** Pausa/Reanudar simulación (opcional)
- **ESC:** Volver al menú principal

---

## 🖥️ PANTALLAS DEL JUEGO

### 📱 **PANTALLA DE INICIO**

- **Waves Mode:** Comenzar modo de 5 rondas programadas
- **Endless Mode:** Comenzar modo de supervivencia infinita
- **Zen Mode:** Comenzar modo de simulación relajante
- **Instructions:** Ver controles e información del juego
- **Quit:** Cerrar aplicación

### 📋 **PANTALLA DE INSTRUCCIONES**

- Explicación completa de mecánicas
- Tabla de koi y depredadores
- Controles y objetivos
- Botón "Back" para volver al menú

### ⚰️ **PANTALLA DE GAME OVER**

- Estadísticas finales (ronda alcanzada, koi salvados, tiempo total)
- **Restart:** Comenzar nueva partida
- **Main Menu:** Volver al menú principal
- **Quit:** Cerrar aplicación

### 🎉 **PANTALLA DE VICTORIA** (Al completar las 5 rondas)

- Felicitaciones y estadísticas completas
- Puntuación final
- **Play Again:** Nueva partida
- **Main Menu:** Volver al menú principal

### ⏸️ **PANTALLA DE MEJORAS** (Entre rondas - Solo Modo Waves)

- Estadísticas de la ronda completada
- Tres opciones de mejora (elegir solo una):
  - "+10 Rocas Máximas"
  - "+10 Comidas Máximas"
  - "+5 Koi Refuerzo" (agrega 5 koi XS nuevos al estanque)
- Cuenta regresiva de 30 segundos para decidir

### ⏸️ **PANTALLA DE PAUSA** (Waves, Endless & Zen)

- **Fondo semi-transparente:** Oscurece el juego pero mantiene visibilidad
- **Menú central con opciones:**
  - "Reanudar" - Continuar el juego
  - "Reiniciar" - Comenzar la ronda/partida desde el inicio
  - "Menú Principal" - Volver al menú de selección de modo
  - "Salir" - Cerrar aplicación
- **Preservación del estado:** El juego se congela completamente durante la pausa
- **Estadísticas actuales:** Muestra tiempo transcurrido, puntos, koi vivos
- **Teclas:** Espacio, P, o Pause para reanudar

---

## 💯 SISTEMA DE PUNTUACIÓN

### 🏆 **PUNTUACIÓN POR SUPERVIVENCIA**

- **Ronda 1:** 100 puntos por cada koi superviviente
- **Ronda 2:** 150 puntos por cada koi superviviente
- **Ronda 3:** 200 puntos por cada koi superviviente
- **Ronda 4:** 300 puntos por cada koi superviviente
- **Ronda 5:** 500 puntos por cada koi superviviente

### ⭐ **PUNTUACIÓN BONUS**

- **Depredadores eliminados:** +50 puntos por depredador
- **Koi que crecieron de nivel:** +25 puntos por crecimiento
- **Bonus de tiempo:** +10 puntos por segundo restante en la ronda
- **Bonus de ronda completa:** +500 puntos por completar ronda
- **Bonus de victoria total:** +5000 puntos por completar las 5 rondas

### 📊 **BILLBOARD/MARCADOR**

El billboard se muestra permanentemente en la esquina superior derecha y contiene:

- **Puntuación actual:** Actualizada en tiempo real
- **Puntuación de la ronda:** Se resetea al inicio de cada ronda (solo Waves)
- **Puntuación total acumulada:** Suma de todas las rondas
- **Record personal por modo:** Máxima puntuación alcanzada en cada modo (guardada localmente)
- **Multiplicador activo:** x1, x1.5, x2, x3, x5 (Waves) o x1.0-x5.0 (Endless)

---

## 🎨 ELEMENTOS VISUALES

### 🌊 **INTERFAZ DE JUEGO**

- **Timer de ronda:** Countdown prominente en la parte superior central (Waves)
- **Timer de supervivencia:** Contador ascendente MM:SS en parte superior central (Endless)
- **Billboard de puntuación:** Esquina superior derecha con puntos y multiplicadores
- **Contador de koi:** Número de koi vivos (esquina superior izquierda)
- **Recursos disponibles:** Barras de rocas y comida restantes (parte inferior) - Solo Waves/Endless
- **Estadísticas Endless:** Esquina inferior izquierda con stats en tiempo real - Solo Endless
- **Alerta de oleadas:** Warning 5 segundos antes de spawn de enemigos (Waves)
- **Alerta de escalada:** Countdown para próxima escalada de dificultad (Endless)
- **Indicadores de nivel:** Tamaño visual de cada koi con colores por nivel
- **Power-ups activos:** Iconos y timers de efectos temporales (Endless)

### ✨ **EFECTOS ESPECIALES**

- **Crecimiento de koi:** Animación de expansión con partículas
- **Impactos de rocas:** Splash y ondas en el agua
- **Muerte de depredadores:** Partículas rojas y hundimiento
- **Alimentación exitosa:** Brillo dorado alrededor del koi
- **Pérdida de nivel:** Efecto de contracción con partículas grises

---

## 🔧 ARQUITECTURA TÉCNICA

### 📁 **ESTRUCTURA DE ARCHIVOS**

```
lurdaneta_PR.pde          // Archivo principal y control de estados
ScreenManager.pde         // Gestión de pantallas y modos de juego
GameManager.pde           // Gestión de rondas para Modo Waves
EndlessManager.pde        // Gestión de supervivencia infinita para Modo Endless
KoiSurvival.pde          // Expansión de Koi con mecánicas de supervivencia
PredatorManager.pde       // Gestión de depredadores y oleadas
PowerUpManager.pde        // Gestión de power-ups especiales (Solo Endless)
ResourceManager.pde       // Gestión de rocas y comida limitadas
ScoreManager.pde          // Sistema de puntuación y records separados por modo
Billboard.pde             // Interfaz del marcador de puntos
SurvivalUI.pde           // Interfaz específica para Waves/Endless
// ... archivos existentes del proyecto original (para Modo Zen)
```

### 🎯 **ESTADOS DEL JUEGO**

1. **MAIN_MENU:** Pantalla de inicio con selección de modo
2. **INSTRUCTIONS:** Pantalla de instrucciones
3. **ZEN_MODE:** Modo de simulación relajante (código original)
4. **WAVES_PREP:** Preparación de ronda (solo Modo Waves)
5. **WAVES_ACTIVE:** Gameplay activo Modo Waves
6. **ENDLESS_ACTIVE:** Gameplay activo Modo Endless
7. **PAUSED:** Pantalla de pausa (disponible desde cualquier modo activo)
8. **ROUND_COMPLETE:** Evaluación y mejoras (solo Modo Waves)
9. **GAME_OVER:** Pantalla de derrota (Waves & Endless)
10. **GAME_WON:** Pantalla de victoria (solo Modo Waves)

---

## ❓ PREGUNTAS PENDIENTES PARA REFINAMIENTO

1. **¿El Modo Zen debería tener algún tipo de logros o colección?**

   - Galería de koi únicos creados
   - Logros por crear ciertos patrones/colores

2. **¿Deberíamos implementar un sistema de guardado para continuar partidas?**

   - Solo para Endless (partidas muy largas)
   - Para los tres modos

3. **¿Habrá música y efectos de sonido?**

   - Música diferente para cada modo (intensa para Waves/Endless, relajante para Zen)
   - Efectos de acción y ambiente

4. **¿El billboard debería mostrar animaciones cuando se ganan puntos?**
   - Efectos de "+100 pts" flotantes
   - Cambio de color en multiplicadores

---

## ✅ TODO LIST - DESARROLLO

### 🎮 **FASE 1: ESTADOS Y PANTALLAS (Semana 1)**

- [ ] Crear ScreenManager.pde para gestión de estados de los 3 modos
- [ ] Implementar pantalla de inicio con selección de modo (MAIN_MENU)
- [ ] Implementar pantalla de instrucciones (INSTRUCTIONS)
- [ ] Configurar Modo Zen usando código existente (ZEN_MODE)
- [ ] Implementar pantalla de pausa universal (PAUSED) para todos los modos
- [ ] Crear sistema de preservación de estado durante pausa
- [ ] Implementar pantalla de game over para Waves/Endless (GAME_OVER)
- [ ] Implementar pantalla de victoria para Waves (GAME_WON)
- [ ] Crear transiciones entre pantallas y modos
- [ ] Testear navegación completa entre los 3 modos y pausa

### ⚔️ **FASE 2: MECÁNICAS BÁSICAS DE SUPERVIVENCIA (Semana 2)**

- [ ] Expandir clase Koi con sistema de niveles
- [ ] Implementar pérdida de nivel (20s sin comer + mordeduras)
- [ ] Crear sistema de competencia por comida (máximo 3 koi)
- [ ] Implementar ResourceManager para rocas y comida limitadas
- [ ] Crear regeneración de recursos cada 5 segundos
- [ ] Testear mecánicas básicas de alimentación y crecimiento

### 🦈 **FASE 3: SISTEMA DE DEPREDADORES (Semana 3)**

- [ ] Crear clase Predator con diferentes tipos
- [ ] Implementar sistema de vidas múltiples
- [ ] Crear PredatorManager para spawning desde fuera del mapa
- [ ] Implementar targeting inteligente (koi más vulnerable)
- [ ] Crear sistema de daño por rocas
- [ ] Testear combate y eliminación de depredadores

### 🌊 **FASE 4: SISTEMA DE RONDAS Y ENDLESS (Semana 4)**

- [ ] Crear GameManager para control de Modo Waves
- [ ] Implementar timer de 2 minutos por ronda (Waves)
- [ ] Programar oleadas específicas por ronda (1-5) (Waves)
- [ ] Crear pantalla de mejoras entre rondas (Waves)
- [ ] Implementar sistema de mejoras (+10 rocas/comida/+5 koi XS) (Waves)
- [ ] Crear EndlessManager para Modo Endless
- [ ] Implementar escalada de dificultad cada 30s (Endless)
- [ ] Programar spawning constante de depredadores (Endless)
- [ ] Crear PowerUpManager para power-ups especiales (Endless)
- [ ] Implementar power-ups: Comida Dorada, Escudo, Multiplicador x2 (Endless)
- [ ] Crear condiciones de victoria/derrota para ambos modos
- [ ] Testear ambos sistemas de juego independientemente

### 🎨 **FASE 5: INTERFAZ Y FEEDBACK VISUAL (Semana 5)**

- [ ] Crear SurvivalUI.pde para interfaz de Waves/Endless
- [ ] Implementar contador de tiempo para Waves (centro superior)
- [ ] Implementar contador de supervivencia para Endless (centro superior)
- [ ] Crear billboard de puntuación para Waves/Endless (esquina superior derecha)
- [ ] Implementar sistema de puntos en tiempo real
- [ ] Crear panel de estadísticas en tiempo real para Endless (esquina inferior izquierda)
- [ ] Mantener UI original del Modo Zen (botones creación, día/noche, etc.)
- [ ] Crear indicadores de recursos para Waves/Endless (barras rocas/comida)
- [ ] Implementar alertas de oleadas (5s antes) para Waves
- [ ] Implementar alerta de escalada de dificultad para Endless
- [ ] Crear efectos visuales de power-ups (spawn, titilado, colecta)
- [ ] Implementar indicadores de power-ups activos con timers
- [ ] Crear efectos visuales de crecimiento/pérdida de nivel
- [ ] Implementar efectos de impacto y muerte
- [ ] Agregar multiplicadores visuales por ronda/tiempo

### 🏆 **FASE 6: PUNTUACIÓN Y BALANCING (Semana 6)**

- [ ] Implementar sistema de puntuación completo para Waves con multiplicadores
- [ ] Implementar sistema de puntuación para Endless con escalada temporal
- [ ] Crear billboard interactivo con animaciones de puntos
- [ ] Implementar guardado de records separados para cada modo (Waves/Endless/Zen)
- [ ] Crear estadísticas detalladas por ronda (Waves) y tiempo (Endless)
- [ ] Implementar pantalla de mejoras con opción de +5 koi XS (Waves)
- [ ] Balancear puntuación base por ronda Waves (100, 150, 200, 300, 500)
- [ ] Balancear escalada de dificultad Endless (30s intervals)
- [ ] Balancear frecuencia y efectos de power-ups (Endless)
- [ ] Calibrar multiplicadores: Waves (por ronda) vs Endless (temporal, afecta todos los puntos)
- [ ] Ajustar velocidades de koi y depredadores para ambos modos
- [ ] Calibrar tiempos de regeneración de recursos
- [ ] Testear experiencia completa de los 3 modos

### 🎵 **FASE 7: AUDIO Y PULIDO (Semana 7)**

- [ ] Agregar efectos de sonido básicos
- [ ] Implementar música de fondo (opcional)
- [ ] Crear feedback auditivo para acciones importantes
- [ ] Pulir transiciones y animaciones
- [ ] Optimizar rendimiento
- [ ] Testing final y corrección de bugs

### 📚 **FASE 8: DOCUMENTACIÓN Y ENTREGA (Semana 8)**

- [ ] Actualizar README con instrucciones finales
- [ ] Crear manual de usuario
- [ ] Documentar código con comentarios completos
- [ ] Crear video demo del juego
- [ ] Preparar presentación final
- [ ] Entrega y presentación

---

## 🎯 CRITERIOS DE ÉXITO

- [ ] **Jugabilidad completa:** Los 3 modos de juego funcionan correctamente
- [ ] **Modo Waves:** Las 5 rondas son completables y balanceadas
- [ ] **Modo Endless:** Escalada de dificultad fluida y supervivencia desafiante
- [ ] **Modo Zen:** Experiencia relajante con todas las funciones originales
- [ ] **Mecánicas funcionantes:** Sistemas de alimentación, combate y recursos trabajan en todos los modos
- [ ] **Navegación fluida:** Transiciones suaves entre pantallas, modos y estados
- [ ] **Feedback claro:** El jugador siempre sabe qué está pasando y qué debe hacer
- [ ] **Rejugabilidad:** Los tres modos son divertidos de jugar múltiples veces
- [ ] **Sistemas independientes:** Cada modo ofrece una experiencia única y diferenciada
- [ ] **Código limpio:** Arquitectura clara y comentarios comprehensivos (60%+ código original)

---

## 📄 LICENCIA

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo LICENSE para más detalles.

---

**¡Que comience la supervivencia! 🐟⚔️🦈**
