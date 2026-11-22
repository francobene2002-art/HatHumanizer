Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$outputDir = "C:\Users\franc\Desktop\Study\3 anio\creatividad e inovacion\Proyecto HH FINAL"
$pptxPath = Join-Path $outputDir "Presentacion_HatHumanizer_Estocastico.pptx"
$tempDir = Join-Path $env:TEMP "pptx_build_$(Get-Random)"

New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slides" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slides\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slideLayouts" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slideLayouts\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slideMasters" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\slideMasters\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$tempDir\ppt\theme" -Force | Out-Null

# 1. [Content_Types].xml
$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
  <Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
  <Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
  <Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
  <Override PartName="/ppt/slides/slide1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/ppt/slides/slide2.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/ppt/slides/slide3.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/ppt/slides/slide4.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/ppt/slides/slide5.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
</Types>
'@
[System.IO.File]::WriteAllText("$tempDir\[Content_Types].xml", $contentTypes, [System.Text.Encoding]::UTF8)

# 2. _rels/.rels
$rels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\_rels\.rels", $rels, [System.Text.Encoding]::UTF8)

# 3. ppt/_rels/presentation.xml.rels
$presRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide1.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide2.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide3.xml"/>
  <Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide4.xml"/>
  <Relationship Id="rId6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide5.xml"/>
  <Relationship Id="rId7" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\_rels\presentation.xml.rels", $presRels, [System.Text.Encoding]::UTF8)

# 4. ppt/presentation.xml (16:9 Widescreen)
$presXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:sldMasterIdLst>
    <p:sldMasterId id="2147483648" r:id="rId1" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
  </p:sldMasterIdLst>
  <p:sldIdLst>
    <p:sldId id="256" r:id="rId2" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
    <p:sldId id="257" r:id="rId3" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
    <p:sldId id="258" r:id="rId4" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
    <p:sldId id="259" r:id="rId5" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
    <p:sldId id="260" r:id="rId6" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
  </p:sldIdLst>
  <p:sldSz cx="12192000" cy="6858000" type="screen16x9"/>
  <p:notesSz cx="6858000" cy="9144000"/>
</p:presentation>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\presentation.xml", $presXml, [System.Text.Encoding]::UTF8)

# 5. ppt/theme/theme1.xml
$themeXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Studio Dark Theme">
  <a:themeElements>
    <a:clrScheme name="Studio Dark">
      <a:dk1><a:srgbClr val="121214"/></a:dk1>
      <a:lt1><a:srgbClr val="F4F4F5"/></a:lt1>
      <a:dk2><a:srgbClr val="27272A"/></a:dk2>
      <a:lt2><a:srgbClr val="E4E4E7"/></a:lt2>
      <a:accent1><a:srgbClr val="D97706"/></a:accent1>
      <a:accent2><a:srgbClr val="0EA5E9"/></a:accent2>
      <a:accent3><a:srgbClr val="10B981"/></a:accent3>
      <a:accent4><a:srgbClr val="8B5CF6"/></a:accent4>
      <a:accent5><a:srgbClr val="F59E0B"/></a:accent5>
      <a:accent6><a:srgbClr val="64748B"/></a:accent6>
      <a:hlink><a:srgbClr val="38BDF8"/></a:hlink>
      <a:folHlink><a:srgbClr val="A855F7"/></a:folHlink>
    </a:clrScheme>
    <a:fontScheme name="Studio Fonts">
      <a:majorFont><a:latin typeface="Segoe UI Semibold"/></a:majorFont>
      <a:minorFont><a:latin typeface="Segoe UI"/></a:minorFont>
    </a:fontScheme>
    <a:fmtScheme name="Studio Format">
      <a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:fillStyleLst>
      <a:lnStyleLst><a:ln w="9525"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln></a:lnStyleLst>
      <a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst>
      <a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:bgFillStyleLst>
    </a:fmtScheme>
  </a:themeElements>
</a:theme>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\theme\theme1.xml", $themeXml, [System.Text.Encoding]::UTF8)

# 6. ppt/slideMasters/slideMaster1.xml
$slideMasterXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
             xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:bg>
      <p:bgPr>
        <a:solidFill><a:srgbClr val="141416"/></a:solidFill>
      </p:bgPr>
    </p:bg>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
    </p:spTree>
  </p:cSld>
  <p:clrMap bg1="dk1" tx1="lt1" bg2="dk2" tx2="lt2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/>
  <p:sldLayoutIdLst>
    <p:sldLayoutId id="2147483649" r:id="rId1" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
  </p:sldLayoutIdLst>
  <p:txStyles/>
</p:sldMaster>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slideMasters\slideMaster1.xml", $slideMasterXml, [System.Text.Encoding]::UTF8)

