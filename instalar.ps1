# ============================================================
#  OnAir + Codecs (DMR/TETRA) - Instalador (baixa o OnAir)  PP5RD
#  Baixa o OnAir e o Zadig das fontes oficiais e instala os codecs
#  deste repositorio. Para Windows 64-bit.
# ============================================================
$ErrorActionPreference = 'Stop'
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$base = Split-Path -Parent $MyInvocation.MyCommand.Path

function Passo($m){ Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m){ Write-Host "  [OK] $m" -ForegroundColor Green }
function Aviso($m){ Write-Host "  [!] $m" -ForegroundColor Yellow }

$ONAIR_URL = 'https://github.com/adswill/OnAir/releases/latest/download/OnAir-3.2.0-windows-x64-setup.exe'
$ZADIG_URL = 'https://github.com/pbatard/libwdi/releases/download/v1.5.1/zadig-2.9.exe'

Write-Host "============================================================" -ForegroundColor White
Write-Host " OnAir + Codecs DMR/TETRA  (PP5RD)" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor White

# --- 1. Baixar e instalar o OnAir ---
Passo "OnAir (SDR)"
$onairExe = "$env:ProgramFiles\OnAir\OnAir.exe"
if (Test-Path $onairExe) {
    Ok "OnAir ja instalado"
} else {
    $tmp = Join-Path $env:TEMP 'OnAir-setup.exe'
    Aviso "Baixando o OnAir (pode demorar, ~140 MB)..."
    try { Invoke-WebRequest -Uri $ONAIR_URL -OutFile $tmp -UseBasicParsing; Ok "download ok" }
    catch { Aviso "Falha no download. Baixe manualmente em github.com/adswill/OnAir/releases"; }
    if (Test-Path $tmp) {
        Aviso "Instalando (silencioso)..."
        Start-Process -FilePath $tmp -ArgumentList '/S' -Wait
        if (Test-Path $onairExe) { Ok "OnAir instalado" } else { Aviso "Confira a instalacao do OnAir." }
    }
}

# --- 2. Instalar os codecs ---
Passo "Codecs de voz (DMR AMBE+2 e TETRA)"
$codecsDst = Join-Path $env:LOCALAPPDATA 'OnAir\codecs'
New-Item -ItemType Directory -Path $codecsDst -Force | Out-Null
foreach ($d in @('onair-codec-ambe2.dll','onair-codec-tetra.dll','libmbe-neo.dll','libgcc_s_seh-1.dll','libwinpthread-1.dll')) {
    $s = Join-Path $base "codecs\$d"
    if (Test-Path $s) { Copy-Item $s $codecsDst -Force; Ok $d } else { Aviso "faltando: $d" }
}
Write-Host "  -> $codecsDst" -ForegroundColor Gray

# --- 3. Zadig (driver RTL-SDR) ---
Passo "Zadig (driver do RTL-SDR)"
$zadig = Join-Path $env:USERPROFILE 'Downloads\zadig.exe'
if (-not (Test-Path $zadig)) {
    try { Invoke-WebRequest -Uri $ZADIG_URL -OutFile $zadig -UseBasicParsing; Ok "Zadig baixado para Downloads" }
    catch { Aviso "Baixe o Zadig em zadig.akeo.ie se for usar RTL-SDR." }
} else { Ok "Zadig ja esta em Downloads" }
Aviso "Driver do RTL-SDR e interativo: abra o zadig.exe, Options > List All Devices,"
Write-Host "      selecione 'Bulk-In, Interface (Interface 0)' (USB ID 0BDA 2838), WinUSB > Install." -ForegroundColor Gray

Write-Host "`n[OK] Tudo pronto. Abra o OnAir, escolha DMR ou TETRA e aceite o aviso do codec." -ForegroundColor Green
Write-Host "     So chamadas CLARAS tem audio." -ForegroundColor Gray
Read-Host "ENTER para sair"
