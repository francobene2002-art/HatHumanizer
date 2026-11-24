# HatHumanizer 🥁✨

Plugin de audio (VST3 / Standalone) diseñado para darle vida, movimiento y variación orgánica a patrones de hi-hats en Trap, Hip Hop y música urbana.

Desarrollado en **C++** utilizando el framework **JUCE 9** para Windows de 64 bits.

---

## 💡 ¿Qué problema resuelve?

En la producción de música urbana, los hi-hats suelen dibujarse en la grilla del DAW o programarse con repeticiones mecánicas. Cuando todos los golpes suenan en el tiempo milimétrico exacto, con el mismo volumen y el mismo tono, el ritmo se vuelve estéril y suena robótico.

**HatHumanizer** escucha la pista en tiempo real, detecta cada golpe de platillo y le aplica pequeñas variaciones naturales (estocásticas) de tiempo, volumen, paneo y tono, además de incluir un generador automático de redobles (*rolls*).

---

## 🎛️ ¿Cómo funciona?

El plugin está dividido en 3 bloques principales:

### 1. Detección (`DETECTION`)
Detecta en qué momento cae cada golpe de hi-hat sobre el audio entrante:
* **Threshold (Umbral):** Nivel de volumen mínimo necesario para activar la detección del golpe.
* **Hold-Off:** Breve tiempo de espera (en milisegundos) después de un golpe para evitar dobles disparos provocados por la cola del platillo.
* **HP Filter (Filtro Pasa-Altos):** Filtro interno para ignorar los graves del bombo o la caja y escuchar solo el brillo del hi-hat.
* **Transient Scope:** Pantallita estilo osciloscopio que muestra la onda y una línea punteada de umbral para calibrarlo fácilmente a ojo.

### 2. Humanización (`HUMANIZER`)
Aplica variaciones sutiles y controladas a cada golpe detectado:
* **Shift:** Pequeñas desviaciones de tiempo (micro-timing) para despegar el golpe de la rigidez de la grilla.
* **Gain Var:** Fluctuaciones de volumen entre golpe y golpe, simulando la fuerza variable de la mano de un baterista.
* **Pan Var:** Leve movimiento hacia la izquierda o derecha en el campo estéreo.
* **Pitch Var:** Micro-variaciones de tono en cents.
* **Amount:** Perilla general que controla la intensidad global de todo el efecto.

### 3. Redobles de Trap (`TRAP ROLLS`)
Genera redobles rítmicos automáticamente sincronizados al tempo (BPM) del DAW:
* **Rate:** Subdivisión rítmica del redoble (1/16, 1/32, 1/64 o tresillos).
* **Length:** Duración del redoble (1/4 de compás, 1/2 compás, etc.).
* **Chance:** Probabilidad (0% a 100%) de que el redoble se dispare solo en cada compás.
* **Slope & Slide:** Permite que los redobles suban/bajen de volumen o cambien de tono progresivamente.
* **Roll Now:** Botón manual para disparar un redoble en vivo en el momento exacto.

---

## 🖥️ Visualizador (Groove Memory)

En la parte inferior cuenta con una pantalla que registra los últimos 8 golpes detectados, permitiendo ver de forma gráfica e intuitiva cómo va variando el volumen, el paneo y la afinación de cada hi-hat.

---

## ⚙️ Requisitos y Compatibilidad

* **Formato:** VST3 (64-bit) y ejecutable Standalone (.exe).
* **Sistema Operativo:** Windows 10 / 11 (x64).
* **DAWs compatibles:** FL Studio, Ableton Live, Reaper, Cubase, Studio One, etc.

---

## 👨‍💻 Autor

* **Franco Benedetti** ([benebeats.com](https://benebeats.com))
* Proyecto final para la cátedra de *Creatividad e Innovación* (3er Año) - Instituto Terciario TAMABA.