# 7. ppt/slideMasters/_rels/slideMaster1.xml.rels
$smRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slideMasters\_rels\slideMaster1.xml.rels", $smRels, [System.Text.Encoding]::UTF8)

# 8. ppt/slideLayouts/slideLayout1.xml
$layoutXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
             xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank">
  <p:cSld name="Blank Layout">
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sldLayout>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slideLayouts\slideLayout1.xml", $layoutXml, [System.Text.Encoding]::UTF8)

# 9. ppt/slideLayouts/_rels/slideLayout1.xml.rels
$slRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slideLayouts\_rels\slideLayout1.xml.rels", $slRels, [System.Text.Encoding]::UTF8)

# Helper para _rels de cada slide
for ($i=1; $i -le 5; $i++) {
$slideRel = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\_rels\slide$i.xml.rels", $slideRel, [System.Text.Encoding]::UTF8)
}

# ==================== SLIDE 1: PORTADA ====================
$slide1Xml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      
      <!-- Fondo Tarjeta Sutil -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="2" name="Card"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="1143000"/><a:ext cx="10363200" cy="4572000"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1667"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="19050"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
      </p:sp>

      <!-- Badge / Subtitle -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="3" name="Badge"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="1371600" y="1600200"/><a:ext cx="9448800" cy="457200"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1400" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>INSTITUTO TAMABA &#183; C&#193;TEDRA DE CREATIVIDAD E INNOVACI&#211;N</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Main Title -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="4" name="Title"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="1371600" y="2171700"/><a:ext cx="9448800" cy="1143000"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="4400" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>HAT HUMANIZER</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Subtitle Description -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="5" name="Desc"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="1371600" y="3314700"/><a:ext cx="9448800" cy="685800"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1800"><a:solidFill><a:srgbClr val="A1A1AA"/></a:solidFill></a:rPr><a:t>Desarrollo de un Plugin VST3 para Procesamiento DSP y Humanizaci&#243;n Din&#225;mica de Hi-Hats</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Divider line -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="6" name="Line"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="1371600" y="4229100"/><a:ext cx="9448800" cy="0"/></a:xfrm>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
      </p:sp>

      <!-- Footer / Student Info -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="7" name="FooterInfo"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="1371600" y="4572000"/><a:ext cx="9448800" cy="571500"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1400" b="1"><a:solidFill><a:srgbClr val="E4E4E7"/></a:solidFill></a:rPr><a:t>Franco Benedetti</a:t></a:r>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="71717A"/></a:solidFill></a:rPr><a:t> &#183; Grupo: </a:t></a:r>
            <a:r><a:rPr sz="1400" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>Estoc&#225;stico</a:t></a:r>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="71717A"/></a:solidFill></a:rPr><a:t> &#183; Octubre 2026</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

    </p:spTree>
  </p:cSld>
</p:sld>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\slide1.xml", $slide1Xml, [System.Text.Encoding]::UTF8)

# ==================== SLIDE 2: EL PROBLEMA REAL ====================
$slide2Xml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      
      <!-- Slide Header -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="2" name="SecTag"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="685800"/><a:ext cx="10363200" cy="342900"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1200" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>DIAGN&#211;STICO &amp; JUSTIFICACI&#211;N</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>
      <p:sp>
        <p:nvSpPr><p:cNvPr id="3" name="SecTitle"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="1028700"/><a:ext cx="10363200" cy="685800"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="2800" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>La Problem&#225;tica Real en el Estudio</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Columna 1: El Flujo Diario -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="4" name="Box1"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="1943100"/><a:ext cx="4937760" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="288000" tIns="288000" rIns="288000" bIns="288000"/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1800" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>Producci&#243;n Urbana Diaria</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="140000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Produzco beats de Trap y Hip Hop para artistas de EE.UU. de forma continua (benebeats.com).</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="120000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; El hi-hat es el motor r&#237;tmico: define el groove, la velocidad y la energ&#237;a de la pista.</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="120000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Cuantizar 100% sobre la grilla digital genera una sensaci&#243;n artificial y est&#233;ril.</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Columna 2: La Limitación Actual -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="5" name="Box2"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="6339840" y="1943100"/><a:ext cx="4937760" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="288000" tIns="288000" rIns="288000" bIns="288000"/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1800" b="1"><a:solidFill><a:srgbClr val="EF4444"/></a:solidFill></a:rPr><a:t>El Cuello de Botella</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="140000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Humanizar manualmente cada nota (velocity, micro-timing, pitch rolls) toma horas repetitivas.</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="120000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Las herramientas MIDI no sirven para loops cerrados de audio o stems consolidados.</a:t></a:r>
          </a:p>
          <a:p><a:pPr marL="0" spaceBefore="120000"/>
            <a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Necesidad: Procesador de audio din&#225;mico directo con aleatoriedad controlada.</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

    </p:spTree>
  </p:cSld>
