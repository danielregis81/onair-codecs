@echo off
REM Lancador do instalador OnAir + Codecs (PP5RD)
REM O .bat evita o bloqueio de "script nao assinado" do PowerShell.
REM Pede elevacao de administrador e roda o instalar.ps1 com bypass.

echo Iniciando o instalador do OnAir + Codecs (DMR/TETRA)...
echo (vai pedir permissao de administrador)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','\"%~dp0instalar.ps1\"'"
