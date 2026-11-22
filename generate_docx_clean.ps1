Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$outputDir = "C:\Users\franc\Desktop\Study\3 anio\creatividad e inovacion\Proyecto HH FINAL"
$docxPath = Join-Path $outputDir "BENEBEATS_Entrega.docx"
$tempDir = Join-Path $env:TEMP "docx_fix_$(Get-Random)"

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

# 5. word/document.xml - con entidades XML directas para garantizar 100% de compatibilidad
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
        <w:t>C&#225;tedra de Creatividad e Innovaci&#243;n &#183; 3er A&#241;o</w:t>
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
        <w:t>PRESENTACI&#211;N DEL PROYECTO CURRICULAR</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr>
        <w:jc w:val="center"/>
        <w:spacing w:after="800"/>
      </w:pPr>
      <w:r>
        <w:rPr><w:i/><w:sz w:val="22"/><w:color w:val="595959"/></w:rPr>
        <w:t>Primera Evaluaci&#243;n del Cuatrimestre</w:t>
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
        <w:t>Procesamiento DSP Din&#225;mico y Humanizaci&#243;n de Hi-Hats para Producci&#243;n de Hip Hop y Trap</w:t>
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

    <!-- SALTO DE PAGINA -->
    <w:p>
      <w:r>
        <w:br w:type="page"/>
      </w:r>
    </w:p>

    <!-- 1. PLANTEAMIENTO DE TEMA -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>1. Planteamiento de Tema</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El presente proyecto se sit&#250;a en el campo de la </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>producci&#243;n musical digital, el dise&#241;o de herramientas de audio (Audio Software Development) y el Procesamiento Digital de Se&#241;ales (DSP - Digital Signal Processing)</w:t>
      </w:r>
      <w:r>
        <w:t>, enfocado espec&#237;ficamente en las exigencias est&#233;ticas y t&#233;cnicas de la m&#250;sica urbana contempor&#225;nea (Hip Hop, Trap y R&amp;B).</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>En la producci&#243;n moderna "In the Box" (&#237;ntegramente en computadora), la bater&#237;a y los patrones r&#237;tmicos suelen presentar una rigidez est&#233;ril debida a la cuantizaci&#243;n estricta sobre la grilla temporal del DAW (Digital Audio Workstation). Dentro del ensamble r&#237;tmico, el </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>hi-hat</w:t>
      </w:r>
      <w:r>
        <w:t> es el elemento de mayor densidad de repetici&#243;n por comp&#225;s, marcando el pulso, la textura y la sensaci&#243;n de dinamismo o energ&#237;a de la canci&#243;n.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>El proyecto consiste en el desarrollo, comprensi&#243;n t&#233;cnica y evoluci&#243;n de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>HatHumanizer</w:t>
      </w:r>
      <w:r>
        <w:t>, un plugin de audio nativo en formato VST3 de 64 bits desarrollado sobre el framework JUCE en C++. El procesador detecta transitorios de audio entrantes en tiempo real y aplica micro-variaciones estoc&#225;sticas de tiempo (timing shift), ganancia (velocity dynamics), panorama est&#233;reo (pan variation), tono (pitch variation) y generaci&#243;n de redobles sincr&#243;nicos al tempo del proyecto (trap rolls).</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Asimismo, el proyecto incorpora un marco metodol&#243;gico innovador de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>co-creaci&#243;n asistida por Inteligencia Artificial (Antigravity)</w:t>
      </w:r>
      <w:r>
        <w:t>. Sin contar con formaci&#243;n previa como programador en C++, el autor asume el rol de arquitecto de producto, dise&#241;o sonoro, direcci&#243;n de requerimientos y validaci&#243;n ac&#250;stica, estableciendo como meta acad&#233;mica la comprensi&#243;n profunda de la arquitectura de c&#243;digo generada y su posterior expansi&#243;n funcional.</w:t>
      </w:r>
    </w:p>

    <!-- 2. OBJETIVOS -->
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
        <w:t>Desarrollar, comprender y validar un plugin de audio VST3 funcional en C++ y JUCE capaz de humanizar patrones de hi-hats en tiempo real mediante micro-modulaciones estoc&#225;sticas de audio, ampliando su complejidad algor&#237;tmica y documentando el flujo de trabajo de producci&#243;n e impresi&#243;n (print/bounce) de pistas.</w:t>
      </w:r>
    </w:p>

    <!-- 3. JUSTIFICACION TEORICA -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>3. Justificaci&#243;n Te&#243;rica</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Desde el a&#241;o 2020 me desempe&#241;o activamente como productor musical independiente, comercializando instrumentales y producciones de Hip Hop y Trap para artistas del mercado estadounidense a trav&#233;s de mi sitio web oficial (</w:t>
      </w:r>
      <w:r>
        <w:rPr><w:i/><w:b/></w:rPr>
        <w:t>benebeats.com</w:t>
      </w:r>
      <w:r>
        <w:t>). En dicho mercado, la velocidad de entrega y la calidad sonora son factores determinantes, demandando la finalizaci&#243;n de un alto volumen de instrumentales semana a semana.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Dentro de esta rutina de producci&#243;n en estaciones de trabajo como Pro Tools y FL Studio, la tarea de humanizar los hi-hats es una de las actividades m&#225;s repetitivas y consumidoras de tiempo. Para evitar un sonido mon&#243;tono o artificial, el productor debe:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Desplazar micro-posiciones de notas MIDI </w:t></w:r>
      <w:r><w:t>fuera de la cuadr&#237;cula r&#237;gida (timing jitter/humanize).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Dibujar curvas de automatizaci&#243;n </w:t></w:r>
      <w:r><w:t>de velocidad (velocity dynamics) y volumen por golpe.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Crear variaciones de tono y afinaci&#243;n (pitch shift) </w:t></w:r>
      <w:r><w:t>en ca&#237;das y redobles de tresillos (1/24T, 1/32, 1/48T, 1/64).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:spacing w:before="120"/></w:pPr>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>La aleatoriedad controlada como est&#237;mulo creativo: </w:t>
      </w:r>
      <w:r>
        <w:t>Si bien la aleatoriedad total no siempre es perfecta, la introducci&#243;n de variaciones pseudo-aleatorias dentro de rangos configurables genera una din&#225;mica org&#225;nica y abre paso al "accidente feliz" (serendipity), descubriendo matices r&#237;tmicos inesperados que rompen la rigidez digital sin requerir horas de edici&#243;n manual.</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:rPr><w:b/></w:rPr>
        <w:t>Metodolog&#237;a de "Printeo" (Print &amp; Bounce Workflow): </w:t>
      </w:r>
      <w:r>
        <w:t>Dado que el motor procesa el audio con variables estoc&#225;sticas continuas en tiempo real, cada reproducci&#243;n en el DAW genera una variaci&#243;n sutilmente distinta. En una producci&#243;n musical profesional donde la consistencia de la mezcla final es fundamental, el plugin est&#225; concebido bajo el flujo de </w:t>
      </w:r>
      <w:r>
        <w:rPr><w:i/><w:b/></w:rPr>
        <w:t>"Insertar, Ajustar y Printear"</w:t>
      </w:r>
      <w:r>
        <w:t>: el productor ajusta los controles hasta encontrar el car&#225;cter sonoro ideal y graba (consolida) la pista en un archivo de audio definitivo para la mezcla.</w:t>
      </w:r>
    </w:p>

    <!-- 4. DIAGNOSTICO -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>4. Diagn&#243;stico de la Situaci&#243;n Actual</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>En la actualidad, las herramientas disponibles presentan importantes limitaciones:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>1. Herramientas MIDI nativas del DAW: </w:t></w:r>
      <w:r><w:t>Solo operan a nivel de eventos MIDI antes del sintetizador o sampler. Resultan completamente in&#250;tiles cuando se trabaja con loops de audio cerrados, pistas de audio congeladas (bounced audio) o stems enviados por terceros.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>2. Plugins de humanizaci&#243;n general o efectos de modulaci&#243;n: </w:t></w:r>
      <w:r><w:t>No cuentan con algoritmos de detecci&#243;n de transitorios de alta velocidad optimizados para frecuencias agudas, carecen de filtros de discriminaci&#243;n para rechazar el sangrado de instrumentos graves (snare/kick) y no incorporan generadores de redobles sincronizados al reloj del DAW con atenuaci&#243;n de clicks de fase.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:spacing w:before="100"/></w:pPr>
      <w:r>
        <w:t>Existe por ende un nicho concreto para un procesador de se&#241;al de audio directo, especializado y con interfaz intuitiva.</w:t>
      </w:r>
    </w:p>

    <!-- 5. FACTIBILIDAD -->
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
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Est&#225;ndar Tecnol&#243;gico Industrial: </w:t></w:r>
      <w:r><w:t>Uso del framework JUCE 9.0.2 y compilaci&#243;n nativa en C++ mediante Microsoft Visual Studio 2022 Community (64 bits), generando binarios VST3 est&#225;ndares compatibles con todos los DAWs modernos.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Asistencia Avanzada de Desarrollo (Antigravity): </w:t></w:r>
      <w:r><w:t>La barrera de entrada de la programaci&#243;n en C++ se supera mediante la asistencia de IA, permitiendo iterar r&#225;pidamente sobre la matem&#225;tica DSP y aprender la estructura subyacente.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Banco de Pruebas Real: </w:t></w:r>
      <w:r><w:t>Disponibilidad de un entorno de producci&#243;n activo para contrastar el rendimiento auditivo del plugin frente a mezclas reales de mercado.</w:t></w:r>
    </w:p>

    <!-- 6. METODOLOGIA -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>6. Metodolog&#237;a</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Se adopta una metodolog&#237;a de desarrollo iterativo basada en ciclos cortos de dise&#241;o, programaci&#243;n asistida, compilaci&#243;n, evaluaci&#243;n auditiva y refactorizaci&#243;n:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Fases del Desarrollo T&#233;cnico:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>1. Detecci&#243;n de Transitorios (TransientDetector): </w:t></w:r>
      <w:r><w:t>Implementaci&#243;n de un filtro pasaaltos Butterworth biquad de 12 dB/oct con frecuencia de corte ajustable (150 Hz a 8.000 Hz) para evitar disparos falsos causados por el redoblante o el bombo. Integraci&#243;n de un disparador Schmitt Trigger con tiempo de bloqueo (Hold-Off) configurable.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>2. Motor de Humanizaci&#243;n (HumanizerEngine): </w:t></w:r>
      <w:r><w:t>Buffer circular de retardo con interpolaci&#243;n c&#250;bica de 4 puntos (Hermite) para micro-desplazamientos temporales (0 a 30 ms), variaciones de ganancia, paneo est&#233;reo y desv&#237;o de afinaci&#243;n (Pitch Variation) con decaimiento natural.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>3. Generador de Redobles (TrapRollGenerator): </w:t></w:r>
      <w:r><w:t>Buffer circular de captura continua (16.384 muestras) sincronizado al PlayHead del DAW (BPM). Doble voz de choke con envolventes suaves de 2 ms (smoothstep) que garantizan cortes limpios sin clicks digitales.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>4. Arquitectura de Hilos y UI (PluginProcessor / PluginEditor): </w:t></w:r>
      <w:r><w:t>Aislamiento total del hilo de audio de alta prioridad (lock-free) y renderizado gr&#225;fico reactivo a 30 Hz con sistema de serializaci&#243;n XML para guardado y carga de presets de usuario.</w:t></w:r>
    </w:p>

    <!-- 7. RECURSOS -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>7. Recursos Materiales y Humanos</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:rPr><w:b/></w:rPr><w:t>Recursos Materiales (Hardware y Software):</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>&#8226; Estaci&#243;n de trabajo PC con Windows 11 x64, interfaz de audio profesional, monitores de estudio y auriculares de referencia plana.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>&#8226; Framework JUCE 9.0.2 y Microsoft Visual Studio 2022 Community (herramientas MSBuild x64).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:t>&#8226; Software DAW anfitri&#243;n: FL Studio 21 y Avid Pro Tools.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="120"/></w:pPr>
      <w:r><w:t>&#8226; Asistente de desarrollo con IA (Google Antigravity).</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:rPr><w:b/></w:rPr><w:t>Recursos Humanos:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Franco Benedetti: </w:t></w:r>
      <w:r><w:t>Responsable principal del proyecto, direcci&#243;n conceptual, especificaci&#243;n de requerimientos t&#233;cnicos, ensayos ac&#250;sticos de mezcla y producci&#243;n de instrumentales de prueba.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Colaboradores de Dise&#241;o Visual (UI/UX): </w:t></w:r>
      <w:r><w:t>Posible integraci&#243;n de dos dise&#241;adores gr&#225;ficos externos para la elaboraci&#243;n de maquetas visuales (mockups en Figma/Photoshop), dise&#241;o de perillas vectoriales y refinamiento est&#233;tico de la interfaz.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Consultor&#237;a T&#233;cnica Externa: </w:t></w:r>
      <w:r><w:t>Consultas y mentor&#237;a ocasional con un ingeniero en sistemas especializado con experiencia previa en desarrollo de plugins de audio (revisi&#243;n de arquitectura C++, optimizaci&#243;n de memoria y resoluci&#243;n de dependencias complejas).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="120"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Asistente de Desarrollo con IA (Antigravity): </w:t></w:r>
      <w:r><w:t>Herramienta agentica para aceleraci&#243;n de c&#243;digo, c&#225;lculos matem&#225;ticos de filtros DSP y scaffolding de clases en JUCE.</w:t></w:r>
    </w:p>

    <!-- 8. SECUENCIA TEMPORAL -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>8. Acciones y Secuencia Temporal (Cronograma)</w:t></w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t>Dado que la metodolog&#237;a parte de un prototipado funcional r&#225;pido asistido por IA, el cronograma equilibra el desarrollo t&#233;cnico inicial con etapas profundas de comprensi&#243;n algor&#237;tmica, experimentaci&#243;n en sesiones reales de mezcla, depuraci&#243;n y expansi&#243;n de funciones complejas:</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Semanas 1 &#8211; 2 (Prototipado R&#225;pido y Scaffolding Base): </w:t></w:r>
      <w:r><w:t>Configuraci&#243;n del entorno JUCE/C++ y ensamble de un MVP (Producto M&#237;nimo Viable) asistido por Antigravity, integrando la cadena fundamental: detecci&#243;n de transitorios, modulaci&#243;n de pitch/timing y generador de rolls base para validar la viabilidad sonora.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Semanas 3 &#8211; 4 (Auditor&#237;a T&#233;cnica y Comprensi&#243;n del C&#243;digo DSP): </w:t></w:r>
      <w:r><w:t>Desglose pedag&#243;gico y an&#225;lisis l&#237;nea por l&#237;nea de la arquitectura C++ (gesti&#243;n de memoria en buffers circulares, interpolaci&#243;n Hermite de 4 puntos y comunicaci&#243;n thread-safe entre el hilo de audio y la interfaz).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Semanas 5 &#8211; 6 (Banco de Pruebas Ac&#250;stico, Detecci&#243;n de Errores y Calibraci&#243;n de Precisi&#243;n): </w:t></w:r>
      <w:r><w:t>Testeo intensivo en sesiones reales de FL Studio y Pro Tools con diversos tipos de hi-hats (808 sint&#233;ticos, grabaciones ac&#250;sticas y loops con sangrado). Detecci&#243;n y resoluci&#243;n de errores t&#233;cnicos, micro-artefactos de fase y calibraci&#243;n fina de los filtros para lograr una respuesta de detecci&#243;n de transitorios mucho m&#225;s precisa y libre de falsos disparos provocados por el redoblante o el bombo.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Semanas 7 &#8211; 8 (Investigaci&#243;n, Experimentaci&#243;n y Expansi&#243;n Funcional): </w:t></w:r>
      <w:r><w:t>Etapa abierta de exploraci&#243;n y desarrollo de nuevas herramientas seg&#250;n las conclusiones de la etapa de testeo. Se evaluar&#225; la adaptaci&#243;n del algoritmo para otros elementos percusivos (redoblantes, percusiones secundarias), la incorporaci&#243;n de saturaci&#243;n suave tipo cinta (tape saturation), o la experimentaci&#243;n con un m&#243;dulo de resampleo y micro-chops de melod&#237;as vocales basado en la din&#225;mica de rolls de trap.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Semanas 9 &#8211; 10 (Refinamiento Visual, Flujo de Printeo y Evaluaci&#243;n Final): </w:t></w:r>
      <w:r><w:t>Pulido definitivo de la est&#233;tica visual vintage en colaboraci&#243;n con dise&#241;o externo, optimizaci&#243;n de consumo de CPU, documentaci&#243;n del flujo de trabajo "Print &amp; Bounce" en mezcla comercial y redacci&#243;n del informe final de cierre.</w:t></w:r>
    </w:p>

    <!-- 9. ANEXO -->
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>9. Anexo / Antecedentes y Marco T&#233;cnico</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Software y Referencias de la Industria:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; XLN Audio (RC-20 Retro Color): </w:t></w:r>
      <w:r><w:t>Referente en modulaci&#243;n estoc&#225;stica de tono y fluctuaciones anal&#243;gicas de cinta.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Goodhertz (Vulf Compressor / Wow Control): </w:t></w:r>
      <w:r><w:t>Inspiraci&#243;n en control de din&#225;micas transitorias no lineales.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Cableguys (ShaperBox / HalfTime): </w:t></w:r>
      <w:r><w:t>Modelos de sincronizaci&#243;n temporal precisa con el reloj del DAW anfitri&#243;n.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
      <w:r><w:t>Glosario de Conceptos de Ingenier&#237;a de Audio en C++ / JUCE:</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; C++:</w:t></w:r>
      <w:r><w:t> Lenguaje de programaci&#243;n compilado de alto rendimiento sin recolector de basura (garbage collector), indispensable para garantizar latencia cero en audio en tiempo real.</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; JUCE Framework:</w:t></w:r>
      <w:r><w:t> Entorno de desarrollo l&#237;der en la industria de audio que proporciona las clases base </w:t></w:r>
      <w:r><w:rPr><w:i/></w:rPr><w:t>AudioProcessor</w:t></w:r>
      <w:r><w:t> (procesamiento digital en bloques de muestras) y </w:t></w:r>
      <w:r><w:rPr><w:i/></w:rPr><w:t>AudioProcessorValueTreeState</w:t></w:r>
      <w:r><w:t> (gesti&#243;n segura de par&#225;metros sincronizados entre la interfaz visual y el hilo de audio).</w:t></w:r>
    </w:p>
    <w:p>
      <w:pPr><w:ind w:left="400"/><w:spacing w:after="60"/></w:pPr>
      <w:r><w:rPr><w:b/></w:rPr><w:t>&#8226; Interpolaci&#243;n C&#250;bica Hermite (4-point):</w:t></w:r>
      <w:r><w:t> Algoritmo matem&#225;tico para interpolar valores entre muestras no enteras en el buffer, permitiendo modulaciones suaves de pitch y tiempo sin generar distorsi&#243;n digital ni aliasing.</w:t></w:r>
    </w:p>

    <!-- CIERRE -->
    <w:p>
      <w:pPr>
        <w:spacing w:before="600"/>
        <w:pBdr>
          <w:top w:val="single" w:sz="6" w:space="8" w:color="CCCCCC"/>
        </w:pBdr>
      </w:pPr>
      <w:r>
        <w:rPr><w:sz w:val="18"/><w:color w:val="7F7F7F"/></w:rPr>
        <w:t>HatHumanizer &#8212; Proyecto desarrollado por Franco Benedetti (benebeats.com) para la C&#225;tedra de Creatividad e Innovaci&#243;n, Instituto Tamaba.</w:t>
      </w:r>
    </w:p>

  </w:body>
</w:document>
'@
[System.IO.File]::WriteAllText("$tempDir\word\document.xml", $docXml, [System.Text.Encoding]::UTF8)

# 6. Comprimir en .docx
try {
    if (Test-Path $docxPath) { Remove-Item $docxPath -Force -ErrorAction Stop }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $docxPath)
    Write-Output "DOCX creado exitosamente en: $docxPath"
} catch {
    $altPath = Join-Path $outputDir "BENEBEATS_Entrega_Actualizado.docx"
    if (Test-Path $altPath) { Remove-Item $altPath -Force -ErrorAction SilentlyContinue }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $altPath)
    Write-Output "DOCX creado exitosamente en: $altPath (archivo anterior estaba abierto en Word)"
}