</p:sld>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\slide2.xml", $slide2Xml, [System.Text.Encoding]::UTF8)

# ==================== SLIDE 3: LA SOLUCIÓN: HATHUMANIZER ====================
$slide3Xml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      
      <!-- Slide Header -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="2" name="SecTag"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="685800"/><a:ext cx="10363200" cy="342900"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1200" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>PROPUESTA T&#201;CNICA &amp; CREATIVA</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>
      <p:sp>
        <p:nvSpPr><p:cNvPr id="3" name="SecTitle"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="1028700"/><a:ext cx="10363200" cy="685800"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="2800" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>HatHumanizer: C&#243;mo Funciona</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Tarjeta 1: Detección & DSP -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="4" name="Card1"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="1943100"/><a:ext cx="3200400" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="240000" rIns="200000" bIns="200000"/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1600" b="1"><a:solidFill><a:srgbClr val="0EA5E9"/></a:solidFill></a:rPr><a:t>1. Detecci&#243;n &amp; Filtro</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Filtro pasaaltos Butterworth ajustable (150 a 8 000 Hz).</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="100000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; A&#237;sla el hi-hat y rechaza sangrados de bombo o redoblante.</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Tarjeta 2: Humanizador Estocástico -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="5" name="Card2"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="4495800" y="1943100"/><a:ext cx="3200400" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="240000" rIns="200000" bIns="200000"/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1600" b="1"><a:solidFill><a:srgbClr val="10B981"/></a:solidFill></a:rPr><a:t>2. Modulaci&#243;n Viva</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Micro-delay estoc&#225;stico (0 a 30 ms) con interpolaci&#243;n Hermite.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="100000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Fluctuaci&#243;n de ganancia, paneo y afinaci&#243;n org&#225;nica (pitch var).</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Tarjeta 3: Trap Rolls & Print -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="6" name="Card3"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="8077200" y="1943100"/><a:ext cx="3200400" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="240000" rIns="200000" bIns="200000"/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1600" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>3. Trap Rolls &amp; Print</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Redobles sincr&#243;nicos al BPM (1/16 a 1/64) con choke anti-click.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="100000"/><a:r><a:rPr sz="1300"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Metodolog&#237;a: Insertar, ajustar car&#225;cter sonoro y printear toma final.</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

    </p:spTree>
  </p:cSld>
</p:sld>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\slide3.xml", $slide3Xml, [System.Text.Encoding]::UTF8)

# ==================== SLIDE 4: ARQUITECTURA & IA ====================
$slide4Xml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      
      <!-- Slide Header -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="2" name="SecTag"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="685800"/><a:ext cx="10363200" cy="342900"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1200" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>METODOLOG&#205;A DE DESARROLLO</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>
      <p:sp>
        <p:nvSpPr><p:cNvPr id="3" name="SecTitle"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="1028700"/><a:ext cx="10363200" cy="685800"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="2800" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>Ingenier&#237;a DSP &amp; Co-Creaci&#243;n Asistida</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Columna 1: JUCE & C++ -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="4" name="Box1"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="1943100"/><a:ext cx="4937760" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="288000" tIns="288000" rIns="288000" bIns="288000"/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1800" b="1"><a:solidFill><a:srgbClr val="0EA5E9"/></a:solidFill></a:rPr><a:t>Stack Tecnol&#243;gico Industrial</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="140000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Framework JUCE 9.0.2 en C++ nativo de 64 bits.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Audio Thread de latencia cero separado de la interfaz visual.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Gesti&#243;n de memoria lock-free y sincronizaci&#243;n at&#243;mica.</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Columna 2: Rol del Productor e IA -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="5" name="Box2"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="6339840" y="1943100"/><a:ext cx="4937760" cy="4229100"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="288000" tIns="288000" rIns="288000" bIns="288000"/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1800" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>El Rol de la IA (Antigravity)</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="140000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Permite traducir requerimientos ac&#250;sticos a c&#243;digo complejo.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; El productor act&#250;a como arquitecto sonoro, tester y evaluador.</a:t></a:r></a:p>
          <a:p><a:pPr spaceBefore="120000"/><a:r><a:rPr sz="1400"><a:solidFill><a:srgbClr val="D4D4D8"/></a:solidFill></a:rPr><a:t>&#8226; Meta pedag&#243;gica: comprender la arquitectura subyacente.</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

    </p:spTree>
  </p:cSld>
</p:sld>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\slide4.xml", $slide4Xml, [System.Text.Encoding]::UTF8)

