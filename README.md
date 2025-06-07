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

### 🐟 **SISTEMA DE CRECIMIENTO KOI**

| Nivel | Tamaño | Velocidad | Puntos de Vida |
| ----- | ------ | --------- | -------------- |
| XS    | 10     | 1.4x      | 1              |
| S     | 15     | 1.2x      | 2              |
| M     | 20     | 1.0x      | 3              |
| L     | 28     | 0.8x      | 4              |
| XL    | 35     | 0.6x      | 5              |

### 🍜 **SISTEMA DE ALIMENTACIÓN**

- **Partículas flotantes:** La comida flota en el agua por 3 segundos
- **Competencia:** Solo los peces que llegan a la comida antes de que desaparezca obtienen el buff
- **Crecimiento:** Cada 10 comidas consumidas el pez crece un nivel
- **Pérdida de nivel:** Los koi bajan un nivel al ser mordidos por enemigos
- **Muerte:** Los koi mueren si son atacados siendo nivel XS

### 🐟 **SISTEMA DE DAÑO Y RECUPERACIÓN**

| Nivel Actual | Daño Recibido | Nuevo Nivel | Puntos de Vida |
| ------------ | ------------- | ----------- | -------------- |
| XL (35px)    | 1-3           | L           | 5              |
| L (28px)     | 1-2           | M           | 4              |
| M (20px)     | 1             | S           | 3              |
| S (15px)     | 1             | XS          | 2              |
| XS (10px)    | 1             | Muerte      | 1              |

**Mecánicas de Daño:**

- Al recibir daño menor a puntos de vida, el koi baja un nivel
- Período de invulnerabilidad de 3 segundos tras recibir daño
- Efecto visual de parpadeo durante invulnerabilidad
- Si el daño iguala o supera los puntos de vida, el koi muere
- La invulnerabilidad previene daño múltiple del mismo enemigo

**Recuperación:**

- Crecimiento al comer 10 partículas de comida
- Power-ups de comida aceleran la recuperación
- El crecimiento restaura todos los puntos de vida
- No hay recuperación automática de nivel

### ⚔️ **SISTEMA DE COMBATE**

- **Puntos de daño:** Cada enemigo tiene puntos de daño específicos
- **Colisiones:** Si el daño del enemigo iguala o supera los puntos de vida del koi, este muere
- **Decrecimiento:** Los koi pierden un nivel al ser mordidos y sobrevivir

### 🎁 **SISTEMA DE POWER-UPS**

Los power-ups aparecen en burbujas cada 20 segundos:

| Power-up  | Contenido         | Cantidad                 |
| --------- | ----------------- | ------------------------ |
| 🪨 Rocas  | +5/+10/+20 rocas  | Regeneración instantánea |
| 🐠 Koi    | +5/+10/+20 koi    | Spawn inmediato          |
| 🍜 Comida | +5/+10/+20 comida | Regeneración instantánea |

**Mecánicas de Power-ups:**

- **Spawn:** Cada 20 segundos aparece una burbuja aleatoria
- **Duración:** Las burbujas permanecen 5 segundos en pantalla
- **Colecta:** El primer koi en tocar la burbuja obtiene el power-up
- **Regeneración:** Los recursos SOLO se regeneran a través de power-ups

### 📈 **SISTEMA DE RECURSOS**

- **Comida y Rocas:** NO se regeneran automáticamente
- **Obtención:** Solo a través de power-ups en burbujas
- **Estrategia:** Gestión cuidadosa de recursos entre power-ups
- **Competencia:** Los koi deben competir por las burbujas de power-up

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
- **Mejoras entre rondas:** Elegir entre +10 rocas máximas, +10 comidas máximas o +5 koi refuerzo

---

## 🌊 ESTRUCTURA DE RONDAS

### 🥇 **RONDA 1: "Primeros Depredadores"**

- **Duración:** 2 minutos
- **Koi inicial:** 8 koi pequeños (S y M)
- **Spawn de enemigos:** 1 enemigo cada 2 segundos
- **Tipos de enemigos:** Solo Bagres pequeños (90%), Carpas medianas (10%)
- **Puntos base:** 100 pts por koi superviviente

### 🥈 **RONDA 2: "Amenaza Creciente"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 2 koi nuevos (M)
- **Spawn de enemigos:** 1-2 enemigos cada 2 segundos
- **Tipos de enemigos:**
  - Bagres pequeños (60%)
  - Carpas medianas (30%)
  - Lucios grandes (10%)
- **Puntos base:** 150 pts por koi superviviente

### 🥉 **RONDA 3: "Depredadores Grandes"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 1 koi grande (L)
- **Spawn de enemigos:** 2-3 enemigos cada 2 segundos
- **Tipos de enemigos:**
  - Bagres pequeños (40%)
  - Carpas medianas (30%)
  - Lucios grandes (20%)
  - Tiburones (10%)
- **Puntos base:** 200 pts por koi superviviente

### 🏆 **RONDA 4: "Invasión Masiva"**

