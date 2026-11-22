# HatHumanizer (VST3 Audio Plugin)

> **Procesamiento DSP Dinámico y Humanización de Hi-Hats en Tiempo Real para Producción de Hip Hop y Trap.**  
> Desarrollado en **C++** sobre el framework **JUCE 9** para plataformas de 64 bits (VST3 / Standalone).

---

## 🎧 ¿Qué es HatHumanizer?

En la producción musical contemporánea de música urbana (Trap, Hip Hop, Drill, R&B), los patrones rítmicos de hi-hats suelen sufrir de una rigidez estéril debido a la cuantización estricta a la grilla temporal del DAW.

**HatHumanizer** es un procesador de audio directo que detecta los transitorios del hi-hat en tiempo real e inyecta micro-modulaciones estocásticas de tiempo, dinámica, afinación e imagen estéreo, incorporando además un generador automático de redobles rítmicos sincrónicos (*Trap Rolls*).

---

## ✨ Características Principales

### 1. 🎯 Detección Quirúrgica de Transitorios
- **Filtro Pasa-Altos Butterworth Biquad (12 dB/oct):** Rango ajustable de 150 Hz a 8.000 Hz para aislar el hi-hat y evitar disparos falsos causados por el bombo (808) o el redoblante.
- **Schmitt Trigger con Hold-Off configurable:** Previene re-disparos accidentales en la cola de decaimiento del sample.

### 2. 🎛️ Motor de Humanización Estocástica (HumanizerEngine)
- **Shift (Micro-timing jitter):** Desplazamientos pseudo-aleatorios (0 a 30 ms) que quitan la rigidez robótica sin desfasar el compás.
- **Gain Var:** Fluctuaciones dinámicas orgánicas de ganancia ($\pm 6\text{ dB}$).
- **Pan Var:** Apertura y balance dinámico en el campo estéreo (L / R).
- **Pitch Var:** Desviación micro-tonal en cents con interpolación suave.
- **Amount:** Control macro de intensidad de humanización global.

### 3. 🥁 Generador de Trap Rolls (TrapRollGenerator)
- **Sincronización al BPM:** Se enlaza automáticamente al reloj del DAW anfitrión (`AudioPlayHead`).
- **Subdivisiones rítmicas:** 1/16, 1/24T, 1/32, 1/48T y 1/64.
- **Arquitectura de Choke a 2 Voces (Ping-Pong):** Micro-envolventes suaves de ataque (0.6 ms) y corte (2.0 ms) que garantizan redobles ultrarrápidos limpios de clics de fase.
- **Modulaciones por golpe:** Pitch slide progresivo y rampa dinámica de velocidad.
- **Disparo por probabilidad:** Perilla de `CHANCE` (0% a 100%) y pulsador manual `ROLL NOW`.

### 4. 👁️ Telemetría y Visualización Analógica en Tiempo Real
- **Transient Scope (Osciloscopio CRT):** Visualizador de la forma de onda de audio entrante con retícula, línea guía de umbral (*Threshold*) y destello de fósforo dorado `[HIT]` ante cada transitorio detectado.
- **Groove Memory (Matriz de 8 Golpes Multi-Modo):**
  - **Modo `[ ALL ]`:** Combina Dinámica (barras verdes VU), Apertura Estéreo (diamantes cian L/R) y Tono (curva ámbar) simultáneamente.
  - **Modos Dedicados `[ PITCH ]`, `[ GAIN ]`, `[ PAN ]`:** Zoom a escala vertical completa con valores numéricos exactos por golpe.
- **Thread Safety Garantizado:** Búfers circulares atómicos *lock-free* y submuestreo inteligente para 0% de impacto en la latencia del hilo de audio.

---

## 🛠️ Tecnologías y Requisitos

- **Lenguaje:** C++20
- **Framework:** JUCE 9.0.2
- **Formato:** VST3 (64-bit) / Standalone
- **Entorno de Compilación:** Microsoft Visual Studio 2022 Community (herramientas MSBuild x64)
- **DAWs Compatibles:** FL Studio, Ableton Live, Avid Pro Tools, Reaper, Cubase, Studio One.

---

## 🚀 Compilación Local

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/TU-USUARIO/HatHumanizer.git
   ```
2. Abrir la solución en Visual Studio:
   `HatHumanizer/Builds/VisualStudio2022/HatHumanizer.sln`
3. Seleccionar configuración `Release` y plataforma `x64`.
4. Compilar (`Ctrl + Shift + B`). El binario VST3 se generará automáticamente en:
   `%COMMONPROGRAMFILES%\VST3\HatHumanizer.vst3`

---

## 🎓 Contexto Académico

- **Institución:** Instituto Terciario TAMABA
- **Cátedra:** Creatividad e Innovación · 3er Año
- **Docentes:** Fernanda Bolli, Indio Gauvron, Eugenio Taboada
- **Grupo:** Estocástico
- **Autor:** Franco Benedetti (Benebeats.com)
