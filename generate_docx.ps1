Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$outputDir = "C:\Users\franc\Desktop\Study\3 anio\creatividad e inovacion\Proyecto HH FINAL"
$docxPath = Join-Path $outputDir "BENEBEATS - HatHumanizer Primera Evaluacion.docx"
$tempDir = Join-Path $env:TEMP "docx_build_$(Get-Random)"

New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\word" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\word\_rels" -Force | Out-Null

# 1. [Content_Types].xml
$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
'@
[System.IO.File]::WriteAllText("$tempDir\[Content_Types].xml", $contentTypes, [System.Text.Encoding]::UTF8)

# 2. _rels/.rels
$rels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\_rels\.rels", $rels, [System.Text.Encoding]::UTF8)

# 3. word/_rels/document.xml.rels
$docRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\word\_rels\document.xml.rels", $docRels, [System.Text.Encoding]::UTF8)

# 4. word/styles.xml
$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault>
      <w:rPr>
        <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/>
        <w:sz w:val="23"/>
        <w:szCs w:val="23"/>
        <w:color w:val="222222"/>
        <w:lang w:val="es-ES"/>
      </w:rPr>
    </w:rPrDefault>
    <w:pPrDefault>
      <w:pPr>
        <w:spacing w:line="276" w:lineRule="auto" w:after="140"/>
      </w:pPr>
    </w:pPrDefault>
  </w:docDefaults>
  
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:pPr>
      <w:spacing w:before="360" w:after="160"/>
      <w:keepNext/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:b/>
      <w:color w:val="1F4E79"/>
      <w:sz w:val="32"/>
      <w:szCs w:val="32"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:pPr>
      <w:spacing w:before="240" w:after="120"/>
      <w:keepNext/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:b/>
      <w:color w:val="2E75B6"/>
      <w:sz w:val="26"/>
      <w:szCs w:val="26"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading3">
    <w:name w:val="heading 3"/>
    <w:pPr>
      <w:spacing w:before="160" w:after="80"/>
      <w:keepNext/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:color w:val="5B9BD5"/>
      <w:sz w:val="24"/>
      <w:szCs w:val="24"/>
    </w:rPr>
  </w:style>
</w:styles>
'@
[System.IO.File]::WriteAllText("$tempDir\word\styles.xml", $styles, [System.Text.Encoding]::UTF8)

