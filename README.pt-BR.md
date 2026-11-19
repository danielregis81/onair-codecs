*[Read in English](README.md)*

# OnAir Codecs - DMR e TETRA

Codecs de voz para o receptor SDR **OnAir** (adswill/OnAir) no Windows 64-bit:

- **DMR / NXDN / dPMR** (AMBE+2) - `onair-codec-ambe2.dll`
- **TETRA** (ACELP) - `onair-codec-tetra.dll`

Ambos são plugins finos construídos em torno do **mbelib-neo**
(https://github.com/arancormonk/mbelib-neo). O OnAir não inclui esses
codecs (são patenteados); você os instala por conta própria.

## Instalação em 1 comando (máquina nova, não precisa baixar nada antes)

Abra o **PowerShell** e cole (baixa OnAir + Zadig + os codecs sozinho):

```powershell
iwr -useb https://raw.githubusercontent.com/danielregis81/onair-codecs/main/instalar-online.ps1 | iex
```

## Instalação rápida (Windows 64-bit)

1. Baixe/clone este repositório (ou baixe o ZIP em Code > Download ZIP).
2. Dê **duplo clique em `INSTALAR.bat`** e aceite o aviso de
   administrador (UAC). O .bat já roda o PowerShell com bypass, então
   você NÃO esbarra no bloqueio de "script não assinado".

   Alternativa pela linha de comando (se preferir):
   ```powershell
   powershell -ExecutionPolicy Bypass -File instalar.ps1
   ```
   Se o Windows ainda reclamar que o arquivo foi baixado, rode antes:
   ```powershell
   Unblock-File instalar.ps1
   ```

3. Abra o OnAir, escolha o modo (DMR ou TETRA) e, na primeira chamada,
   aceite o aviso legal do codec.

Ou, manualmente: copie os 5 arquivos de `codecs/` para
`%LOCALAPPDATA%\OnAir\codecs\` e use "Look again" no OnAir.

## RTL-SDR

Para um dongle RTL-SDR, instale o driver WinUSB com o **Zadig**:
Options > List All Devices, selecione "Bulk-In, Interface (Interface 0)"
(USB ID `0BDA 2838`), driver **WinUSB** > Install.

## Conteúdo

```
codecs/     os 5 .dll prontos (ambe2, tetra, libmbe-neo, 2 runtimes)
src/        código-fonte dos wrappers (onair_tetra_wrapper.c, mbelib_wrapper.c)
build.sh    compila tudo do zero (MSYS2 MINGW64)
instalar.ps1  instalador (baixa OnAir/Zadig, copia codecs)
```

## Compilar do zero

No shell **MSYS2 MINGW64**:

```bash
bash build.sh
```

Gera `codecs/onair-codec-ambe2.dll` e `codecs/onair-codec-tetra.dll`
(mais o `libmbe-neo.dll` e os runtimes do MinGW).

- TETRA: wrapper chama `mbe_tetraDecodeFrame` (137 bits -> 240 samples @ 8 kHz).
- DMR (AMBE+2): wrapper oficial de exemplo do OnAir com `-DCODEC_AMBE2`.
  (Para D-STAR use `-DCODEC_AMBE`; P25 `-DCODEC_IMBE`.)

## IMPORTANTE - áudio só em chamadas claras

Chamadas criptografadas aparecem como "enc"/"encrypted" e **nunca** têm
áudio: o OnAir não entrega chamada cifrada ao codec e nada é
descriptografado. A maioria das redes TETRA de segurança pública é
criptografada.

## Aviso legal / patentes

Os vocoders AMBE/AMBE+2/IMBE e o codec TETRA são patenteados em vários
países; a situação de patentes do mbelib-neo não foi resolvida. A
responsabilidade do uso é sua, conforme a lei do seu país. Este repo
traz binários que você mesmo compila/instala; o OnAir não os inclui nem
distribui.

## Referências

- OnAir: https://github.com/adswill/OnAir (docs/CODECS.md)
- mbelib-neo: https://github.com/arancormonk/mbelib-neo

PP5RD - contato@pp5rd.com.br