- **Duración:** 2 minutos
- **Koi:** Supervivientes + 1 koi XL
- **Spawn de enemigos:** 4-5 enemigos cada 2 segundos
- **Tipos de enemigos:**
  - Bagres pequeños (30%)
  - Carpas medianas (30%)
  - Lucios grandes (25%)
  - Tiburones (15%)
- **Puntos base:** 300 pts por koi superviviente

### 👑 **RONDA 5: "Supervivencia Final"**

- **Duración:** 2 minutos
- **Koi:** Solo supervivientes
- **Spawn de enemigos:** 4-5 enemigos cada 2 segundos
- **Tipos de enemigos:**
  - Carpas medianas (20%)
  - Lucios grandes (35%)
  - Tiburones (45%)
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

<!-- ### 🎁 **POWER-UPS ESPECIALES (Solo Modo Endless)**

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
- **Spawn:** Posición aleatoria en el estanque -->

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

Los depredadores son manejados por el KoiManager como peces especiales:

| Tipo          | Tamaño | Puntos de Daño | Velocidad | Puntos de Vida |
| ------------- | ------ | -------------- | --------- | -------------- |
| Bagre Pequeño | 25     | 1              | 0.7x      | 2              |
| Carpa Mediana | 35     | 2              | 0.8x      | 3              |
| Lucio Grande  | 45     | 3              | 0.9x      | 4              |
| Tiburón       | 55     | 4              | 1.0x      | 5              |

**Características:**

- Atraídos tanto por comida como por otros peces
- Causan daño al contacto basado en sus puntos de daño
- Si el daño supera los puntos de vida del koi, este muere
- Si el daño es menor, el koi pierde un nivel
- Requieren múltiples golpes de roca para ser eliminados (puntos de vida)

**Sistema de Spawn:**

- Aparecen cada 2 segundos
- Cantidad y tipos varían según la ronda
- Spawn desde bordes aleatorios del mapa
- Probabilidades ajustadas por ronda
- Mayor dificultad = Más enemigos fuertes

**Comportamiento:**

- Persiguen al koi más cercano
- Evitan rocas y obstáculos
- Se mueven más rápido al detectar koi cercano
- Pueden ser eliminados con rocas
- Dejan power-ups al morir (10% de probabilidad)

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

### 🎮 **FASE 1: SISTEMA BASE Y KOI MANAGER (Completado)**

- [x] Implementar sistema base de simulación
- [x] Crear KoiManager con funcionalidades básicas
- [x] Implementar sistema de partículas para pétalos
- [x] Implementar sistema de velocidad basado en tamaño
- [x] Implementar sistema de vidas/daño para koi
- [x] Agregar contador de alimentación (10 comidas = crecimiento)
- [x] Implementar comportamiento de enemigos en KoiManager
- [x] Crear sistema de colisiones koi-enemigo con daño

### 🎯 **FASE 2: SISTEMA DE PARTÍCULAS Y POWER-UPS (En Progreso)**

- [x] Modificar partículas de comida para flotar 3 segundos
- [ ] Implementar sistema de burbujas power-up
- [ ] Crear efectos visuales para burbujas
- [ ] Agregar spawning aleatorio de power-ups cada 20 segundos
- [ ] Implementar tres tipos de power-ups:
  - [ ] Burbuja con rocas (+5/+10/+20)
  - [ ] Burbuja con koi (+5/+10/+20)
  - [ ] Burbuja con comida (+5/+10/+20)

### ⚔️ **FASE 3: SISTEMA DE WAVES Y DIFICULTAD (Prioritario)**

- [ ] Implementar sistema de spawn de enemigos cada 2 segundos
- [ ] Crear sistema de probabilidad de tipos de enemigos por ronda
- [ ] Implementar escalado de cantidad de enemigos por ronda
- [ ] Balancear dificultad y tipos de enemigos
- [ ] Implementar sistema de puntuación por ronda
- [ ] Crear transiciones entre rondas

### 🎨 **FASE 4: UI Y FEEDBACK VISUAL**

- [ ] Crear indicadores visuales de vidas
- [ ] Implementar efectos de daño
- [ ] Agregar animaciones de power-ups
- [ ] Mejorar feedback de crecimiento/decrecimiento
- [ ] Implementar UI para contadores (comida, vidas)
- [ ] Crear indicador de ronda actual
- [ ] Mostrar probabilidades de enemigos

### 🎵 **FASE 5: PULIDO Y OPTIMIZACIÓN**

- [ ] Optimizar sistema de partículas
- [ ] Mejorar rendimiento de colisiones
- [ ] Agregar efectos de sonido
- [ ] Pulir animaciones y transiciones
- [ ] Testing final y corrección de bugs

### 📊 **SISTEMA DE PUNTUACIÓN ACTUALIZADO**

- **Puntos por Ronda:**

  - Ronda 1: 100 pts por koi
  - Ronda 2: 150 pts por koi
  - Ronda 3: 200 pts por koi
  - Ronda 4: 300 pts por koi
  - Ronda 5: 500 pts por koi

- **Bonus:**
  - Enemigo eliminado: +50 pts
  - Koi crecido: +25 pts
  - Power-up recolectado: +100 pts
  - Ronda completada: +1000 pts
  - Victoria total: +5000 pts

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