# 5. word/document.xml
$docXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
            xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:body>

    <!-- CARATULA -->
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:before="400" w:after="100"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:sz w:val="30"/><w:color w:val="1F4E79"/></w:rPr>
        <w:t>INSTITUTO TAMABA</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="800"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="22"/><w:color w:val="595959"/></w:rPr>
        <w:t>Cátedra de Creatividad e Innovación · 3er Año</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="200"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="22"/><w:color w:val="7F7F7F"/><w:b/></w:rPr>
        <w:t>[ ESPACIO PARA LOGO DE TAMABA ]</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:before="600" w:after="160"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:sz w:val="26"/><w:color w:val="2E75B6"/></w:rPr>
        <w:t>PRESENTACIÓN DEL PROYECTO CURRICULAR</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="800"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:i/><w:sz w:val="22"/><w:color w:val="595959"/></w:rPr>
        <w:t>Primera Evaluación del Cuatrimestre</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:before="600" w:after="160"/>
        <w:pBdr>
          <w:top w:val="single" w:sz="12" w:space="8" w:color="1F4E79"/>
          <w:bottom w:val="single" w:sz="12" w:space="8" w:color="1F4E79"/>
        </w:pBdr>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:sz w:val="36"/><w:color w:val="1F4E79"/></w:rPr>
        <w:t>HAT HUMANIZER: VST3 AUDIO PLUGIN</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="1200"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="22"/><w:color w:val="595959"/></w:rPr>
        <w:t>Procesamiento DSP Dinámico y Humanización de Hi-Hats para Producción de Hip Hop y Trap</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:before="1000" w:after="100"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="20"/><w:color w:val="595959"/></w:rPr>
        <w:t>Nombre del Grupo:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="400"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:sz w:val="28"/><w:color w:val="1F4E79"/></w:rPr>
        <w:t>BENEBEATS</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="100"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="20"/><w:color w:val="595959"/></w:rPr>
        <w:t>Integrante:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="600"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:sz w:val="24"/><w:color w:val="222222"/></w:rPr>
        <w:t>Franco Benedetti</w:t>
      </w:r>
    </w:p>

    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:before="800" w:after="200"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="20"/><w:color w:val="7F7F7F"/></w:rPr>
        <w:t>Buenos Aires, 5 de Octubre de 2026</w:t>
      </w:r>
    </w:p>

    <!-- PAGE BREAK DESPUES DE CARATULA -->
    <w:p>
      <w:r>
        <w:br w:type="page"/>
      </w:r>
    </w:p>

    <!-- SECCION 1: PLANTEAMIENTO -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>1. Planteamiento de Tema</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El presente proyecto se sitúa en el campo de la </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>producción musical digital, el diseño de herramientas de audio (Audio Software Development) y el Procesamiento Digital de Señales (DSP - Digital Signal Processing)</w:t>
      </w:r>
      <w:r>
        <w:t>, enfocado específicamente en las exigencias estéticas y técnicas de la música urbana contemporánea (Hip Hop, Trap y R&amp;B).</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>En la producción moderna "In the Box" (íntegramente en computadora), la batería y los patrones rítmicos suelen presentar una rigidez estéril debida a la cuantización estricta sobre la grilla temporal del DAW (Digital Audio Workstation). Dentro del ensamble rítmico, el </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>hi-hat</w:t>
      </w:r>
      <w:r>
        <w:t> es el elemento de mayor densidad de repetición por compás, marcando el pulso, la textura y la sensación de dinamismo o energía de la canción.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El proyecto consiste en el desarrollo, comprensión técnica y evolución de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>HatHumanizer</w:t>
      </w:r>
      <w:r>
        <w:t>, un plugin de audio nativo en formato VST3 de 64 bits desarrollado sobre el framework JUCE en C++. El procesador detecta transitorios de audio entrantes en tiempo real y aplica micro-variaciones estocásticas de tiempo (timing shift), ganancia (velocity dynamics), panorama estéreo (pan variation), tono (pitch variation) y generación de redobles sincrónicos al tempo del proyecto (trap rolls).</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Asimismo, el proyecto incorpora un marco metodológico innovador de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>co-creación asistida por Inteligencia Artificial (Antigravity)</w:t>
      </w:r>
      <w:r>
        <w:t>. Sin contar con formación previa como programador en C++, el autor asume el rol de arquitecto de producto, diseño sonoro, dirección de requerimientos y validación acústica, estableciendo como meta académica la comprensión profunda de la arquitectura de código generada y su posterior expansión funcional.</w:t>
      </w:r>
    </w:p>

    <!-- SECCION 2: OBJETIVOS -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>2. Objetivos</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:pBdr>
          <w:left w:val="single" w:sz="24" w:space="12" w:color="1F4E79"/>
        </w:pBdr>
        <w:spacing w:before="160" w:after="160"/>
        <w:ind w:left="240"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:b/><w:i/><w:color w:val="1F4E79"/></w:rPr>
        <w:t>Desarrollar, comprender y validar un plugin de audio VST3 funcional en C++ y JUCE capaz de humanizar patrones de hi-hats en tiempo real mediante micro-modulaciones estocásticas de audio, ampliando su complejidad algorítmica y documentando el flujo de trabajo de producción e impresión (print/bounce) de pistas.</w:t>
      </w:r>
    </w:p>

    <!-- SECCION 3: JUSTIFICACION TEORICA -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>3. Justificación Teórica</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Desde el año 2020 me desempeño activamente como productor musical independiente, comercializando instrumentales y producciones de Hip Hop y Trap para artistas del mercado estadounidense a través de mi sitio web oficial (</w:t>
      </w:r>
      <w:r>
        <w:rPr><w:i/><w:b/></w:rPr>
        <w:t>benebeats.com</w:t>
      </w:r>
      <w:r>
        <w:t>). En dicho mercado, la velocidad de entrega y la calidad sonora son factores determinantes, demandando la finalización de un alto volumen de instrumentales semana a semana.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Dentro de esta rutina de producción en estaciones de trabajo como Pro Tools y FL Studio, la tarea de humanizar los hi-hats es una de las actividades más repetitivas y consumidoras de tiempo. Para evitar un sonido monótono o artificial, el productor debe:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Desplazar micro-posiciones de notas MIDI </w:t></w:r>
      <w:r><w:t>fuera de la cuadrícula rígida (timing jitter/humanize).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Dibujar curvas de automatización </w:t></w:r>
      <w:r><w:t>de velocidad (velocity dynamics) y volumen por golpe.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Crear variaciones de tono y afinación (pitch shift) </w:t></w:r>
      <w:r><w:t>en caídas y redobles de tresillos (1/24T, 1/32, 1/48T, 1/64).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:spacing w:before="120"/></w:pPr>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>La aleatoriedad controlada como estímulo creativo: </w:t>
      </w:r>
      <w:r>
        <w:t>Si bien la aleatoriedad total no siempre es perfecta, la introducción de variaciones pseudo-aleatorias dentro de rangos configurables genera una dinámica orgánica y abre paso al "accidente feliz" (serendipity), descubriendo matices rítmicos inesperados que rompen la rigidez digital sin requerir horas de edición manual.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>Metodología de "Printeo" (Print &amp; Bounce Workflow): </w:t>
      </w:r>
      <w:r>
        <w:t>Dado que el motor procesa el audio con variables estocásticas continuas en tiempo real, cada reproducción en el DAW genera una variación sutilmente distinta. En una producción musical profesional donde la consistencia de la mezcla final es fundamental, el plugin está concebido bajo el flujo de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:i/><w:b/></w:rPr>
        <w:t>"Insertar, Ajustar y Printear"</w:t>
      </w:r>
      <w:r>
        <w:t>: el productor ajusta los controles hasta encontrar el carácter sonoro ideal y graba (consolida) la pista en un archivo de audio definitivo para la mezcla.</w:t>
      </w:r>
    </w:p>

    <!-- SECCION 4: DIAGNOSTICO -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>4. Diagnóstico de la Situación Actual</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>En la actualidad, las herramientas disponibles presentan importantes limitaciones:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>1. Herramientas MIDI nativas del DAW: </w:t></w:r>
      <w:r><w:t>Solo operan a nivel de eventos MIDI antes del sintetizador o sampler. Resultan completamente inútiles cuando se trabaja con loops de audio cerrados, pistas de audio congeladas (bounced audio) o stems enviados por terceros.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>2. Plugins de humanización general o efectos de modulación: </w:t></w:r>
      <w:r><w:t>No cuentan con algoritmos de detección de transitorios de alta velocidad optimizados para frecuencias agudas, carecen de filtros de discriminación para rechazar el sangrado de instrumentos graves (snare/kick) y no incorporan generadores de redobles sincronizados al reloj del DAW con atenuación de clicks de fase.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:spacing w:before="100"/></w:pPr>
      <w:r>
        <w:t>Existe por ende un nicho concreto para un procesador de señal de audio directo, especializado y con interfaz intuitiva.</w:t>
      </w:r>
    </w:p>

    <!-- SECCION 5: FACTIBILIDAD -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>5. Factibilidad y Viabilidad</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El proyecto es plenamente viable y factible sobre la base de los siguientes pilares:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Estándar Tecnológico Industrial: </w:t></w:r>
      <w:r><w:t>Uso del framework JUCE 9.0.2 y compilación nativa en C++ mediante Microsoft Visual Studio 2022 Community (64 bits), generando binarios VST3 estándares compatibles con todos los DAWs modernos.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Asistencia Avanzada de Desarrollo (Antigravity): </w:t></w:r>
      <w:r><w:t>La barrera de entrada de la programación en C++ se supera mediante la asistencia de IA, permitiendo iterar rápidamente sobre la matemática DSP y aprender la estructura subyacente.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Banco de Pruebas Real: </w:t></w:r>
      <w:r><w:t>Disponibilidad de un entorno de producción activo para contrastar el rendimiento auditivo del plugin frente a mezclas reales de mercado.</w:t></w:r>
    </w:p>

    <!-- SECCION 6: METODOLOGIA -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>6. Metodología</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Se adopta una metodología de desarrollo iterativo basada en ciclos cortos de diseño, programación asistida, compilación, evaluación auditiva y refactorización:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Fases del Desarrollo Técnico:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>1. Detección de Transitorios (TransientDetector): </w:t></w:r>
      <w:r><w:t>Implementación de un filtro pasaaltos Butterworth biquad de 12 dB/oct con frecuencia de corte ajustable (150 Hz a 8.000 Hz) para evitar disparos falsos causados por el redoblante o el bombo. Integración de un disparador Schmitt Trigger con tiempo de bloqueo (Hold-Off) configurable.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>2. Motor de Humanización (HumanizerEngine): </w:t></w:r>
      <w:r><w:t>Buffer circular de retardo con interpolación cúbica de 4 puntos (Hermite) para micro-desplazamientos temporales (0 a 30 ms), variaciones de ganancia, paneo estéreo y desvío de afinación (Pitch Variation) con decaimiento natural.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>3. Generador de Redobles (TrapRollGenerator): </w:t></w:r>
      <w:r><w:t>Buffer circular de captura continua (16.384 muestras) sincronizado al PlayHead del DAW (BPM). Doble voz de choke con envolventes suaves de 2 ms (smoothstep) que garantizan cortes limpios sin clicks digitales.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>4. Arquitectura de Hilos y UI (PluginProcessor / PluginEditor): </w:t></w:r>
      <w:r><w:t>Aislamiento total del hilo de audio de alta prioridad (lock-free) y renderizado gráfico reactivo a 30 Hz con sistema de serialización XML para guardado y carga de presets de usuario.</w:t></w:r>
    </w:p>

    <!-- SECCION 7: RECURSOS -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>7. Recursos Materiales y Humanos</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:rPr><w:b/></w:rPr><w:t>Recursos Materiales (Hardware y Software):</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>• Estación de trabajo PC con Windows 11 x64, interfaz de audio profesional, monitores de estudio y auriculares de referencia plana.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>• Framework JUCE 9.0.2 y Microsoft Visual Studio 2022 Community (herramientas MSBuild x64).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>• Software DAW anfitrión: FL Studio 21 y Avid Pro Tools.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="120"/></w:pPr>
      <w:r><w:t>• Asistente de desarrollo con IA (Google Antigravity).</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:rPr><w:b/></w:rPr><w:t>Recursos Humanos:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>• Franco Benedetti: Responsable del proyecto, diseño conceptual, dirección técnica, ensayos de escucha y producción de beats de prueba.</w:t></w:r>
    </w:p>

    <!-- SECCION 8: SECUENCIA TEMPORAL -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>8. Acciones y Secuencia Temporal (Cronograma)</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El cronograma de trabajo se estructura en cinco etapas secuenciales:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Semanas 1 – 2 (Investigación y Scaffolding): </w:t></w:r>
      <w:r><w:t>Configuración del árbol de JUCE, estructuración de la clase PluginProcessor, compilación base y diseño inicial del detector de transitorios.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Semanas 3 – 4 (Motor DSP Básico): </w:t></w:r>
      <w:r><w:t>Implementación de retardos en buffer circular, algoritmos de micro-timing, randomizadores de ganancia y paneo. Suavizado de parámetros contra artefactos de cremallera (zipper noise).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Semanas 5 – 6 (Filtro Ajustable, Pitch y Presets): </w:t></w:r>
      <w:r><w:t>Adición del filtro Butterworth ajustable para discriminación espectral, modulación de pitch por puntero varispeed y persistencia de presets de usuario en XML.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Semanas 7 – 8 (Módulo Trap Rolls y Sincronización DAW): </w:t></w:r>
      <w:r><w:t>Integración del generador de redobles sincronizado al BPM mediante lectura de PlayHead, subdivisiones rítmicas y envelopes de micro-fade.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Semanas 9 – 10 (Refinamiento UI y Evaluación Final): </w:t></w:r>
      <w:r><w:t>Rediseño estético analógico vintage (estilo años 60), integración de enlaces de autor, pruebas intensivas de mezcla y redacción del informe definitivo.</w:t></w:r>
    </w:p>

    <!-- SECCION 9: ANEXO -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>9. Anexo / Antecedentes y Marco Técnico</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Software y Referencias de la Industria:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• XLN Audio (RC-20 Retro Color): </w:t></w:r>
      <w:r><w:t>Referente en modulación estocástica de tono y fluctuaciones analógicas de cinta.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Goodhertz (Vulf Compressor / Wow Control): </w:t></w:r>
      <w:r><w:t>Inspiración en control de dinámicas transitorias no lineales.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Cableguys (ShaperBox / HalfTime): </w:t></w:r>
      <w:r><w:t>Modelos de sincronización temporal precisa con el reloj del DAW anfitrión.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Glosario de Conceptos de Ingeniería de Audio en C++ / JUCE:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• C++:</w:t></w:r>
      <w:r><w:t> Lenguaje de programación compilado de alto rendimiento sin recolector de basura (garbage collector), indispensable para garantizar latencia cero en audio en tiempo real.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• JUCE Framework:</w:t></w:r>
      <w:r><w:t> Entorno de desarrollo líder en la industria de audio que proporciona las clases base </w:t></w:r>
      <w:r><w:rPr><w:i/></w:rPr><w:t>AudioProcessor</w:t></w:r>
      <w:r><w:t> (procesamiento digital en bloques de muestras) y </w:t></w:r>
      <w:r><w:rPr><w:i/></w:rPr><w:t>AudioProcessorValueTreeState</w:t></w:r>
      <w:r><w:t> (gestión segura de parámetros sincronizados entre la interfaz visual y el hilo de audio).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>• Interpolación Cúbica Hermite (4-point):</w:t></w:r>
      <w:r><w:t> Algoritmo matemático para interpolar valores entre muestras no enteras en el buffer, permitiendo modulaciones suaves de pitch y tiempo sin generar distorsión digital ni aliasing.</w:t></w:r>
    </w:p>

    <!-- SECCION FINAL / CIERRE -->
    <w:p>
      <w:pPr>
        <w:spacing w:before="600"/>
        <w:pBdr>
          <w:top w:val="single" w:sz="6" w:space="8" w:color="CCCCCC"/>
        </w:pBdr>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="18"/><w:color w:val="7F7F7F"/></w:rPr>
        <w:t>HatHumanizer — Proyecto desarrollado por Franco Benedetti (benebeats.com) para la Cátedra de Creatividad e Innovación, Instituto Tamaba.</w:t>
      </w:r>
    </w:p>

  </w:body>
</w:document>
'@
[System.IO.File]::WriteAllText("$tempDir\word\document.xml", $docXml, [System.Text.Encoding]::UTF8)

# 6. Comprimir en .docx
if (Test-Path $docxPath) { Remove-Item $docxPath -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $docxPath)

# Limpiar directorio temporal
Remove-Item -Recurse -Force $tempDir

Write-Output "DOCX creado exitosamente en: $docxPath"