# ==================== SLIDE 5: CRONOGRAMA & FUTURO ====================
$slide5Xml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>
      
      <!-- Slide Header -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="2" name="SecTag"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="685800"/><a:ext cx="10363200" cy="342900"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="1200" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>PLAN DE TRABAJO &amp; OBJETIVOS</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>
      <p:sp>
        <p:nvSpPr><p:cNvPr id="3" name="SecTitle"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr><a:xfrm><a:off x="914400" y="1028700"/><a:ext cx="10363200" cy="685800"/></a:xfrm></p:spPr>
        <p:txBody>
          <a:bodyPr/><a:lstStyle/>
          <a:p><a:r><a:rPr sz="2800" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>Secuencia Temporal del Cuatrimestre</a:t></a:r></a:p>
        </p:txBody>
      </p:sp>

      <!-- Fila 1 -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="4" name="Step1"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="1943100"/><a:ext cx="10363200" cy="1143000"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="160000" rIns="200000" bIns="160000"/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="D97706"/></a:solidFill></a:rPr><a:t>Semanas 1 a 4 &#183; </a:t></a:r>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>Prototipado Inicial &amp; Auditor&#237;a del C&#243;digo</a:t></a:r>
          </a:p>
          <a:p><a:pPr spaceBefore="60000"/>
            <a:r><a:rPr sz="1200"><a:solidFill><a:srgbClr val="A1A1AA"/></a:solidFill></a:rPr><a:t>Ensamble del MVP b&#225;sico y estudio l&#237;nea por l&#237;nea de la arquitectura C++ (buffers, interpolaci&#243;n Hermite).</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Fila 2 -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="5" name="Step2"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="3238500"/><a:ext cx="10363200" cy="1143000"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="160000" rIns="200000" bIns="160000"/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="0EA5E9"/></a:solidFill></a:rPr><a:t>Semanas 5 a 6 &#183; </a:t></a:r>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>Banco de Pruebas Ac&#250;stico &amp; Calibraci&#243;n Fina</a:t></a:r>
          </a:p>
          <a:p><a:pPr spaceBefore="60000"/>
            <a:r><a:rPr sz="1200"><a:solidFill><a:srgbClr val="A1A1AA"/></a:solidFill></a:rPr><a:t>Testeo intensivo en sesiones reales de FL Studio/Pro Tools. Eliminaci&#243;n de falsos disparos con snare/kick.</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

      <!-- Fila 3 -->
      <p:sp>
        <p:nvSpPr><p:cNvPr id="6" name="Step3"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
        <p:spPr>
          <a:xfrm><a:off x="914400" y="4533900"/><a:ext cx="10363200" cy="1143000"/></a:xfrm>
          <a:prstGeom prst="roundRect"><a:avLst><a:gd name="adj" fmla="val 1250"/></a:avLst></a:prstGeom>
          <a:solidFill><a:srgbClr val="1C1C1F"/></a:solidFill>
          <a:ln w="12700"><a:solidFill><a:srgbClr val="2E2E33"/></a:ln></a:ln>
        </p:spPr>
        <p:txBody>
          <a:bodyPr lIns="200000" tIns="160000" rIns="200000" bIns="160000"/><a:lstStyle/>
          <a:p>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="10B981"/></a:solidFill></a:rPr><a:t>Semanas 7 a 10 &#183; </a:t></a:r>
            <a:r><a:rPr sz="1500" b="1"><a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill></a:rPr><a:t>Exploraci&#243;n Funcional, UI &amp; Flujo de Printeo</a:t></a:r>
          </a:p>
          <a:p><a:pPr spaceBefore="60000"/>
            <a:r><a:rPr sz="1200"><a:solidFill><a:srgbClr val="A1A1AA"/></a:solidFill></a:rPr><a:t>Explorar adaptaci&#243;n a otros elementos/voces, refinamiento visual vintage e informe final de entrega.</a:t></a:r>
          </a:p>
        </p:txBody>
      </p:sp>

    </p:spTree>
  </p:cSld>
</p:sld>
'@
[System.IO.File]::WriteAllText("$tempDir\ppt\slides\slide5.xml", $slide5Xml, [System.Text.Encoding]::UTF8)

# 10. Comprimir en .pptx
try {
    if (Test-Path $pptxPath) { Remove-Item $pptxPath -Force -ErrorAction Stop }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $pptxPath)
    Write-Output "PPTX creado exitosamente en: $pptxPath"
} catch {
    $altPath = Join-Path $outputDir "Presentacion_HatHumanizer_Estocastico_v1.pptx"
    if (Test-Path $altPath) { Remove-Item $altPath -Force -ErrorAction SilentlyContinue }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $altPath)
    Write-Output "PPTX creado en: $altPath"
}

Remove-Item -Recurse -Force $tempDir
